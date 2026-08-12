using System.ComponentModel.DataAnnotations;
using backend.Models;

namespace backend.DTOs.Leave;

public class LeaveDecisionDto
{
    // Must be Approved or Rejected — Pending is rejected in the controller,
    // since it isn't a valid decision to submit.
    [Required]
    public LeaveStatus Status { get; set; }
}
