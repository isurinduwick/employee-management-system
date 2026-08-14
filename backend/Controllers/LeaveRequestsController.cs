using System.Security.Claims;
using backend.Data;
using backend.DTOs.Leave;
using backend.Models;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace backend.Controllers;

/// <summary>
/// Leave requests and the Manager/Admin approval workflow.
/// </summary>
[ApiController]
[Route("api/leave-requests")]
[Authorize]
[Produces("application/json")]
public class LeaveRequestsController : ControllerBase
{
    private readonly ApplicationDbContext _db;

    public LeaveRequestsController(ApplicationDbContext db)
    {
        _db = db;
    }

    // Same rule as Attendance: who's submitting comes from the validated JWT,
    // never from the request body — an employee can only ever request leave for themself.
    private int CurrentEmployeeId => int.Parse(User.FindFirstValue(ClaimTypes.NameIdentifier)!);

    private string CurrentEmployeeName => User.FindFirstValue(ClaimTypes.Name) ?? string.Empty;

    // POST /api/leave-requests — any authenticated role. Always created as Pending;
    // only the decision endpoint (Manager/Admin) can move it to Approved/Rejected.
    /// <summary>
    /// Submits a new leave request for the authenticated employee.
    /// </summary>
    /// <remarks>
    /// Any authenticated role. Always created for the caller's own id (from the JWT) and always
    /// starts as <c>Pending</c> — only the decision endpoint can move it to
    /// <c>Approved</c>/<c>Rejected</c>. Returns 400 if <c>EndDate</c> is before <c>StartDate</c>.
    /// </remarks>
    [HttpPost]
    [ProducesResponseType(typeof(LeaveResponseDto), StatusCodes.Status201Created)]
    [ProducesResponseType(typeof(ValidationProblemDetails), StatusCodes.Status400BadRequest)]
    [ProducesResponseType(StatusCodes.Status401Unauthorized)]
    public async Task<ActionResult<LeaveResponseDto>> Create(LeaveRequestCreateDto dto)
    {
        if (dto.EndDate < dto.StartDate)
        {
            return Problem(detail: "EndDate cannot be before StartDate.", statusCode: StatusCodes.Status400BadRequest);
        }

        var leaveRequest = new LeaveRequest
        {
            EmployeeId = CurrentEmployeeId,
            LeaveType = dto.LeaveType,
            StartDate = dto.StartDate,
            EndDate = dto.EndDate,
            Reason = dto.Reason,
            Status = LeaveStatus.Pending
        };

        _db.LeaveRequests.Add(leaveRequest);
        await _db.SaveChangesAsync();

        return Created($"/api/leave-requests/{leaveRequest.Id}", ToResponseDto(leaveRequest, CurrentEmployeeName, null));
    }

    // GET /api/leave-requests?employeeId=&status= — an Employee only ever sees their
    // own requests (employeeId from the query string is ignored for that role, same
    // rule as Attendance's history endpoint); Manager/Admin can filter across everyone.
    /// <summary>
    /// Lists leave requests, optionally filtered by employee and status.
    /// </summary>
    /// <remarks>
    /// Role-scoped visibility: an <c>Employee</c> always sees only their own requests — the
    /// <paramref name="employeeId"/> filter is silently ignored for that role, same rule as
    /// Attendance's history endpoint. <c>Manager</c>/<c>Admin</c> may filter across everyone's
    /// requests. <paramref name="status"/> (<c>Pending</c>/<c>Approved</c>/<c>Rejected</c>)
    /// applies to every role.
    /// </remarks>
    [HttpGet]
    [ProducesResponseType(typeof(List<LeaveResponseDto>), StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status401Unauthorized)]
    public async Task<ActionResult<List<LeaveResponseDto>>> GetAll(
        [FromQuery] int? employeeId,
        [FromQuery] LeaveStatus? status)
    {
        var query = _db.LeaveRequests
            .Include(l => l.Employee)
            .Include(l => l.ApprovedBy)
            .AsQueryable();

        if (User.IsInRole("Employee"))
        {
            query = query.Where(l => l.EmployeeId == CurrentEmployeeId);
        }
        else if (employeeId.HasValue)
        {
            query = query.Where(l => l.EmployeeId == employeeId.Value);
        }

        if (status.HasValue)
        {
            query = query.Where(l => l.Status == status.Value);
        }

        var requests = await query.OrderByDescending(l => l.AppliedOn).ToListAsync();

        return Ok(requests.Select(l => ToResponseDto(
            l,
            $"{l.Employee.FirstName} {l.Employee.LastName}",
            l.ApprovedBy is null ? null : $"{l.ApprovedBy.FirstName} {l.ApprovedBy.LastName}")));
    }

