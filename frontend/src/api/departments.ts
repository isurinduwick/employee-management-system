import { apiClient } from "./client";
import type { Department, DepartmentCreateRequest, DepartmentUpdateRequest } from "../types/department";

export async function getDepartments(): Promise<Department[]> {
  const { data } = await apiClient.get<Department[]>("/api/departments");
  return data;
}

export async function createDepartment(dto: DepartmentCreateRequest): Promise<Department> {
  const { data } = await apiClient.post<Department>("/api/departments", dto);
  return data;
}

export async function updateDepartment(id: number, dto: DepartmentUpdateRequest): Promise<Department> {
  const { data } = await apiClient.put<Department>(`/api/departments/${id}`, dto);
  return data;
}

export async function deleteDepartment(id: number): Promise<void> {
  await apiClient.delete(`/api/departments/${id}`);
}
