// Mirrors backend/DTOs/Departments/*.cs

export interface Department {
  id: number;
  name: string;
  employeeCount: number;
}

export interface DepartmentCreateRequest {
  name: string;
}

export interface DepartmentUpdateRequest {
  name: string;
}
