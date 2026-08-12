namespace backend.DTOs.Attendance;

public class AttendanceResponseDto
{
    public int Id { get; set; }

    public int EmployeeId { get; set; }

    public string EmployeeName { get; set; } = string.Empty;

    public DateTime? CheckInTime { get; set; }

    public DateTime? CheckOutTime { get; set; }

    public DateOnly WorkDate { get; set; }

    public string Status { get; set; } = string.Empty;

    public string DeviceType { get; set; } = string.Empty;
}
