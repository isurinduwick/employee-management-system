using backend.Controllers;
using backend.Data;
using backend.DTOs.Employees;
using backend.Helpers;
using backend.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Xunit;

namespace backend.Tests;

public class EmployeesControllerTests
{
    // Each test gets its own isolated in-memory database (unique name per test),
    // so tests can run in parallel without seeing each other's data.
    private static ApplicationDbContext NewContext()
    {
        var options = new DbContextOptionsBuilder<ApplicationDbContext>()
            .UseInMemoryDatabase(Guid.NewGuid().ToString())
            .Options;
        return new ApplicationDbContext(options);
    }

    private static async Task<Department> SeedDepartmentAsync(ApplicationDbContext db, string name = "Engineering")
    {
        var department = new Department { Name = name };
        db.Departments.Add(department);
        await db.SaveChangesAsync();
        return department;
    }

    private static async Task<Employee> SeedEmployeeAsync(
        ApplicationDbContext db, Department department, string code = "EMP-0001",
        string email = "seed@ems.local", Role role = Role.Manager, Employee? manager = null)
    {
        var employee = new Employee
        {
            EmployeeCode = code,
            FirstName = "Seed",
            LastName = "User",
            Email = email,
            PasswordHash = PasswordHasher.HashPassword("Passw0rd!"),
            Department = department,
            DepartmentId = department.Id,
            Role = role,
            Manager = manager,
            ManagerId = manager?.Id
        };
        db.Employees.Add(employee);
        await db.SaveChangesAsync();
        return employee;
    }

    private static EmployeeCreateDto ValidCreateDto(Department department, Employee? manager = null) => new()
    {
        EmployeeCode = "EMP-0099",
        FirstName = "Nadia",
        LastName = "Silva",
        Email = "nadia@ems.local",
        Password = "Passw0rd!",
        DepartmentId = department.Id,
        Role = Role.Employee,
        ManagerId = manager?.Id
    };

    // ---------- Create ----------

    [Fact]
    public async Task Create_ValidDto_ReturnsCreatedWithHashedPassword()
    {
        await using var db = NewContext();
        var department = await SeedDepartmentAsync(db);
        var manager = await SeedEmployeeAsync(db, department, code: "EMP-0001", email: "manager@ems.local");
        var controller = new EmployeesController(db);

        var result = await controller.Create(ValidCreateDto(department, manager));

        var created = Assert.IsType<CreatedResult>(result.Result);
        var dto = Assert.IsType<EmployeeResponseDto>(created.Value);
        Assert.Equal("Nadia", dto.FirstName);
        Assert.Equal("Engineering", dto.DepartmentName);
        Assert.Equal("Seed User", dto.ManagerName);

        var stored = await db.Employees.SingleAsync(e => e.Email == "nadia@ems.local");
        Assert.NotEqual("Passw0rd!", stored.PasswordHash); // never stored in plaintext
        Assert.True(PasswordHasher.Verify("Passw0rd!", stored.PasswordHash));
    }

    [Fact]
    public async Task Create_UnknownDepartment_ReturnsBadRequest()
    {
        await using var db = NewContext();
        var department = await SeedDepartmentAsync(db);
        var controller = new EmployeesController(db);

        var dto = ValidCreateDto(department);
        dto.DepartmentId = 999;

        var result = await controller.Create(dto);

        Assert.IsType<BadRequestObjectResult>(result.Result);
    }

    [Fact]
    public async Task Create_UnknownManager_ReturnsBadRequest()
    {
        await using var db = NewContext();
        var department = await SeedDepartmentAsync(db);
        var controller = new EmployeesController(db);

        var dto = ValidCreateDto(department);
        dto.ManagerId = 999;

        var result = await controller.Create(dto);

        Assert.IsType<BadRequestObjectResult>(result.Result);
    }

    [Fact]
    public async Task Create_DuplicateEmail_ReturnsConflict()
    {
        await using var db = NewContext();
        var department = await SeedDepartmentAsync(db);
        await SeedEmployeeAsync(db, department, code: "EMP-0001", email: "nadia@ems.local");
        var controller = new EmployeesController(db);

        var result = await controller.Create(ValidCreateDto(department));

        Assert.IsType<ConflictObjectResult>(result.Result);
    }

    [Fact]
    public async Task Create_DuplicateEmployeeCode_ReturnsConflict()
    {
        await using var db = NewContext();
        var department = await SeedDepartmentAsync(db);
        await SeedEmployeeAsync(db, department, code: "EMP-0099", email: "someone-else@ems.local");
        var controller = new EmployeesController(db);

        var result = await controller.Create(ValidCreateDto(department));

        Assert.IsType<ConflictObjectResult>(result.Result);
    }

    // ---------- GetAll / GetById ----------

