import type { Role } from "../types/auth";

export interface NavItem {
  label: string;
  path: string;
  group: NavGroup; // sidebar section the link sits under
  roles: Role[]; // which roles see this link
}

export type NavGroup = "Overview" | "People" | "Time & Leave";

// Section order in the sidebar. Sections whose links are all hidden for the
// current role are dropped rather than rendered empty.
export const NAV_GROUPS: NavGroup[] = ["Overview", "People", "Time & Leave"];

// Single source of truth for the sidebar — add a role to an item's list to
// expose that route to it, instead of duplicating link markup per role.
export const NAV_ITEMS: NavItem[] = [
  { label: "Dashboard", path: "/", group: "Overview", roles: ["Admin", "Manager", "Employee"] },
  { label: "Employees", path: "/employees", group: "People", roles: ["Admin"] },
  { label: "Departments", path: "/departments", group: "People", roles: ["Admin"] },
  { label: "Attendance", path: "/attendance", group: "Time & Leave", roles: ["Admin", "Manager", "Employee"] },
  { label: "Leave", path: "/leave", group: "Time & Leave", roles: ["Admin", "Manager", "Employee"] },
];
