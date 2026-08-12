using System.ComponentModel.DataAnnotations;
using backend.Models;

namespace backend.DTOs.Attendance;

public class CheckInDto
{
    [Required]
    public DeviceType DeviceType { get; set; }
}
