namespace backend.Models;

public class LeaveRequest
{
    public int Id { get; set; }

    // The employee requesting leave.
    public int EmployeeId { get; set; }

    public Employee Employee { get; set; } = null!;

    public LeaveType LeaveType { get; set; }

    public DateOnly StartDate { get; set; }

    public DateOnly EndDate { get; set; }

    public string? Reason { get; set; }

    public LeaveStatus Status { get; set; } = LeaveStatus.Pending;

    // Nullable: unset while Pending, populated with the approving Manager/Admin's Id once decided.
    public int? ApprovedById { get; set; }

    public Employee? ApprovedBy { get; set; }

    public DateTime AppliedOn { get; set; } = DateTime.UtcNow;
}
