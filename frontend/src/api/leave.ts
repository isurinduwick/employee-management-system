import { apiClient } from "./client";
import type { LeaveFilters, LeaveRequest, LeaveRequestCreateRequest, LeaveStatus } from "../types/leave";

export async function submitLeaveRequest(dto: LeaveRequestCreateRequest): Promise<LeaveRequest> {
  const { data } = await apiClient.post<LeaveRequest>("/api/leave-requests", dto);
  return data;
}

export async function getLeaveRequests(filters: LeaveFilters = {}): Promise<LeaveRequest[]> {
  const { data } = await apiClient.get<LeaveRequest[]>("/api/leave-requests", { params: filters });
  return data;
}

export async function decideLeaveRequest(id: number, status: LeaveStatus): Promise<LeaveRequest> {
  const { data } = await apiClient.put<LeaveRequest>(`/api/leave-requests/${id}/decision`, { status });
  return data;
}
