using System.Security.Claims;
using backend.Data;
using backend.DTOs.Attendance;
using backend.Models;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace backend.Controllers;

[ApiController]
[Route("api/attendance")]
[Authorize]
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
    [HttpPost("check-in")]
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
    [HttpPost("check-out")]
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
