// Mirrors backend/DTOs/Attendance/*.cs

export type DeviceType = "Web" | "Mobile";
export type AttendanceStatus = "Present" | "Absent" | "Late" | "HalfDay" | "OnLeave";

export interface AttendanceLog {
  id: number;
  employeeId: number;
  employeeName: string;
  checkInTime: string | null;
  checkOutTime: string | null;
  workDate: string;
  status: AttendanceStatus;
  deviceType: DeviceType;
}

export interface AttendanceFilters {
  employeeId?: number;
  departmentId?: number;
  startDate?: string;
  endDate?: string;
}
