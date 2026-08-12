using backend.Data;
using backend.DTOs.Auth;
using backend.Helpers;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace backend.Controllers;

[ApiController]
[Route("api/auth")]
public class AuthController : ControllerBase
{
    private readonly ApplicationDbContext _db;
    private readonly JwtTokenGenerator _tokenGenerator;

    public AuthController(ApplicationDbContext db, JwtTokenGenerator tokenGenerator)
    {
        _db = db;
        _tokenGenerator = tokenGenerator;
    }

    [HttpPost("login")]
    public async Task<ActionResult<LoginResponseDto>> Login(LoginRequestDto request)
    {
        var employee = await _db.Employees.FirstOrDefaultAsync(e => e.Email == request.Email);

        if (employee is null || !employee.IsActive || !PasswordHasher.Verify(request.Password, employee.PasswordHash))
        {
            return Unauthorized("Invalid email or password.");
        }

        var (token, expiresAt) = _tokenGenerator.GenerateToken(employee);

        return Ok(new LoginResponseDto
        {
            Token = token,
            ExpiresAt = expiresAt,
            EmployeeId = employee.Id,
            FullName = $"{employee.FirstName} {employee.LastName}",
            Role = employee.Role.ToString()
        });
    }
}
