import { useEffect, useState } from "react";
import { checkIn, checkOut, getAttendance } from "../api/attendance";
import { extractErrorMessage } from "../api/client";
import { getDepartments } from "../api/departments";
import { getEmployees } from "../api/employees";
import { useAuth } from "../auth/AuthContext";
import { EmptyState } from "../components/EmptyState";
import { Spinner } from "../components/Spinner";
import { useToast } from "../components/Toast";
import type { AttendanceLog } from "../types/attendance";
import type { Department } from "../types/department";
import type { Employee } from "../types/employee";
import "../styles/data-page.css";
import "./Attendance.css";

function todayIso(): string {
  return new Date().toISOString().slice(0, 10); // YYYY-MM-DD, matches the backend's DateOnly
}

function formatTime(value: string | null): string {
  if (!value) return "—";
  return new Date(value).toLocaleTimeString([], { hour: "2-digit", minute: "2-digit" });
}

export function Attendance() {
  const { user } = useAuth();
  const { showToast } = useToast();
  const canFilterTeam = user?.role === "Admin" || user?.role === "Manager";

  const [todayRecord, setTodayRecord] = useState<AttendanceLog | null>(null);
  const [statusError, setStatusError] = useState<string | null>(null);
  const [statusLoading, setStatusLoading] = useState(true);
  const [actionSubmitting, setActionSubmitting] = useState(false);
  const [actionError, setActionError] = useState<string | null>(null);

  const [history, setHistory] = useState<AttendanceLog[] | null>(null);
  const [historyError, setHistoryError] = useState<string | null>(null);

  const [employees, setEmployees] = useState<Employee[]>([]);
  const [departments, setDepartments] = useState<Department[]>([]);
  const [employeeFilter, setEmployeeFilter] = useState("");
  const [departmentFilter, setDepartmentFilter] = useState("");
  const [startDate, setStartDate] = useState("");
  const [endDate, setEndDate] = useState("");

  useEffect(() => {
    loadTodayStatus();
    loadHistory();
    if (canFilterTeam) {
      getEmployees().then(setEmployees).catch(() => undefined);
      getDepartments().then(setDepartments).catch(() => undefined);
    }
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, []);

  async function loadTodayStatus() {
    if (!user) return;
    setStatusLoading(true);
    setStatusError(null);
    try {
      const today = todayIso();
      const records = await getAttendance({ employeeId: user.employeeId, startDate: today, endDate: today });
      setTodayRecord(records[0] ?? null);
    } catch (err) {
      setStatusError(extractErrorMessage(err, "Failed to load today's status."));
    } finally {
      setStatusLoading(false);
    }
  }

  async function loadHistory(overrides?: { employeeId?: string; departmentId?: string; startDate?: string; endDate?: string }) {
    const effective = overrides ?? { employeeId: employeeFilter, departmentId: departmentFilter, startDate, endDate };
    setHistoryError(null);
    try {
      const data = await getAttendance({
        employeeId: effective.employeeId ? Number(effective.employeeId) : undefined,
        departmentId: effective.departmentId ? Number(effective.departmentId) : undefined,
        startDate: effective.startDate || undefined,
        endDate: effective.endDate || undefined,
      });
      setHistory(data);
    } catch (err) {
      setHistoryError(extractErrorMessage(err, "Failed to load attendance history."));
    }
  }

  async function handleCheckIn() {
    setActionSubmitting(true);
    setActionError(null);
    try {
      const record = await checkIn("Web");
      setTodayRecord(record);
      showToast("Checked in.");
    } catch (err) {
      setActionError(extractErrorMessage(err, "Failed to check in."));
    } finally {
      setActionSubmitting(false);
    }
  }

  async function handleCheckOut() {
    setActionSubmitting(true);
    setActionError(null);
    try {
      const record = await checkOut();
      setTodayRecord(record);
      showToast("Checked out.");
    } catch (err) {
      setActionError(extractErrorMessage(err, "Failed to check out."));
    } finally {
      setActionSubmitting(false);
    }
  }

  function handleApplyFilters() {
    loadHistory();
  }

  function handleClearFilters() {
    setEmployeeFilter("");
    setDepartmentFilter("");
    setStartDate("");
    setEndDate("");
    loadHistory({ employeeId: "", departmentId: "", startDate: "", endDate: "" });
  }

  const canCheckIn = !statusLoading && !todayRecord;
  const canCheckOut = !statusLoading && Boolean(todayRecord) && !todayRecord?.checkOutTime;

  return (
    <div className="data-page attendance-page">
      <div className="page-header">
        <div>
          <h1>Attendance</h1>
          <p className="page-subtitle">Record today's hours and review past attendance.</p>
        </div>
      </div>

      <div className="attendance-status-card">
        <span className="attendance-status-icon" aria-hidden="true">
          <svg viewBox="0 0 24 24" width="19" height="19" fill="none" stroke="currentColor" strokeWidth="1.8" strokeLinecap="round" strokeLinejoin="round">
            <circle cx="12" cy="12" r="8.5" />
            <path d="M12 7.5V12l3 2" />
          </svg>
        </span>

        <div className="attendance-status-text">
          {statusLoading ? (
            <Spinner label="Loading today's status…" />
          ) : todayRecord ? (
            <>
              <p>
                Checked in at <strong>{formatTime(todayRecord.checkInTime)}</strong>
                {todayRecord.checkOutTime && (
                  <>
                    {" "}
                    — checked out at <strong>{formatTime(todayRecord.checkOutTime)}</strong>
                  </>
                )}
              </p>
              <p className="attendance-status-hint">
                {todayRecord.checkOutTime ? "Today's attendance is complete." : "Don't forget to check out."}
              </p>
            </>
          ) : (
            <>
              <p>You haven't checked in today.</p>
              <p className="attendance-status-hint">Check in to start recording today's hours.</p>
            </>
          )}
        </div>

        <div className="attendance-actions">
          <button type="button" className="primary-button" onClick={handleCheckIn} disabled={!canCheckIn || actionSubmitting}>
            {actionSubmitting ? "Working…" : "Check In"}
          </button>
          <button type="button" className="secondary-button" onClick={handleCheckOut} disabled={!canCheckOut || actionSubmitting}>
            {actionSubmitting ? "Working…" : "Check Out"}
          </button>
        </div>

        {statusError && <p className="page-alert">{statusError}</p>}
        {actionError && <p className="page-alert">{actionError}</p>}
      </div>

      {canFilterTeam && (
        <div className="filter-row">
          <label>
            Employee
            <select value={employeeFilter} onChange={(e) => setEmployeeFilter(e.target.value)}>
              <option value="">All employees</option>
              {employees.map((emp) => (
                <option key={emp.id} value={emp.id}>
                  {emp.firstName} {emp.lastName}
                </option>
              ))}
            </select>
          </label>

          <label>
            Department
            <select value={departmentFilter} onChange={(e) => setDepartmentFilter(e.target.value)}>
              <option value="">All departments</option>
              {departments.map((dep) => (
                <option key={dep.id} value={dep.id}>
                  {dep.name}
                </option>
              ))}
            </select>
          </label>

          <label>
            From
            <input type="date" value={startDate} onChange={(e) => setStartDate(e.target.value)} />
          </label>

          <label>
            To
            <input type="date" value={endDate} onChange={(e) => setEndDate(e.target.value)} />
          </label>

          <button type="button" className="secondary-button" onClick={handleApplyFilters}>
            Apply
          </button>
          <button type="button" className="link-button" onClick={handleClearFilters}>
            Clear
          </button>
        </div>
      )}

      {historyError && <p className="page-alert">{historyError}</p>}

      {history === null && !historyError && <Spinner label="Loading history…" />}
      {history && history.length === 0 && (
        <EmptyState title="No attendance records found" hint="Try widening the date range or clearing the filters." />
      )}

      {history && history.length > 0 && (
        <div className="table-card">
          <div className="table-scroll">
            <table className="data-table">
              <thead>
                <tr>
                  {canFilterTeam && <th>Employee</th>}
                  <th>Date</th>
                  <th>Check In</th>
                  <th>Check Out</th>
                  <th>Status</th>
                  <th>Device</th>
                </tr>
              </thead>
              <tbody>
                {history.map((record) => (
                  <tr key={record.id}>
                    {canFilterTeam && <td>{record.employeeName}</td>}
                    <td>{record.workDate}</td>
                    <td>{formatTime(record.checkInTime)}</td>
                    <td>{formatTime(record.checkOutTime)}</td>
                    <td>
                      <span className={"status-pill " + record.status.toLowerCase()}>{record.status}</span>
                    </td>
                    <td>{record.deviceType}</td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        </div>
      )}
    </div>
  );
}
