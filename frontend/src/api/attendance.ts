import { apiClient } from "./client";
import type { AttendanceFilters, AttendanceLog, DeviceType } from "../types/attendance";

export async function checkIn(deviceType: DeviceType): Promise<AttendanceLog> {
  const { data } = await apiClient.post<AttendanceLog>("/api/attendance/check-in", { deviceType });
  return data;
}

export async function checkOut(): Promise<AttendanceLog> {
  const { data } = await apiClient.post<AttendanceLog>("/api/attendance/check-out");
  return data;
}

export async function getAttendance(filters: AttendanceFilters = {}): Promise<AttendanceLog[]> {
  const { data } = await apiClient.get<AttendanceLog[]>("/api/attendance", { params: filters });
  return data;
}
