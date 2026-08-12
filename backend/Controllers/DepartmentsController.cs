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
}
