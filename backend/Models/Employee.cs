namespace backend.Models;

public class Employee
{
    public int Id { get; set; }

    // Business-facing identifier (e.g. "EMP-0001"), distinct from the internal Id PK.
    public string EmployeeCode { get; set; } = string.Empty;

    public string FirstName { get; set; } = string.Empty;

    public string LastName { get; set; } = string.Empty;

    public string Email { get; set; } = string.Empty;

    // BCrypt hash only — the raw password is never stored or logged.
    public string PasswordHash { get; set; } = string.Empty;

    public string? PhoneNumber { get; set; }

    public int DepartmentId { get; set; }

    public Department Department { get; set; } = null!;

    public Role Role { get; set; } = Role.Employee;

    // Self-referencing FK: nullable because top-of-hierarchy employees (e.g. Admin) report to no one.
    public int? ManagerId { get; set; }

    public Employee? Manager { get; set; }

    // The inverse side of the self-reference: everyone who reports to this employee.
    public ICollection<Employee> Subordinates { get; set; } = new List<Employee>();

    public bool IsActive { get; set; } = true;

    public DateTime CreatedAt { get; set; } = DateTime.UtcNow;

    public ICollection<AttendanceLog> AttendanceLogs { get; set; } = new List<AttendanceLog>();

    // Leave requests this employee submitted.
    public ICollection<LeaveRequest> LeaveRequests { get; set; } = new List<LeaveRequest>();

    // Leave requests this employee approved/rejected as a manager — a second, independent
    // relationship back to Employee, separate from the requester relationship above.
    public ICollection<LeaveRequest> ApprovedLeaveRequests { get; set; } = new List<LeaveRequest>();
}
