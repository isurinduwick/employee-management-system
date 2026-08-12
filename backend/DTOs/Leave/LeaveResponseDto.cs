namespace backend.DTOs.Leave;

public class LeaveResponseDto
{
    public int Id { get; set; }

    public int EmployeeId { get; set; }

    public string EmployeeName { get; set; } = string.Empty;

    public string LeaveType { get; set; } = string.Empty;

    public DateOnly StartDate { get; set; }

    public DateOnly EndDate { get; set; }

    public string? Reason { get; set; }

    public string Status { get; set; } = string.Empty;

    public int? ApprovedById { get; set; }

    public string? ApprovedByName { get; set; }

    public DateTime AppliedOn { get; set; }
}
