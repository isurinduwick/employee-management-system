using System.ComponentModel.DataAnnotations;

namespace backend.DTOs.Departments;

public class DepartmentCreateDto
{
    [Required, MaxLength(100)]
    public string Name { get; set; } = string.Empty;
}
