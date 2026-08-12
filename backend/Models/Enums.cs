namespace backend.Models;

/// <summary>
/// Explicit JWT claim role used for RBAC (Admin, Manager, Employee).
/// </summary>
public enum Role
{
    Admin,
    Manager,
    Employee
}

/// <summary>
/// Category selected when an employee submits a leave request.
/// </summary>
public enum LeaveType
{
    Sick,
    Vacation,
    Casual,
    Unpaid,
    Other
}

/// <summary>
/// Lifecycle state of a leave request, driven by the Manager/Admin approval workflow.
/// </summary>
public enum LeaveStatus
{
    Pending,
    Approved,
    Rejected
}

/// <summary>
/// State of a single day's attendance record.
/// </summary>
public enum AttendanceStatus
{
    Present,
    Absent,
    Late,
    HalfDay,
    OnLeave
}

/// <summary>
/// Origin of a check-in/check-out, since both the React web app and the mobile app write here.
/// </summary>
public enum DeviceType
{
    Web,
    Mobile
}
