import { useEffect, useState, type ReactNode } from "react";
import { Link } from "react-router-dom";
import { getAttendance } from "../api/attendance";
import { extractErrorMessage } from "../api/client";
import { getDepartments } from "../api/departments";
import { getEmployees } from "../api/employees";
import { getLeaveRequests } from "../api/leave";
import { useAuth } from "../auth/AuthContext";
import { Spinner } from "../components/Spinner";
import { StatCard } from "../components/StatCard";
import "../styles/data-page.css";
import "./Dashboard.css";

type TodayStatus = "checked-in" | "checked-out" | "not-checked-in";

interface DashboardCard {
  label: string;
  value: number;
  to?: string;
  icon: ReactNode;
}

interface DashboardData {
  todayStatus: TodayStatus;
  cards: DashboardCard[];
}

function todayIso(): string {
  return new Date().toISOString().slice(0, 10);
}

function greeting(): string {
  const hour = new Date().getHours();
  if (hour < 12) return "Good morning";
  if (hour < 18) return "Good afternoon";
  return "Good evening";
}

function longDate(): string {
  return new Date().toLocaleDateString(undefined, {
    weekday: "long",
    day: "numeric",
    month: "long",
    year: "numeric",
  });
}

function icon(children: ReactNode) {
  return (
    <svg viewBox="0 0 24 24" width="18" height="18" fill="none" stroke="currentColor" strokeWidth="1.8" strokeLinecap="round" strokeLinejoin="round">
      {children}
    </svg>
  );
}

const PeopleIcon = icon(
  <>
    <circle cx="12" cy="8" r="3.2" />
    <path d="M5 20c0-3.5 3.1-6 7-6s7 2.5 7 6" />
  </>,
);
const BuildingIcon = icon(
  <>
    <path d="M4 21V8l8-4.5L20 8v13" />
    <path d="M9 21v-6h6v6" />
  </>,
);
const InboxIcon = icon(
  <>
    <rect x="3.5" y="4.5" width="17" height="16" rx="2" />
    <path d="M3.5 9.5h17M8 3v3M16 3v3" />
  </>,
);
const ClockIcon = icon(
  <>
    <circle cx="12" cy="12" r="8.5" />
    <path d="M12 7.5V12l3 2" />
  </>,
);

const STATUS_COPY: Record<TodayStatus, { title: string; hint: string }> = {
  "not-checked-in": { title: "You haven't checked in today", hint: "Record your arrival to start the day." },
  "checked-in": { title: "You're checked in for today", hint: "Remember to check out when you finish." },
  "checked-out": { title: "Today's attendance is complete", hint: "Your check-in and check-out are both recorded." },
};

// Real numbers pulled from the same endpoints the rest of the app already
// uses — Admin sees company-wide counts, Manager sees their own team's,
// Employee sees their own request count. Everyone gets today's status.
export function Dashboard() {
  const { user } = useAuth();
  const [data, setData] = useState<DashboardData | null>(null);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    if (user) loadDashboard();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, []);

  async function loadDashboard() {
    if (!user) return;
    setError(null);
    try {
      const today = todayIso();
      const todayRecords = await getAttendance({ employeeId: user.employeeId, startDate: today, endDate: today });
      const todayRecord = todayRecords[0];
      const todayStatus: TodayStatus = !todayRecord
        ? "not-checked-in"
        : todayRecord.checkOutTime
          ? "checked-out"
          : "checked-in";

      if (user.role === "Admin") {
        const [employees, departments, pending] = await Promise.all([
          getEmployees(),
          getDepartments(),
          getLeaveRequests({ status: "Pending" }),
        ]);
        setData({
          todayStatus,
          cards: [
            {
              label: "Active Employees",
              value: employees.filter((e) => e.isActive).length,
              to: "/employees",
              icon: PeopleIcon,
            },
            { label: "Departments", value: departments.length, to: "/departments", icon: BuildingIcon },
            { label: "Pending Leave Requests", value: pending.length, to: "/leave/approvals", icon: InboxIcon },
          ],
        });
      } else if (user.role === "Manager") {
        const [employees, pending] = await Promise.all([getEmployees(), getLeaveRequests({ status: "Pending" })]);
        const myTeamIds = new Set(employees.filter((e) => e.managerId === user.employeeId).map((e) => e.id));
        setData({
          todayStatus,
          cards: [
            { label: "My Team", value: myTeamIds.size, to: "/employees", icon: PeopleIcon },
            {
              label: "Pending Approvals",
              value: pending.filter((r) => myTeamIds.has(r.employeeId)).length,
              to: "/leave/approvals",
              icon: InboxIcon,
            },
          ],
        });
      } else {
        const myPending = await getLeaveRequests({ employeeId: user.employeeId, status: "Pending" });
        setData({
          todayStatus,
          cards: [{ label: "My Pending Requests", value: myPending.length, to: "/leave", icon: InboxIcon }],
        });
      }
    } catch (err) {
      setError(extractErrorMessage(err, "Failed to load dashboard."));
    }
  }

  const canManagePeople = user?.role === "Admin";
  const canReview = user?.role === "Admin" || user?.role === "Manager";

  return (
    <div className="data-page dashboard-page">
      <div className="page-header">
        <div>
          <h1>
            {greeting()}, {user?.fullName?.split(" ")[0]}
          </h1>
          <p className="page-subtitle">{longDate()}</p>
        </div>
      </div>

      {error && <p className="page-alert">{error}</p>}
      {!data && !error && <Spinner label="Loading dashboard…" />}

      {data && (
        <>
          <div className={"today-banner today-" + data.todayStatus}>
            <span className="today-icon" aria-hidden="true">
              {ClockIcon}
            </span>
            <div className="today-text">
              <p className="today-title">{STATUS_COPY[data.todayStatus].title}</p>
              <p className="today-hint">{STATUS_COPY[data.todayStatus].hint}</p>
            </div>
            {data.todayStatus !== "checked-out" && (
              <Link to="/attendance" className="primary-button">
                {data.todayStatus === "not-checked-in" ? "Check in" : "Go to attendance"}
              </Link>
            )}
          </div>

          <section className="dashboard-section">
            <h2 className="section-title">At a glance</h2>
            <div className="stat-grid">
              {data.cards.map((card) => (
                <StatCard key={card.label} label={card.label} value={card.value} to={card.to} icon={card.icon} />
              ))}
            </div>
          </section>

          <section className="dashboard-section">
            <h2 className="section-title">Quick actions</h2>
            <div className="quick-actions">
              <QuickAction to="/attendance" title="Attendance" hint="Check in, check out, view history" />
              <QuickAction to="/leave" title="Request leave" hint="Submit a new leave request" />
              {canReview && (
                <QuickAction to="/leave/approvals" title="Review approvals" hint="Decide on pending requests" />
              )}
              {canManagePeople && <QuickAction to="/employees" title="Manage people" hint="Add or update employees" />}
            </div>
          </section>
        </>
      )}
    </div>
  );
}

function QuickAction({ to, title, hint }: { to: string; title: string; hint: string }) {
  return (
    <Link to={to} className="quick-action">
      <span className="quick-action-text">
        <span className="quick-action-title">{title}</span>
        <span className="quick-action-hint">{hint}</span>
      </span>
      <svg viewBox="0 0 24 24" width="16" height="16" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round" aria-hidden="true">
        <path d="M9 6l6 6-6 6" />
      </svg>
    </Link>
  );
}
