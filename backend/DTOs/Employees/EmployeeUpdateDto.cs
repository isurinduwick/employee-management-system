using System.ComponentModel.DataAnnotations;
using backend.Models;

namespace backend.DTOs.Employees;

// No Password field here — password changes get their own dedicated endpoint later,
// so a routine profile edit can never accidentally reset a login.
public class EmployeeUpdateDto
{
    [Required, MaxLength(100)]
    public string FirstName { get; set; } = string.Empty;

    [Required, MaxLength(100)]
    public string LastName { get; set; } = string.Empty;

    [Required, EmailAddress]
    public string Email { get; set; } = string.Empty;

    [Phone]
    public string? PhoneNumber { get; set; }

    [Required]
    public int DepartmentId { get; set; }

    [Required]
    public Role Role { get; set; }

    public int? ManagerId { get; set; }

    public bool IsActive { get; set; } = true;
}
