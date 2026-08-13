// Mirrors backend/DTOs/Leave/*.cs

export type LeaveType = "Sick" | "Vacation" | "Casual" | "Unpaid" | "Other";
export type LeaveStatus = "Pending" | "Approved" | "Rejected";

export interface LeaveRequest {
  id: number;
  employeeId: number;
  employeeName: string;
  leaveType: LeaveType;
  startDate: string;
  endDate: string;
  reason: string | null;
  status: LeaveStatus;
  approvedById: number | null;
  approvedByName: string | null;
  appliedOn: string;
}

export interface LeaveRequestCreateRequest {
  leaveType: LeaveType;
  startDate: string;
  endDate: string;
  reason?: string;
}

export interface LeaveFilters {
  employeeId?: number;
  status?: LeaveStatus;
}
