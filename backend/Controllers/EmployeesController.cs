using backend.Data;
using backend.DTOs.Employees;
using backend.Helpers;
using backend.Models;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace backend.Controllers;

// [Authorize] at class level: every action requires a valid JWT by default.
// Individual write actions add [Authorize(Roles = "Admin")] on top to further
// restrict who can call them; reads stay open to any authenticated role.
/// <summary>
/// Employee directory: profiles, roles, department assignment, and the manager hierarchy.
/// </summary>
[ApiController]
[Route("api/employees")]
[Authorize]
[Produces("application/json")]
public class EmployeesController : ControllerBase
{
    private readonly ApplicationDbContext _db;

    public EmployeesController(ApplicationDbContext db)
    {
        _db = db;
    }

    // Department/Manager are navigation properties, not stored on the Employee row —
    // EF Core only fetches them if explicitly told to with .Include(). Every action
    // that needs to show a DepartmentName/ManagerName in the response goes through here.
    private IQueryable<Employee> WithRelations =>
        _db.Employees.Include(e => e.Department).Include(e => e.Manager);

    // GET /api/employees?departmentId=2 — list everyone, optionally scoped to one department.
    /// <summary>
    /// Lists employees, optionally filtered to a single department.
    /// </summary>
    /// <remarks>
    /// Any authenticated role (Admin, Manager, or Employee) may call this.
    /// </remarks>
    [HttpGet]
    [ProducesResponseType(typeof(List<EmployeeResponseDto>), StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status401Unauthorized)]
    public async Task<ActionResult<List<EmployeeResponseDto>>> GetAll([FromQuery] int? departmentId)
    {
        var query = WithRelations;
        if (departmentId.HasValue)
        {
            query = query.Where(e => e.DepartmentId == departmentId.Value);
        }

        var employees = await query.OrderBy(e => e.EmployeeCode).ToListAsync();
        return Ok(employees.Select(ToResponseDto));
    }

