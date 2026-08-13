import { apiClient } from "./client";
import type { Employee, EmployeeCreateRequest, EmployeeUpdateRequest } from "../types/employee";

export async function getEmployees(departmentId?: number): Promise<Employee[]> {
  const { data } = await apiClient.get<Employee[]>("/api/employees", {
    params: departmentId ? { departmentId } : undefined,
  });
  return data;
}

export async function createEmployee(dto: EmployeeCreateRequest): Promise<Employee> {
  const { data } = await apiClient.post<Employee>("/api/employees", dto);
  return data;
}

export async function updateEmployee(id: number, dto: EmployeeUpdateRequest): Promise<Employee> {
  const { data } = await apiClient.put<Employee>(`/api/employees/${id}`, dto);
  return data;
}

export async function deactivateEmployee(id: number): Promise<void> {
  await apiClient.delete(`/api/employees/${id}`);
}
