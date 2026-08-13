import type { ReactElement, ReactNode } from "react";

// One small line icon per nav item, keyed by route — kept separate from
// navItems.ts so that file can stay plain data (label/path/roles) rather
// than mixing in JSX.

function base(children: ReactNode) {
  return (
    <svg viewBox="0 0 24 24" width="17" height="17" fill="none" stroke="currentColor" strokeWidth="1.8" strokeLinecap="round" strokeLinejoin="round">
      {children}
    </svg>
  );
}

const DashboardIcon = () => base(<><rect x="3" y="3" width="8" height="8" rx="1.5" /><rect x="13" y="3" width="8" height="5" rx="1.5" /><rect x="13" y="12" width="8" height="9" rx="1.5" /><rect x="3" y="15" width="8" height="6" rx="1.5" /></>);
const EmployeesIcon = () => base(<><circle cx="12" cy="8" r="3.2" /><path d="M5 20c0-3.5 3.1-6 7-6s7 2.5 7 6" /></>);
const DepartmentsIcon = () => base(<><path d="M4 21V8l8-4.5L20 8v13" /><path d="M9 21v-6h6v6M9 12h.01M15 12h.01M9 9h.01M15 9h.01" /></>);
const AttendanceIcon = () => base(<><circle cx="12" cy="12" r="8.5" /><path d="M12 7.5V12l3 2" /></>);
const TeamIcon = () => base(<><circle cx="9" cy="8" r="3" /><circle cx="17" cy="9" r="2.4" /><path d="M3.5 20c0-3 2.5-5.2 5.5-5.2s5.5 2.2 5.5 5.2M15.8 14.6c2.4.3 4.2 2.2 4.2 4.7" /></>);
const LeaveIcon = () => base(<><rect x="3.5" y="4.5" width="17" height="16" rx="2" /><path d="M3.5 9.5h17M8 3v3M16 3v3" /></>);
const ApprovalsIcon = () => base(<><rect x="3.5" y="4.5" width="17" height="16" rx="2" /><path d="M3.5 9.5h17M8 3v3M16 3v3M8.5 14.5l2.2 2.2 4.3-4.3" /></>);

const ICONS_BY_PATH: Record<string, () => ReactElement> = {
  "/": DashboardIcon,
  "/employees": EmployeesIcon,
  "/departments": DepartmentsIcon,
  "/attendance": AttendanceIcon,
  "/attendance/team": TeamIcon,
  "/leave": LeaveIcon,
  "/leave/approvals": ApprovalsIcon,
};

export function NavIcon({ path }: { path: string }) {
  const Icon = ICONS_BY_PATH[path];
  return Icon ? <Icon /> : null;
}