    // PUT /api/leave-requests/5/decision — Manager or Admin. A Manager may only decide
    // on their own direct reports' requests (checked via Employee.ManagerId); Admin can
    // decide on anyone's. One decision per request — a second call is rejected with 409.
    /// <summary>
    /// Approves or rejects a pending leave request.
    /// </summary>
    /// <remarks>
    /// Manager or Admin only. A <c>Manager</c> may only decide on their own direct reports'
    /// requests (checked via the employee's <c>ManagerId</c>) — deciding on someone outside their
    /// team returns 403; <c>Admin</c> can decide on anyone's. <c>Status</c> must be
    /// <c>Approved</c> or <c>Rejected</c> (400 for <c>Pending</c>). Only one decision is allowed
    /// per request — deciding on a request that isn't currently <c>Pending</c> returns 409.
    /// </remarks>
    [HttpPut("{id:int}/decision")]
    [Authorize(Roles = "Manager,Admin")]
    [ProducesResponseType(typeof(LeaveResponseDto), StatusCodes.Status200OK)]
    [ProducesResponseType(typeof(ProblemDetails), StatusCodes.Status400BadRequest)]
    [ProducesResponseType(StatusCodes.Status401Unauthorized)]
    [ProducesResponseType(typeof(ProblemDetails), StatusCodes.Status403Forbidden)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    [ProducesResponseType(typeof(ProblemDetails), StatusCodes.Status409Conflict)]
    public async Task<ActionResult<LeaveResponseDto>> Decide(int id, LeaveDecisionDto dto)
    {
        if (dto.Status == LeaveStatus.Pending)
        {
            return Problem(detail: "Decision must be Approved or Rejected.", statusCode: StatusCodes.Status400BadRequest);
        }

        var leaveRequest = await _db.LeaveRequests
            .Include(l => l.Employee)
            .FirstOrDefaultAsync(l => l.Id == id);

        if (leaveRequest is null) return NotFound();

        if (leaveRequest.Status != LeaveStatus.Pending)
        {
            return Problem(detail: "This leave request has already been decided.", statusCode: StatusCodes.Status409Conflict);
        }

        if (User.IsInRole("Manager") && leaveRequest.Employee.ManagerId != CurrentEmployeeId)
        {
            return Problem(detail: "You can only decide on your own team's leave requests.", statusCode: StatusCodes.Status403Forbidden);
        }

        leaveRequest.Status = dto.Status;
        leaveRequest.ApprovedById = CurrentEmployeeId;
        await _db.SaveChangesAsync();

        var employeeName = $"{leaveRequest.Employee.FirstName} {leaveRequest.Employee.LastName}";
        return Ok(ToResponseDto(leaveRequest, employeeName, CurrentEmployeeName));
    }

    private static LeaveResponseDto ToResponseDto(LeaveRequest request, string employeeName, string? approvedByName) => new()
    {
        Id = request.Id,
        EmployeeId = request.EmployeeId,
        EmployeeName = employeeName,
        LeaveType = request.LeaveType.ToString(),
        StartDate = request.StartDate,
        EndDate = request.EndDate,
        Reason = request.Reason,
        Status = request.Status.ToString(),
        ApprovedById = request.ApprovedById,
        ApprovedByName = approvedByName,
        AppliedOn = request.AppliedOn
    };
}
