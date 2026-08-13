import type { Role } from "../types/auth";

export interface NavItem {
  label: string;
  path: string;
  roles: Role[]; // which roles see this link
}

// Single source of truth for the sidebar — add a role to an item's list to
// expose that route to it, instead of duplicating link markup per role.
export const NAV_ITEMS: NavItem[] = [
  { label: "Dashboard", path: "/", roles: ["Admin", "Manager", "Employee"] },
  { label: "Employees", path: "/employees", roles: ["Admin"] },
  { label: "Departments", path: "/departments", roles: ["Admin"] },
  { label: "Attendance", path: "/attendance", roles: ["Admin", "Manager", "Employee"] },
  { label: "Team Attendance", path: "/attendance/team", roles: ["Admin", "Manager"] },
  { label: "Leave", path: "/leave", roles: ["Admin", "Manager", "Employee"] },
  { label: "Leave Approvals", path: "/leave/approvals", roles: ["Admin", "Manager"] },
];
