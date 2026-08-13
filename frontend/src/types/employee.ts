// Mirrors backend/DTOs/Employees/*.cs
import type { Role } from "./auth";

export interface Employee {
  id: number;
  employeeCode: string;
  firstName: string;
  lastName: string;
  email: string;
  phoneNumber: string | null;
  departmentId: number;
  departmentName: string;
  role: Role;
  managerId: number | null;
  managerName: string | null;
  isActive: boolean;
  createdAt: string;
}

export interface EmployeeCreateRequest {
  employeeCode: string;
  firstName: string;
  lastName: string;
  email: string;
  password: string;
  phoneNumber?: string;
  departmentId: number;
  role: Role;
  managerId?: number;
}

// No password field — matches the backend, which handles password changes
// through a separate flow rather than a routine profile edit.
export interface EmployeeUpdateRequest {
  firstName: string;
  lastName: string;
  email: string;
  phoneNumber?: string;
  departmentId: number;
  role: Role;
  managerId?: number;
  isActive: boolean;
}
