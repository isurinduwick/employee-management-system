namespace backend.Models;

public class AttendanceLog
{
    public int Id { get; set; }

    public int EmployeeId { get; set; }

    public Employee Employee { get; set; } = null!;

    public DateTime? CheckInTime { get; set; }

    public DateTime? CheckOutTime { get; set; }

    // Calendar day this record belongs to (date-only, so multiple check-in/out pairs
    // on the same day update a single row instead of creating duplicates).
    public DateOnly WorkDate { get; set; }

    public AttendanceStatus Status { get; set; }

    public DeviceType DeviceType { get; set; }
}
