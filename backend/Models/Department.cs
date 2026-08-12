namespace backend.Models;

public class Department
{
    public int Id { get; set; }

    public string Name { get; set; } = string.Empty;

    // One department has many employees; the FK (Employee.DepartmentId) lives on Employee.
    public ICollection<Employee> Employees { get; set; } = new List<Employee>();
}
