import { useEffect, useState } from "react";
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

interface DashboardData {
  todayStatus: TodayStatus;
  cards: { label: string; value: number; to?: string }[];
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
            { label: "Active Employees", value: employees.filter((e) => e.isActive).length, to: "/employees" },
            { label: "Departments", value: departments.length, to: "/departments" },
            { label: "Pending Leave Requests", value: pending.length, to: "/leave/approvals" },
          ],
        });
      } else if (user.role === "Manager") {
        const [employees, pending] = await Promise.all([getEmployees(), getLeaveRequests({ status: "Pending" })]);
        const myTeamIds = new Set(employees.filter((e) => e.managerId === user.employeeId).map((e) => e.id));
        setData({
          todayStatus,
          cards: [
            { label: "My Team", value: myTeamIds.size, to: "/employees" },
            {
              label: "Pending Approvals",
              value: pending.filter((r) => myTeamIds.has(r.employeeId)).length,
              to: "/leave/approvals",
            },
          ],
        });
      } else {
        const myPending = await getLeaveRequests({ employeeId: user.employeeId, status: "Pending" });
        setData({
          todayStatus,
          cards: [{ label: "My Pending Requests", value: myPending.length, to: "/leave" }],
        });
      }
    } catch (err) {
      setError(extractErrorMessage(err, "Failed to load dashboard."));
    }
  }

  return (
    <div className="data-page dashboard-page">
      <div className="page-header">
        <h1>
          {greeting()}, {user?.fullName}
        </h1>
      </div>

      {error && <p className="page-alert">{error}</p>}
      {!data && !error && <Spinner label="Loading dashboard…" />}

      {data && (
        <>
          <div className={"today-banner today-" + data.todayStatus}>
            {data.todayStatus === "not-checked-in" && (
              <>
                You haven't checked in today. <Link to="/attendance">Check in →</Link>
              </>
            )}
            {data.todayStatus === "checked-in" && <>You're checked in for today.</>}
            {data.todayStatus === "checked-out" && <>You've completed today's attendance.</>}
          </div>

          <div className="stat-grid">
            {data.cards.map((card) => (
              <StatCard key={card.label} label={card.label} value={card.value} to={card.to} />
            ))}
          </div>
        </>
      )}
    </div>
  );
}
