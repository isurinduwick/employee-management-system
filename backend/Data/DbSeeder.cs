using backend.Helpers;
using backend.Models;
using Microsoft.EntityFrameworkCore;

namespace backend.Data;

/// <summary>
/// Inserts one Admin, one Manager, and one Employee (reporting to the Manager) the first
/// time the app runs against an empty database, so there's always a real login for each
/// role to test auth/RBAC against.
/// </summary>
public static class DbSeeder
{
    // Shared login for all three seeded accounts — documented in the README.
    private const string DefaultPassword = "Passw0rd!";

    public static async Task SeedAsync(ApplicationDbContext db)
    {
        if (await db.Employees.AnyAsync())
        {
            return; // already seeded (or real data exists) — never overwrite
        }

        var administration = new Department { Name = "Administration" };
        var engineering = new Department { Name = "Engineering" };
        db.Departments.AddRange(administration, engineering);
        await db.SaveChangesAsync(); // need Department Ids before assigning them below

        var admin = new Employee
        {
            EmployeeCode = "EMP-0001",
            FirstName = "System",
            LastName = "Admin",
            Email = "admin@ems.local",
            PasswordHash = PasswordHasher.HashPassword(DefaultPassword),
            Department = administration,
            Role = Role.Admin
        };

        var manager = new Employee
        {
            EmployeeCode = "EMP-0002",
            FirstName = "Alex",
            LastName = "Manager",
            Email = "manager@ems.local",
            PasswordHash = PasswordHasher.HashPassword(DefaultPassword),
            Department = engineering,
            Role = Role.Manager
        };

        db.Employees.AddRange(admin, manager);
        await db.SaveChangesAsync(); // need manager.Id before setting it as the employee's ManagerId

        var employee = new Employee
        {
            EmployeeCode = "EMP-0003",
            FirstName = "Sam",
            LastName = "Employee",
            Email = "employee@ems.local",
            PasswordHash = PasswordHasher.HashPassword(DefaultPassword),
            Department = engineering,
            Role = Role.Employee,
            Manager = manager
        };

        db.Employees.Add(employee);
        await db.SaveChangesAsync();
    }
}
