using System.ComponentModel.DataAnnotations;
using backend.Models;

namespace backend.DTOs.Employees;

public class EmployeeCreateDto
{
    [Required, MaxLength(20)]
    public string EmployeeCode { get; set; } = string.Empty;

    [Required, MaxLength(100)]
    public string FirstName { get; set; } = string.Empty;

    [Required, MaxLength(100)]
    public string LastName { get; set; } = string.Empty;

    [Required, EmailAddress]
    public string Email { get; set; } = string.Empty;

    // Plaintext in transit only (over HTTPS) — hashed server-side before it ever reaches the DB.
    [Required, MinLength(8)]
    public string Password { get; set; } = string.Empty;

    [Phone]
    public string? PhoneNumber { get; set; }

    [Required]
    public int DepartmentId { get; set; }

    [Required]
    public Role Role { get; set; }

    // Optional: top-of-hierarchy employees (e.g. the first Admin) have no manager.
    public int? ManagerId { get; set; }
}
