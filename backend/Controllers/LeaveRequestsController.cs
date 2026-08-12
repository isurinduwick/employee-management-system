using System.Security.Claims;
using backend.Data;
using backend.DTOs.Leave;
using backend.Models;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace backend.Controllers;

[ApiController]
[Route("api/leave-requests")]
[Authorize]
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
    [HttpPost]
    public async Task<ActionResult<LeaveResponseDto>> Create(LeaveRequestCreateDto dto)
    {
        if (dto.EndDate < dto.StartDate)
        {
            return BadRequest("EndDate cannot be before StartDate.");
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
    [HttpGet]
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
