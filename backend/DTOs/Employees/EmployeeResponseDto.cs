namespace backend.DTOs.Employees;

// Never includes PasswordHash — this is what actually crosses the wire to clients.
public class EmployeeResponseDto
{
    public int Id { get; set; }

    public string EmployeeCode { get; set; } = string.Empty;

    public string FirstName { get; set; } = string.Empty;

    public string LastName { get; set; } = string.Empty;

    public string Email { get; set; } = string.Empty;

    public string? PhoneNumber { get; set; }

    public int DepartmentId { get; set; }

    public string DepartmentName { get; set; } = string.Empty;

    public string Role { get; set; } = string.Empty;

    public int? ManagerId { get; set; }

    public string? ManagerName { get; set; }

    public bool IsActive { get; set; }

    public DateTime CreatedAt { get; set; }
}
