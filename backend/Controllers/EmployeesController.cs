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
[ApiController]
[Route("api/employees")]
[Authorize]
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
    [HttpGet]
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
    [HttpGet("{id:int}")]
    public async Task<ActionResult<EmployeeResponseDto>> GetById(int id)
    {
        var employee = await WithRelations.FirstOrDefaultAsync(e => e.Id == id);
        return employee is null ? NotFound() : Ok(ToResponseDto(employee));
    }

    // POST /api/employees — Admin only. Creates a brand-new login: hashes the
    // plaintext password from the DTO before it ever touches the database.
    [HttpPost]
    [Authorize(Roles = "Admin")]
    public async Task<ActionResult<EmployeeResponseDto>> Create(EmployeeCreateDto dto)
    {
        var (department, manager, error) = await ValidateRelationsAsync(dto.DepartmentId, dto.ManagerId);
        if (error is not null) return error;

        if (await EmailInUseAsync(dto.Email)) return Conflict($"Email '{dto.Email}' is already in use.");
        if (await _db.Employees.AnyAsync(e => e.EmployeeCode == dto.EmployeeCode))
        {
            return Conflict($"Employee code '{dto.EmployeeCode}' is already in use.");
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
    [HttpPut("{id:int}")]
    [Authorize(Roles = "Admin")]
    public async Task<ActionResult<EmployeeResponseDto>> Update(int id, EmployeeUpdateDto dto)
    {
        var employee = await WithRelations.FirstOrDefaultAsync(e => e.Id == id);
        if (employee is null) return NotFound();

        var (department, manager, error) = await ValidateRelationsAsync(dto.DepartmentId, dto.ManagerId, selfId: id);
        if (error is not null) return error;

        if (await EmailInUseAsync(dto.Email, excludeId: id)) return Conflict($"Email '{dto.Email}' is already in use.");

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
    [HttpDelete("{id:int}")]
    [Authorize(Roles = "Admin")]
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
            return (null, null, BadRequest("An employee cannot be their own manager."));
        }

        var department = await _db.Departments.FindAsync(departmentId);
        if (department is null)
        {
            return (null, null, BadRequest($"Department {departmentId} does not exist."));
        }

        Employee? manager = null;
        if (managerId.HasValue)
        {
            manager = await _db.Employees.FindAsync(managerId.Value);
            if (manager is null)
            {
                return (null, null, BadRequest($"Manager {managerId} does not exist."));
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
