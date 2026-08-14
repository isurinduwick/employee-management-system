using System.Security.Claims;
using backend.Data;
using backend.DTOs.Attendance;
using backend.Models;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace backend.Controllers;

/// <summary>
/// Daily attendance: self-service check-in/check-out and history.
/// </summary>
[ApiController]
[Route("api/attendance")]
[Authorize]
[Produces("application/json")]
public class AttendanceController : ControllerBase
{
    private readonly ApplicationDbContext _db;

    public AttendanceController(ApplicationDbContext db)
    {
        _db = db;
    }

    // Who's calling comes from the validated JWT, never from the request body —
    // otherwise anyone could check in on someone else's behalf just by passing a
    // different employeeId.
    private int CurrentEmployeeId => int.Parse(User.FindFirstValue(ClaimTypes.NameIdentifier)!);

    private string CurrentEmployeeName => User.FindFirstValue(ClaimTypes.Name) ?? string.Empty;

    // POST /api/attendance/check-in — any authenticated role, always for yourself.
    /// <summary>
    /// Checks the authenticated employee in for today.
    /// </summary>
    /// <remarks>
    /// Any authenticated role. Always acts on the caller's own id (from the JWT) — there is no
    /// way to check someone else in. <c>DeviceType</c> records where the check-in came from
    /// (<c>Web</c> or <c>Mobile</c>). Only one check-in per employee per calendar day is allowed;
    /// a second attempt returns 409.
    /// </remarks>
    [HttpPost("check-in")]
    [ProducesResponseType(typeof(AttendanceResponseDto), StatusCodes.Status201Created)]
    [ProducesResponseType(typeof(ValidationProblemDetails), StatusCodes.Status400BadRequest)]
    [ProducesResponseType(StatusCodes.Status401Unauthorized)]
    [ProducesResponseType(typeof(string), StatusCodes.Status409Conflict)]
    public async Task<ActionResult<AttendanceResponseDto>> CheckIn(CheckInDto dto)
    {
        var employeeId = CurrentEmployeeId;
        var today = DateOnly.FromDateTime(DateTime.UtcNow);

        // The unique (EmployeeId, WorkDate) index means one row per person per day —
        // check-out updates this same row later, so a second check-in today is rejected here.
        var alreadyCheckedIn = await _db.AttendanceLogs
            .AnyAsync(a => a.EmployeeId == employeeId && a.WorkDate == today);

        if (alreadyCheckedIn)
        {
            return Conflict("Already checked in today.");
        }

        var log = new AttendanceLog
        {
            EmployeeId = employeeId,
            WorkDate = today,
            CheckInTime = DateTime.UtcNow,
            Status = AttendanceStatus.Present,
            DeviceType = dto.DeviceType
        };

        _db.AttendanceLogs.Add(log);
        await _db.SaveChangesAsync();

        return Created($"/api/attendance/{log.Id}", ToResponseDto(log, CurrentEmployeeName));
    }

    // POST /api/attendance/check-out — updates today's existing row (from check-in),
    // it never creates a new one; that's what the unique (EmployeeId, WorkDate) index enforces.
    /// <summary>
    /// Checks the authenticated employee out for today.
    /// </summary>
    /// <remarks>
    /// Any authenticated role. Takes no request body — it closes the caller's own currently-open
    /// attendance record for today (the row created by check-in), rather than creating a new one.
    /// Returns 400 if the caller hasn't checked in today, and 409 if they've already checked out.
    /// </remarks>
    [HttpPost("check-out")]
    [ProducesResponseType(typeof(AttendanceResponseDto), StatusCodes.Status200OK)]
    [ProducesResponseType(typeof(string), StatusCodes.Status400BadRequest)]
    [ProducesResponseType(StatusCodes.Status401Unauthorized)]
    [ProducesResponseType(typeof(string), StatusCodes.Status409Conflict)]
    public async Task<ActionResult<AttendanceResponseDto>> CheckOut()
    {
        var employeeId = CurrentEmployeeId;
        var today = DateOnly.FromDateTime(DateTime.UtcNow);

        var log = await _db.AttendanceLogs
            .FirstOrDefaultAsync(a => a.EmployeeId == employeeId && a.WorkDate == today);

        if (log is null)
        {
            return BadRequest("You haven't checked in today.");
        }

        if (log.CheckOutTime is not null)
        {
            return Conflict("Already checked out today.");
        }

        log.CheckOutTime = DateTime.UtcNow;
        await _db.SaveChangesAsync();

        return Ok(ToResponseDto(log, CurrentEmployeeName));
    }

    // GET /api/attendance?employeeId=&departmentId=&startDate=&endDate= — the
    // "queryable attendance history" requirement. An Employee can only ever see
    // their own history: employeeId/departmentId from the query string are ignored
    // for that role rather than trusted, since the caller could pass anyone's id.
    // Manager/Admin can filter freely across the whole company.
    /// <summary>
    /// Lists attendance records, optionally filtered by employee, department, and date range.
    /// </summary>
    /// <remarks>
    /// Role-scoped visibility: an <c>Employee</c> always sees only their own records — the
    /// <paramref name="employeeId"/> and <paramref name="departmentId"/> filters are silently
    /// ignored for that role rather than honoured, since the caller could otherwise pass anyone's
    /// id. <c>Manager</c>/<c>Admin</c> may filter freely across the whole company.
    /// <paramref name="startDate"/>/<paramref name="endDate"/> are inclusive on both ends and
    /// apply to every role.
    /// </remarks>
    [HttpGet]
    [ProducesResponseType(typeof(List<AttendanceResponseDto>), StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status401Unauthorized)]
    public async Task<ActionResult<List<AttendanceResponseDto>>> GetAll(
        [FromQuery] int? employeeId,
        [FromQuery] int? departmentId,
        [FromQuery] DateOnly? startDate,
        [FromQuery] DateOnly? endDate)
    {
        var query = _db.AttendanceLogs.Include(a => a.Employee).AsQueryable();

        if (User.IsInRole("Employee"))
        {
            query = query.Where(a => a.EmployeeId == CurrentEmployeeId);
        }
        else
        {
            if (employeeId.HasValue) query = query.Where(a => a.EmployeeId == employeeId.Value);
            if (departmentId.HasValue) query = query.Where(a => a.Employee.DepartmentId == departmentId.Value);
        }

        if (startDate.HasValue) query = query.Where(a => a.WorkDate >= startDate.Value);
        if (endDate.HasValue) query = query.Where(a => a.WorkDate <= endDate.Value);

        var logs = await query.OrderByDescending(a => a.WorkDate).ToListAsync();

        return Ok(logs.Select(l => ToResponseDto(l, $"{l.Employee.FirstName} {l.Employee.LastName}")));
    }

    private static AttendanceResponseDto ToResponseDto(AttendanceLog log, string employeeName) => new()
    {
        Id = log.Id,
        EmployeeId = log.EmployeeId,
        EmployeeName = employeeName,
        CheckInTime = log.CheckInTime,
        CheckOutTime = log.CheckOutTime,
        WorkDate = log.WorkDate,
        Status = log.Status.ToString(),
        DeviceType = log.DeviceType.ToString()
    };
}
