using backend.Models;
using Microsoft.EntityFrameworkCore;

namespace backend.Data;

public class ApplicationDbContext : DbContext
{
    public ApplicationDbContext(DbContextOptions<ApplicationDbContext> options) : base(options)
    {
    }

    public DbSet<Department> Departments => Set<Department>();
    public DbSet<Employee> Employees => Set<Employee>();
    public DbSet<AttendanceLog> AttendanceLogs => Set<AttendanceLog>();
    public DbSet<LeaveRequest> LeaveRequests => Set<LeaveRequest>();

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        base.OnModelCreating(modelBuilder);

        // ---- Department ----
        modelBuilder.Entity<Department>(entity =>
        {
            entity.Property(d => d.Name).IsRequired().HasMaxLength(100);
            entity.HasIndex(d => d.Name).IsUnique();
        });

        // ---- Employee ----
        modelBuilder.Entity<Employee>(entity =>
        {
            entity.Property(e => e.EmployeeCode).IsRequired().HasMaxLength(20);
            entity.Property(e => e.FirstName).IsRequired().HasMaxLength(100);
            entity.Property(e => e.LastName).IsRequired().HasMaxLength(100);
            entity.Property(e => e.Email).IsRequired().HasMaxLength(255);
            entity.Property(e => e.PasswordHash).IsRequired();
            entity.Property(e => e.PhoneNumber).HasMaxLength(20);

            entity.HasIndex(e => e.EmployeeCode).IsUnique();
            entity.HasIndex(e => e.Email).IsUnique();

            // Many employees belong to one department. Restrict delete so a department
            // with existing staff can't be removed and silently orphan/cascade them.
            entity.HasOne(e => e.Department)
                .WithMany(d => d.Employees)
                .HasForeignKey(e => e.DepartmentId)
                .OnDelete(DeleteBehavior.Restrict);

            // Self-referencing manager hierarchy: Employee.ManagerId -> Employee.Id.
            // Restrict (not Cascade) because deleting a manager must not cascade-delete
            // their subordinates.
            entity.HasOne(e => e.Manager)
                .WithMany(e => e.Subordinates)
                .HasForeignKey(e => e.ManagerId)
                .OnDelete(DeleteBehavior.Restrict);
        });

        // ---- AttendanceLog ----
        modelBuilder.Entity<AttendanceLog>(entity =>
        {
            entity.Property(a => a.WorkDate).IsRequired();

            // One attendance row per employee per day.
            entity.HasIndex(a => new { a.EmployeeId, a.WorkDate }).IsUnique();

            // Supports the "filter attendance by date range / department / employee" requirement.
            entity.HasIndex(a => a.WorkDate);

            entity.HasOne(a => a.Employee)
                .WithMany(e => e.AttendanceLogs)
                .HasForeignKey(a => a.EmployeeId)
                .OnDelete(DeleteBehavior.Cascade);
        });

        // ---- LeaveRequest ----
        modelBuilder.Entity<LeaveRequest>(entity =>
        {
            entity.Property(l => l.Reason).HasMaxLength(500);
            entity.HasIndex(l => l.Status);

            // Requester side: deleting an employee removes their own leave history.
            entity.HasOne(l => l.Employee)
                .WithMany(e => e.LeaveRequests)
                .HasForeignKey(l => l.EmployeeId)
                .OnDelete(DeleteBehavior.Cascade);

            // Approver side: a second, independent FK back to Employee. Restrict so deleting
            // a manager doesn't delete leave requests they previously approved.
            entity.HasOne(l => l.ApprovedBy)
                .WithMany(e => e.ApprovedLeaveRequests)
                .HasForeignKey(l => l.ApprovedById)
                .OnDelete(DeleteBehavior.Restrict);
        });
    }
}
