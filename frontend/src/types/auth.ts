// Mirrors the backend's DTOs exactly (backend/DTOs/Auth/*.cs) — this is the
// actual contract the API returns, not an idealized shape.

export type Role = "Admin" | "Manager" | "Employee";

export interface LoginRequest {
  email: string;
  password: string;
}

export interface LoginResponse {
  token: string;
  expiresAt: string;
  employeeId: number;
  fullName: string;
  role: Role;
}