    // GET /api/employees/5 — a single employee, or 404 if the id doesn't exist.
    /// <summary>
    /// Gets a single employee by id.
    /// </summary>
    /// <remarks>
    /// Any authenticated role may call this. The response includes the employee's manager
    /// (via <c>ManagerId</c>/<c>ManagerName</c>), part of the self-referencing manager hierarchy.
    /// </remarks>
    [HttpGet("{id:int}")]
    [ProducesResponseType(typeof(EmployeeResponseDto), StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status401Unauthorized)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    public async Task<ActionResult<EmployeeResponseDto>> GetById(int id)
    {
        var employee = await WithRelations.FirstOrDefaultAsync(e => e.Id == id);
        return employee is null ? NotFound() : Ok(ToResponseDto(employee));
    }

    // POST /api/employees — Admin only. Creates a brand-new login: hashes the
    // plaintext password from the DTO before it ever touches the database.
    /// <summary>
    /// Creates a new employee (and their login).
    /// </summary>
    /// <remarks>
    /// Admin only. <c>DepartmentId</c> and, if provided, <c>ManagerId</c> must reference
    /// existing employees/departments (400 otherwise), and an employee cannot be created as
    /// their own manager. A duplicate <c>Email</c> or <c>EmployeeCode</c> returns 409.
    /// </remarks>
    [HttpPost]
    [Authorize(Roles = "Admin")]
    [ProducesResponseType(typeof(EmployeeResponseDto), StatusCodes.Status201Created)]
    [ProducesResponseType(typeof(ValidationProblemDetails), StatusCodes.Status400BadRequest)]
    [ProducesResponseType(StatusCodes.Status401Unauthorized)]
    [ProducesResponseType(StatusCodes.Status403Forbidden)]
    [ProducesResponseType(typeof(ProblemDetails), StatusCodes.Status409Conflict)]
    public async Task<ActionResult<EmployeeResponseDto>> Create(EmployeeCreateDto dto)
    {
        var (department, manager, error) = await ValidateRelationsAsync(dto.DepartmentId, dto.ManagerId);
        if (error is not null) return error;

        if (await EmailInUseAsync(dto.Email))
        {
            return Problem(detail: $"Email '{dto.Email}' is already in use.", statusCode: StatusCodes.Status409Conflict);
        }
        if (await _db.Employees.AnyAsync(e => e.EmployeeCode == dto.EmployeeCode))
        {
            return Problem(detail: $"Employee code '{dto.EmployeeCode}' is already in use.", statusCode: StatusCodes.Status409Conflict);
        }

        var employee = new Employee
        {
            EmployeeCode = dto.EmployeeCode,
            FirstName = dto.FirstName,
            LastName = dto.LastName,
            Email = dto.Email,
            PasswordHash = PasswordHasher.HashPassword(dto.Password),
            PhoneNumber = dto.PhoneNumber,
            DepartmentId = dto.DepartmentId,
            Role = dto.Role,
            ManagerId = dto.ManagerId,
            // Setting the navigation properties (not just the *Id fields) means the
            // response DTO below can read DepartmentName/ManagerName immediately,
            // without a second round-trip to the database.
            Department = department!,
            Manager = manager
        };

        _db.Employees.Add(employee);
        await _db.SaveChangesAsync();

        return Created($"/api/employees/{employee.Id}", ToResponseDto(employee));
    }

    // PUT /api/employees/5 — Admin only. No password field here on purpose (see
    // EmployeeUpdateDto) — changing a password is a separate, dedicated flow.
    /// <summary>
    /// Updates an existing employee's profile, department, role, manager, and active status.
    /// </summary>
    /// <remarks>
    /// Admin only. Does not change the password (there is no dedicated password-change endpoint
    /// yet). Same <c>DepartmentId</c>/<c>ManagerId</c> validation as create, plus an employee
    /// cannot be set as their own manager. A duplicate <c>Email</c> (belonging to another
    /// employee) returns 409.
    /// </remarks>
    [HttpPut("{id:int}")]
    [Authorize(Roles = "Admin")]
    [ProducesResponseType(typeof(EmployeeResponseDto), StatusCodes.Status200OK)]
    [ProducesResponseType(typeof(ValidationProblemDetails), StatusCodes.Status400BadRequest)]
    [ProducesResponseType(StatusCodes.Status401Unauthorized)]
    [ProducesResponseType(StatusCodes.Status403Forbidden)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    [ProducesResponseType(typeof(ProblemDetails), StatusCodes.Status409Conflict)]
    public async Task<ActionResult<EmployeeResponseDto>> Update(int id, EmployeeUpdateDto dto)
    {
        var employee = await WithRelations.FirstOrDefaultAsync(e => e.Id == id);
        if (employee is null) return NotFound();

        var (department, manager, error) = await ValidateRelationsAsync(dto.DepartmentId, dto.ManagerId, selfId: id);
        if (error is not null) return error;

        if (await EmailInUseAsync(dto.Email, excludeId: id))
        {
            return Problem(detail: $"Email '{dto.Email}' is already in use.", statusCode: StatusCodes.Status409Conflict);
        }

        employee.FirstName = dto.FirstName;
        employee.LastName = dto.LastName;
        employee.Email = dto.Email;
        employee.PhoneNumber = dto.PhoneNumber;
        employee.DepartmentId = dto.DepartmentId;
        employee.Department = department!;
        employee.Role = dto.Role;
        employee.ManagerId = dto.ManagerId;
        employee.Manager = manager;
        employee.IsActive = dto.IsActive;

        await _db.SaveChangesAsync();
        return Ok(ToResponseDto(employee));
    }

    // DELETE /api/employees/5 — Admin only. Soft delete: attendance/leave history
    // stays intact, the employee simply stops being able to log in / show up in
    // active lists (IsActive = false), instead of removing the row outright.
    /// <summary>
    /// Deactivates an employee.
    /// </summary>
    /// <remarks>
    /// Admin only. This is a soft delete — sets <c>IsActive = false</c> rather than removing the
    /// row, so attendance and leave history are preserved and the employee can still appear as a
    /// historical manager/approver.
    /// </remarks>
    [HttpDelete("{id:int}")]
    [Authorize(Roles = "Admin")]
    [ProducesResponseType(StatusCodes.Status204NoContent)]
    [ProducesResponseType(StatusCodes.Status401Unauthorized)]
    [ProducesResponseType(StatusCodes.Status403Forbidden)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    public async Task<IActionResult> Deactivate(int id)
    {
        var employee = await _db.Employees.FindAsync(id);
        if (employee is null) return NotFound();

        employee.IsActive = false;
        await _db.SaveChangesAsync();
        return NoContent();
    }

    // Shared by Create and Update, so the "does this department/manager actually
    // exist" rule only lives in one place. Returns either the looked-up entities
    // (Error is null → safe to proceed) or an Error result the caller should
    // return immediately (BadRequest — the entities will be null in that case).
    // selfId is only passed by Update, to block an employee from managing themself.
    private async Task<(Department? Department, Employee? Manager, ActionResult? Error)> ValidateRelationsAsync(
        int departmentId, int? managerId, int? selfId = null)
    {
        if (managerId.HasValue && managerId == selfId)
        {
            return (null, null, Problem(detail: "An employee cannot be their own manager.", statusCode: StatusCodes.Status400BadRequest));
        }

        var department = await _db.Departments.FindAsync(departmentId);
        if (department is null)
        {
            return (null, null, Problem(detail: $"Department {departmentId} does not exist.", statusCode: StatusCodes.Status400BadRequest));
        }

        Employee? manager = null;
        if (managerId.HasValue)
        {
            manager = await _db.Employees.FindAsync(managerId.Value);
            if (manager is null)
            {
                return (null, null, Problem(detail: $"Manager {managerId} does not exist.", statusCode: StatusCodes.Status400BadRequest));
            }
        }

        return (department, manager, null);
    }

    // excludeId is null on Create (nothing to exclude) and the employee's own id on
    // Update (so an employee keeping their existing email doesn't conflict with themself).
    // e.Id is never null, so "e.Id != null" (the excludeId == null case) is always true —
    // i.e. no rows get excluded, which is exactly what Create needs.
    private async Task<bool> EmailInUseAsync(string email, int? excludeId = null) =>
        await _db.Employees.AnyAsync(e => e.Email == email && e.Id != excludeId);

    // Maps the entity to the shape that actually crosses the wire — notably,
    // never includes PasswordHash.
    private static EmployeeResponseDto ToResponseDto(Employee employee) => new()
    {
        Id = employee.Id,
        EmployeeCode = employee.EmployeeCode,
        FirstName = employee.FirstName,
        LastName = employee.LastName,
        Email = employee.Email,
        PhoneNumber = employee.PhoneNumber,
        DepartmentId = employee.DepartmentId,
        DepartmentName = employee.Department?.Name ?? string.Empty,
        Role = employee.Role.ToString(),
        ManagerId = employee.ManagerId,
        ManagerName = employee.Manager is null ? null : $"{employee.Manager.FirstName} {employee.Manager.LastName}",
        IsActive = employee.IsActive,
        CreatedAt = employee.CreatedAt
    };
}
