using backend.Data;
using backend.DTOs.Employees;
using backend.Helpers;
using backend.Models;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace backend.Controllers;

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

    [HttpPost]
    [Authorize(Roles = "Admin")]
    public async Task<ActionResult<EmployeeResponseDto>> Create(EmployeeCreateDto dto)
    {
        var department = await _db.Departments.FindAsync(dto.DepartmentId);
        if (department is null)
        {
            return BadRequest($"Department {dto.DepartmentId} does not exist.");
        }

        Employee? manager = null;
        if (dto.ManagerId.HasValue)
        {
            manager = await _db.Employees.FindAsync(dto.ManagerId.Value);
            if (manager is null)
            {
                return BadRequest($"Manager {dto.ManagerId} does not exist.");
            }
        }

        if (await _db.Employees.AnyAsync(e => e.Email == dto.Email))
        {
            return Conflict($"Email '{dto.Email}' is already in use.");
        }

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
            ManagerId = dto.ManagerId
        };

        _db.Employees.Add(employee);
        await _db.SaveChangesAsync();

        var response = new EmployeeResponseDto
        {
            Id = employee.Id,
            EmployeeCode = employee.EmployeeCode,
            FirstName = employee.FirstName,
            LastName = employee.LastName,
            Email = employee.Email,
            PhoneNumber = employee.PhoneNumber,
            DepartmentId = employee.DepartmentId,
            DepartmentName = department.Name,
            Role = employee.Role.ToString(),
            ManagerId = employee.ManagerId,
            ManagerName = manager is null ? null : $"{manager.FirstName} {manager.LastName}",
            IsActive = employee.IsActive,
            CreatedAt = employee.CreatedAt
        };

        return Created($"/api/employees/{employee.Id}", response);
    }
}
