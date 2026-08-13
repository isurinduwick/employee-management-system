import { useEffect, useState, type FormEvent } from "react";
import { extractErrorMessage } from "../api/client";
import { decideLeaveRequest, getLeaveRequests, submitLeaveRequest } from "../api/leave";
import { getEmployees } from "../api/employees";
import { useAuth } from "../auth/AuthContext";
import { EmptyState } from "../components/EmptyState";
import { Spinner } from "../components/Spinner";
import { useToast } from "../components/Toast";
import type { LeaveRequest, LeaveStatus, LeaveType } from "../types/leave";
import type { Employee } from "../types/employee";
import "../styles/data-page.css";
import "./Leave.css";

const LEAVE_TYPES: LeaveType[] = ["Sick", "Vacation", "Casual", "Unpaid", "Other"];
const STATUS_FILTERS: LeaveStatus[] = ["Pending", "Approved", "Rejected"];

export function Leave() {
  const { user } = useAuth();
  const { showToast } = useToast();
  const canReview = user?.role === "Admin" || user?.role === "Manager";

  const [requests, setRequests] = useState<LeaveRequest[] | null>(null);
  const [loadError, setLoadError] = useState<string | null>(null);
  const [employees, setEmployees] = useState<Employee[]>([]);

  const [statusFilter, setStatusFilter] = useState<LeaveStatus | "">("");
  const [employeeFilter, setEmployeeFilter] = useState("");

  const [showForm, setShowForm] = useState(false);
  const [leaveType, setLeaveType] = useState<LeaveType>("Vacation");
  const [startDate, setStartDate] = useState("");
  const [endDate, setEndDate] = useState("");
  const [reason, setReason] = useState("");
  const [formError, setFormError] = useState<string | null>(null);
  const [formSubmitting, setFormSubmitting] = useState(false);

  const [decidingId, setDecidingId] = useState<number | null>(null);
  const [decisionError, setDecisionError] = useState<string | null>(null);

  useEffect(() => {
    loadRequests();
    if (canReview) {
      getEmployees().then(setEmployees).catch(() => undefined);
    }
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, []);

  async function loadRequests(overrides?: { employeeId?: string; status?: LeaveStatus | "" }) {
    const effective = overrides ?? { employeeId: employeeFilter, status: statusFilter };
    setLoadError(null);
    try {
      const data = await getLeaveRequests({
        employeeId: effective.employeeId ? Number(effective.employeeId) : undefined,
        status: effective.status || undefined,
      });
      setRequests(data);
    } catch (err) {
      setLoadError(extractErrorMessage(err, "Failed to load leave requests."));
    }
  }

  function handleApplyFilters() {
    loadRequests();
  }

  function handleClearFilters() {
    setStatusFilter("");
    setEmployeeFilter("");
    loadRequests({ employeeId: "", status: "" });
  }

  async function handleSubmit(event: FormEvent) {
    event.preventDefault();

    if (!startDate || !endDate) {
      setFormError("Start and end date are required.");
      return;
    }
    if (endDate < startDate) {
      setFormError("End date cannot be before start date.");
      return;
    }

    setFormSubmitting(true);
    setFormError(null);
    try {
      const created = await submitLeaveRequest({
        leaveType,
        startDate,
        endDate,
        reason: reason.trim() || undefined,
      });
      setRequests((prev) => [created, ...(prev ?? [])]);
      setShowForm(false);
      setLeaveType("Vacation");
      setStartDate("");
      setEndDate("");
      setReason("");
      showToast("Leave request submitted.");
    } catch (err) {
      setFormError(extractErrorMessage(err, "Failed to submit leave request."));
    } finally {
      setFormSubmitting(false);
    }
  }

  async function handleDecision(request: LeaveRequest, status: "Approved" | "Rejected") {
    setDecidingId(request.id);
    setDecisionError(null);
    try {
      const updated = await decideLeaveRequest(request.id, status);
      setRequests((prev) => prev?.map((r) => (r.id === request.id ? updated : r)) ?? null);
      showToast(`Leave request ${status.toLowerCase()}.`);
    } catch (err) {
      setDecisionError(extractErrorMessage(err, "Failed to record decision."));
    } finally {
      setDecidingId(null);
    }
  }

  // A Manager can only decide on their own direct reports (the backend enforces
  // this too — this just hides a button that would otherwise 403).
  function canDecide(request: LeaveRequest): boolean {
    if (user?.role === "Admin") return true;
    if (user?.role !== "Manager") return false;
    const employee = employees.find((e) => e.id === request.employeeId);
    return employee?.managerId === user.employeeId;
  }

  return (
    <div className="data-page leave-page">
      <div className="page-header">
        <div>
          <h1>Leave</h1>
          <p className="page-subtitle">
            {canReview ? "Submit your own requests and decide on your team's." : "Submit and track your leave requests."}
          </p>
        </div>
        {!showForm && (
          <button type="button" className="primary-button" onClick={() => setShowForm(true)}>
            New Leave Request
          </button>
        )}
      </div>

      {loadError && <p className="page-alert">{loadError}</p>}
      {decisionError && <p className="page-alert">{decisionError}</p>}

      {showForm && (
        <form className="leave-form" onSubmit={handleSubmit}>
          <div className="leave-form-header">
            <h2 className="panel-title">New leave request</h2>
            <p className="panel-hint">Your manager is notified once you submit.</p>
          </div>

          <div className="form-grid">
            <label>
              Leave type
              <select value={leaveType} onChange={(e) => setLeaveType(e.target.value as LeaveType)}>
                {LEAVE_TYPES.map((type) => (
                  <option key={type} value={type}>
                    {type}
                  </option>
                ))}
              </select>
            </label>

            <label>
              Start date
              <input type="date" value={startDate} onChange={(e) => setStartDate(e.target.value)} required />
            </label>

            <label>
              End date
              <input type="date" value={endDate} onChange={(e) => setEndDate(e.target.value)} required />
            </label>
          </div>

          <label className="reason-field">
            Reason (optional)
            <textarea value={reason} onChange={(e) => setReason(e.target.value)} maxLength={500} rows={2} />
          </label>

          {formError && <p className="field-error">{formError}</p>}

          <div className="form-actions">
            <button type="submit" className="primary-button" disabled={formSubmitting}>
              {formSubmitting ? "Submitting…" : "Submit"}
            </button>
            <button type="button" className="secondary-button" onClick={() => setShowForm(false)}>
              Cancel
            </button>
          </div>
        </form>
      )}

      {canReview && (
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
            Status
            <select value={statusFilter} onChange={(e) => setStatusFilter(e.target.value as LeaveStatus | "")}>
              <option value="">All statuses</option>
              {STATUS_FILTERS.map((status) => (
                <option key={status} value={status}>
                  {status}
                </option>
              ))}
            </select>
          </label>

          <button type="button" className="secondary-button" onClick={handleApplyFilters}>
            Apply
          </button>
          <button type="button" className="link-button" onClick={handleClearFilters}>
            Clear
          </button>
        </div>
      )}

      {requests === null && !loadError && <Spinner />}
      {requests && requests.length === 0 && (
        <EmptyState title="No leave requests found" hint="Submit a request, or clear the filters to see more." />
      )}

      {requests && requests.length > 0 && (
        <div className="table-card">
          <div className="table-scroll">
            <table className="data-table">
              <thead>
                <tr>
                  {canReview && <th>Employee</th>}
                  <th>Type</th>
                  <th>Dates</th>
                  <th>Reason</th>
                  <th>Status</th>
                  <th>Decided by</th>
                  {canReview && <th aria-label="Actions" />}
                </tr>
              </thead>
              <tbody>
                {requests.map((request) => (
                  <tr key={request.id}>
                    {canReview && <td>{request.employeeName}</td>}
                    <td>{request.leaveType}</td>
                    <td>
                      <span className="leave-dates">
                        {request.startDate}
                        <svg viewBox="0 0 24 24" width="13" height="13" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round" aria-hidden="true">
                          <path d="M5 12h13m0 0-4-4m4 4-4 4" />
                        </svg>
                        {request.endDate}
                      </span>
                    </td>
                    <td>
                      <span className="leave-reason" title={request.reason ?? undefined}>
                        {request.reason ?? "—"}
                      </span>
                    </td>
                    <td>
                      <span className={"status-pill " + request.status.toLowerCase()}>{request.status}</span>
                    </td>
                    <td>{request.approvedByName ?? "—"}</td>
                    {canReview && (
                      <td className="actions-cell">
                        {request.status === "Pending" && canDecide(request) && (
                          <>
                            <button
                              type="button"
                              className="link-button"
                              onClick={() => handleDecision(request, "Approved")}
                              disabled={decidingId === request.id}
                            >
                              Approve
                            </button>
                            <button
                              type="button"
                              className="link-button danger"
                              onClick={() => handleDecision(request, "Rejected")}
                              disabled={decidingId === request.id}
                            >
                              Reject
                            </button>
                          </>
                        )}
                      </td>
                    )}
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
