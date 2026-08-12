using backend.Data;
using backend.DTOs.Departments;
using backend.Models;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace backend.Controllers;

[ApiController]
[Route("api/departments")]
[Authorize]
public class DepartmentsController : ControllerBase
{
    private readonly ApplicationDbContext _db;

    public DepartmentsController(ApplicationDbContext db)
    {
        _db = db;
    }

    // GET /api/departments — any authenticated role. EmployeeCount is computed via
    // a SQL aggregate (Employees.Count) in the projection, not loaded into memory first.
    [HttpGet]
    public async Task<ActionResult<List<DepartmentResponseDto>>> GetAll()
    {
        var departments = await _db.Departments
            .OrderBy(d => d.Name)
            .Select(d => new DepartmentResponseDto
            {
                Id = d.Id,
                Name = d.Name,
                EmployeeCount = d.Employees.Count
            })
            .ToListAsync();

        return Ok(departments);
    }

    // GET /api/departments/5 — any authenticated role. Same projection as GetAll,
    // just narrowed to one row, so EmployeeCount stays a SQL aggregate here too.
    [HttpGet("{id:int}")]
    public async Task<ActionResult<DepartmentResponseDto>> GetById(int id)
    {
        var department = await _db.Departments
            .Where(d => d.Id == id)
            .Select(d => new DepartmentResponseDto
            {
                Id = d.Id,
                Name = d.Name,
                EmployeeCount = d.Employees.Count
            })
            .FirstOrDefaultAsync();

        return department is null ? NotFound() : Ok(department);
    }

    // POST /api/departments — Admin only. Checked here (not left to the DB's unique
    // index alone) so a duplicate name returns a clean 409, not a raw SQL exception.
    [HttpPost]
    [Authorize(Roles = "Admin")]
    public async Task<ActionResult<DepartmentResponseDto>> Create(DepartmentCreateDto dto)
    {
        if (await _db.Departments.AnyAsync(d => d.Name == dto.Name))
        {
            return Conflict($"Department '{dto.Name}' already exists.");
        }

        var department = new Department { Name = dto.Name };
        _db.Departments.Add(department);
        await _db.SaveChangesAsync();

        var response = new DepartmentResponseDto { Id = department.Id, Name = department.Name, EmployeeCount = 0 };
        return Created($"/api/departments/{department.Id}", response);
    }

    // PUT /api/departments/5 — Admin only. Excludes the department's own row from the
    // duplicate-name check, so saving with its existing name doesn't false-positive as a conflict.
    [HttpPut("{id:int}")]
    [Authorize(Roles = "Admin")]
    public async Task<ActionResult<DepartmentResponseDto>> Update(int id, DepartmentUpdateDto dto)
    {
        var department = await _db.Departments.FindAsync(id);
        if (department is null) return NotFound();

        if (await _db.Departments.AnyAsync(d => d.Name == dto.Name && d.Id != id))
        {
            return Conflict($"Department '{dto.Name}' already exists.");
        }

        department.Name = dto.Name;
        await _db.SaveChangesAsync();

        var employeeCount = await _db.Employees.CountAsync(e => e.DepartmentId == id);
        return Ok(new DepartmentResponseDto { Id = department.Id, Name = department.Name, EmployeeCount = employeeCount });
    }

    // DELETE /api/departments/5 — Admin only. Employee.DepartmentId uses
    // DeleteBehavior.Restrict, so the DB would reject this anyway with a raw SQL
    // error; checking here first turns that into a clean, readable 409 instead.
    [HttpDelete("{id:int}")]
    [Authorize(Roles = "Admin")]
    public async Task<IActionResult> Delete(int id)
    {
        var department = await _db.Departments.FindAsync(id);
        if (department is null) return NotFound();

        if (await _db.Employees.AnyAsync(e => e.DepartmentId == id))
        {
            return Conflict("Cannot delete a department that still has employees assigned to it.");
        }

        _db.Departments.Remove(department);
        await _db.SaveChangesAsync();
        return NoContent();
    }
}