    [Fact]
    public async Task GetAll_ReturnsAllEmployees()
    {
        await using var db = NewContext();
        var engineering = await SeedDepartmentAsync(db, "Engineering");
        var admin = await SeedDepartmentAsync(db, "Administration");
        await SeedEmployeeAsync(db, engineering, code: "EMP-0001", email: "a@ems.local");
        await SeedEmployeeAsync(db, admin, code: "EMP-0002", email: "b@ems.local");
        var controller = new EmployeesController(db);

        var result = await controller.GetAll(departmentId: null);

        var ok = Assert.IsType<OkObjectResult>(result.Result);
        var list = Assert.IsAssignableFrom<IEnumerable<EmployeeResponseDto>>(ok.Value);
        Assert.Equal(2, list.Count());
    }

    [Fact]
    public async Task GetAll_FiltersByDepartmentId()
    {
        await using var db = NewContext();
        var engineering = await SeedDepartmentAsync(db, "Engineering");
        var admin = await SeedDepartmentAsync(db, "Administration");
        await SeedEmployeeAsync(db, engineering, code: "EMP-0001", email: "a@ems.local");
        await SeedEmployeeAsync(db, admin, code: "EMP-0002", email: "b@ems.local");
        var controller = new EmployeesController(db);

        var result = await controller.GetAll(departmentId: engineering.Id);

        var ok = Assert.IsType<OkObjectResult>(result.Result);
        var list = Assert.IsAssignableFrom<IEnumerable<EmployeeResponseDto>>(ok.Value);
        Assert.Equal("a@ems.local", Assert.Single(list).Email);
    }

    [Fact]
    public async Task GetById_ExistingId_ReturnsEmployee()
    {
        await using var db = NewContext();
        var department = await SeedDepartmentAsync(db);
        var employee = await SeedEmployeeAsync(db, department);
        var controller = new EmployeesController(db);

        var result = await controller.GetById(employee.Id);

        var ok = Assert.IsType<OkObjectResult>(result.Result);
        var dto = Assert.IsType<EmployeeResponseDto>(ok.Value);
        Assert.Equal(employee.Email, dto.Email);
    }

    [Fact]
    public async Task GetById_MissingId_ReturnsNotFound()
    {
        await using var db = NewContext();
        var controller = new EmployeesController(db);

        var result = await controller.GetById(999);

        Assert.IsType<NotFoundResult>(result.Result);
    }

    // ---------- Update ----------

    [Fact]
    public async Task Update_ValidDto_UpdatesFields()
    {
        await using var db = NewContext();
        var department = await SeedDepartmentAsync(db);
        var employee = await SeedEmployeeAsync(db, department, code: "EMP-0001", email: "seed@ems.local");
        var controller = new EmployeesController(db);

        var dto = new EmployeeUpdateDto
        {
            FirstName = "Updated",
            LastName = "Name",
            Email = employee.Email,
            DepartmentId = department.Id,
            Role = Role.Manager,
            IsActive = true
        };

        var result = await controller.Update(employee.Id, dto);

        var ok = Assert.IsType<OkObjectResult>(result.Result);
        var responseDto = Assert.IsType<EmployeeResponseDto>(ok.Value);
        Assert.Equal("Updated", responseDto.FirstName);
    }

    [Fact]
    public async Task Update_SelfAsManager_ReturnsBadRequest()
    {
        await using var db = NewContext();
        var department = await SeedDepartmentAsync(db);
        var employee = await SeedEmployeeAsync(db, department);
        var controller = new EmployeesController(db);

        var dto = new EmployeeUpdateDto
        {
            FirstName = employee.FirstName,
            LastName = employee.LastName,
            Email = employee.Email,
            DepartmentId = department.Id,
            Role = employee.Role,
            ManagerId = employee.Id, // pointing at themself
            IsActive = true
        };

        var result = await controller.Update(employee.Id, dto);

        Assert.IsType<BadRequestObjectResult>(result.Result);
    }

    [Fact]
    public async Task Update_MissingId_ReturnsNotFound()
    {
        await using var db = NewContext();
        var department = await SeedDepartmentAsync(db);
        var controller = new EmployeesController(db);

        var dto = new EmployeeUpdateDto
        {
            FirstName = "Ghost",
            LastName = "Employee",
            Email = "ghost@ems.local",
            DepartmentId = department.Id,
            Role = Role.Employee
        };

        var result = await controller.Update(999, dto);

        Assert.IsType<NotFoundResult>(result.Result);
    }

    // ---------- Deactivate ----------

    [Fact]
    public async Task Deactivate_ExistingId_SetsIsActiveFalseAndReturnsNoContent()
    {
        await using var db = NewContext();
        var department = await SeedDepartmentAsync(db);
        var employee = await SeedEmployeeAsync(db, department);
        var controller = new EmployeesController(db);

        var result = await controller.Deactivate(employee.Id);

        Assert.IsType<NoContentResult>(result);
        var stored = await db.Employees.FindAsync(employee.Id);
        Assert.False(stored!.IsActive);
    }

    [Fact]
    public async Task Deactivate_MissingId_ReturnsNotFound()
    {
        await using var db = NewContext();
        var controller = new EmployeesController(db);

        var result = await controller.Deactivate(999);

        Assert.IsType<NotFoundResult>(result);
    }
}
