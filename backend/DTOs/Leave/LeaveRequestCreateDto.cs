using System.ComponentModel.DataAnnotations;
using backend.Models;

namespace backend.DTOs.Leave;

public class LeaveRequestCreateDto
{
    [Required]
    public LeaveType LeaveType { get; set; }

    [Required]
    public DateOnly StartDate { get; set; }

    [Required]
    public DateOnly EndDate { get; set; }

    [MaxLength(500)]
    public string? Reason { get; set; }
}
