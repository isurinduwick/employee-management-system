using backend.Data;
using backend.DTOs.Auth;
using backend.Helpers;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace backend.Controllers;

/// <summary>
/// Authentication. Issues the JWT that every other endpoint requires.
/// </summary>
[ApiController]
[Route("api/auth")]
[Produces("application/json")]
public class AuthController : ControllerBase
{
    private readonly ApplicationDbContext _db;
    private readonly JwtTokenGenerator _tokenGenerator;

    public AuthController(ApplicationDbContext db, JwtTokenGenerator tokenGenerator)
    {
        _db = db;
        _tokenGenerator = tokenGenerator;
    }

    // POST /api/auth/login — the only public endpoint in the whole API; everything
    // else requires the token this returns. Deliberately vague on failure ("Invalid
    // email or password") rather than saying which one was wrong, so a caller can't
    // use the error message to figure out which emails exist in the system.
    /// <summary>
    /// Logs in with an email and password and returns a JWT.
    /// </summary>
    /// <remarks>
    /// Anonymous — no token required to call this endpoint. The returned token must be sent as
    /// <c>Authorization: Bearer &lt;token&gt;</c> on every other request. Deactivated accounts
    /// (<c>IsActive = false</c>) are rejected the same as a wrong password.
    /// </remarks>
    [HttpPost("login")]
    [ProducesResponseType(typeof(LoginResponseDto), StatusCodes.Status200OK)]
    [ProducesResponseType(typeof(ValidationProblemDetails), StatusCodes.Status400BadRequest)]
    [ProducesResponseType(typeof(string), StatusCodes.Status401Unauthorized)]
    public async Task<ActionResult<LoginResponseDto>> Login(LoginRequestDto request)
    {
        var employee = await _db.Employees.FirstOrDefaultAsync(e => e.Email == request.Email);

        if (employee is null || !employee.IsActive || !PasswordHasher.Verify(request.Password, employee.PasswordHash))
        {
            return Unauthorized("Invalid email or password.");
        }

        // The token carries everything downstream code needs (id, name, role) — no
        // session is stored server-side, so nothing else here needs to be remembered.
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
