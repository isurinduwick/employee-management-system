import { useEffect, useState, type FormEvent } from "react";
import { extractErrorMessage } from "../api/client";
import { getDepartments } from "../api/departments";
import { createEmployee, deactivateEmployee, getEmployees, updateEmployee } from "../api/employees";
import { useAuth } from "../auth/AuthContext";
import { Spinner } from "../components/Spinner";
import { useToast } from "../components/Toast";
import type { Role } from "../types/auth";
import type { Department } from "../types/department";
import type { Employee, EmployeeCreateRequest, EmployeeUpdateRequest } from "../types/employee";
import "../styles/data-page.css";
import "./Employees.css";

const ROLES: Role[] = ["Admin", "Manager", "Employee"];

interface FormState {
  employeeCode: string;
  firstName: string;
  lastName: string;
  email: string;
  password: string;
  phoneNumber: string;
  departmentId: string;
  role: Role;
  managerId: string;
  isActive: boolean;
}

const EMPTY_FORM: FormState = {
  employeeCode: "",
  firstName: "",
  lastName: "",
  email: "",
  password: "",
  phoneNumber: "",
  departmentId: "",
  role: "Employee",
  managerId: "",
  isActive: true,
};

export function Employees() {
  const { user } = useAuth();
  const { showToast } = useToast();
  const canManage = user?.role === "Admin"; // reads are open to everyone; writes are Admin-only, same as the API

  const [employees, setEmployees] = useState<Employee[] | null>(null);
  const [departments, setDepartments] = useState<Department[]>([]);
  const [loadError, setLoadError] = useState<string | null>(null);

  const [showForm, setShowForm] = useState(false);
  const [editingId, setEditingId] = useState<number | null>(null);
  const [form, setForm] = useState<FormState>(EMPTY_FORM);
  const [formError, setFormError] = useState<string | null>(null);
  const [formSubmitting, setFormSubmitting] = useState(false);

  const [deactivatingId, setDeactivatingId] = useState<number | null>(null);
  const [deactivateError, setDeactivateError] = useState<string | null>(null);

  useEffect(() => {
    loadAll();
  }, []);

  async function loadAll() {
    setLoadError(null);
    try {
      const [employeeData, departmentData] = await Promise.all([getEmployees(), getDepartments()]);
      setEmployees(employeeData);
      setDepartments(departmentData);
    } catch (err) {
      setLoadError(extractErrorMessage(err, "Failed to load employees."));
    }
  }

  function openCreateForm() {
    setEditingId(null);
    setForm(EMPTY_FORM);
    setFormError(null);
    setShowForm(true);
  }

  function openEditForm(employee: Employee) {
    setEditingId(employee.id);
    setForm({
      employeeCode: employee.employeeCode,
      firstName: employee.firstName,
      lastName: employee.lastName,
      email: employee.email,
      password: "",
      phoneNumber: employee.phoneNumber ?? "",
      departmentId: String(employee.departmentId),
      role: employee.role,
      managerId: employee.managerId ? String(employee.managerId) : "",
      isActive: employee.isActive,
    });
    setFormError(null);
    setShowForm(true);
  }

  function closeForm() {
    setShowForm(false);
    setEditingId(null);
    setFormError(null);
  }

  async function handleSubmit(event: FormEvent) {
    event.preventDefault();

    if (!form.departmentId) {
      setFormError("Department is required.");
      return;
    }

    setFormSubmitting(true);
    setFormError(null);

    try {
      if (editingId === null) {
        const dto: EmployeeCreateRequest = {
          employeeCode: form.employeeCode.trim(),
          firstName: form.firstName.trim(),
          lastName: form.lastName.trim(),
          email: form.email.trim(),
          password: form.password,
          phoneNumber: form.phoneNumber.trim() || undefined,
          departmentId: Number(form.departmentId),
          role: form.role,
          managerId: form.managerId ? Number(form.managerId) : undefined,
        };
        const created = await createEmployee(dto);
        setEmployees((prev) => [...(prev ?? []), created]);
        showToast(`Employee "${created.firstName} ${created.lastName}" created.`);
      } else {
        const dto: EmployeeUpdateRequest = {
          firstName: form.firstName.trim(),
          lastName: form.lastName.trim(),
          email: form.email.trim(),
          phoneNumber: form.phoneNumber.trim() || undefined,
          departmentId: Number(form.departmentId),
          role: form.role,
          managerId: form.managerId ? Number(form.managerId) : undefined,
          isActive: form.isActive,
        };
        const updated = await updateEmployee(editingId, dto);
        setEmployees((prev) => prev?.map((e) => (e.id === editingId ? updated : e)) ?? null);
        showToast(`Employee "${updated.firstName} ${updated.lastName}" updated.`);
      }
      closeForm();
    } catch (err) {
      setFormError(extractErrorMessage(err, "Failed to save employee."));
    } finally {
      setFormSubmitting(false);
    }
  }

  async function handleDeactivate(employee: Employee) {
    if (!window.confirm(`Deactivate ${employee.firstName} ${employee.lastName}?`)) {
      return;
    }

    setDeactivatingId(employee.id);
    setDeactivateError(null);
    try {
      await deactivateEmployee(employee.id);
      setEmployees((prev) => prev?.map((e) => (e.id === employee.id ? { ...e, isActive: false } : e)) ?? null);
      showToast(`${employee.firstName} ${employee.lastName} deactivated.`);
    } catch (err) {
      setDeactivateError(extractErrorMessage(err, "Failed to deactivate employee."));
    } finally {
      setDeactivatingId(null);
    }
  }

  const managerOptions = employees?.filter((e) => e.id !== editingId) ?? [];

  return (
    <div className="data-page employees-page">
      <div className="page-header">
        <h1>Employees</h1>
        {canManage && !showForm && (
          <button type="button" className="primary-button" onClick={openCreateForm}>
            New Employee
          </button>
        )}
      </div>

      {loadError && <p className="page-alert">{loadError}</p>}
      {deactivateError && <p className="page-alert">{deactivateError}</p>}

      {canManage && showForm && (
        <form className="employee-form" onSubmit={handleSubmit}>
          <h2>{editingId === null ? "New Employee" : "Edit Employee"}</h2>

          <div className="form-grid">
            <label>
              Employee code
              <input
                value={form.employeeCode}
                onChange={(e) => setForm((f) => ({ ...f, employeeCode: e.target.value }))}
                disabled={editingId !== null}
                maxLength={20}
                required
              />
            </label>

            <label>
              Email
              <input
                type="email"
                value={form.email}
                onChange={(e) => setForm((f) => ({ ...f, email: e.target.value }))}
                required
              />
            </label>

            <label>
              First name
              <input
                value={form.firstName}
                onChange={(e) => setForm((f) => ({ ...f, firstName: e.target.value }))}
                required
              />
            </label>

            <label>
              Last name
              <input
                value={form.lastName}
                onChange={(e) => setForm((f) => ({ ...f, lastName: e.target.value }))}
                required
              />
            </label>

            {editingId === null && (
              <label>
                Password
                <input
                  type="password"
                  value={form.password}
                  onChange={(e) => setForm((f) => ({ ...f, password: e.target.value }))}
                  minLength={8}
                  required
                />
              </label>
            )}

            <label>
              Phone number
              <input
                value={form.phoneNumber}
                onChange={(e) => setForm((f) => ({ ...f, phoneNumber: e.target.value }))}
              />
            </label>

            <label>
              Department
              <select
                value={form.departmentId}
                onChange={(e) => setForm((f) => ({ ...f, departmentId: e.target.value }))}
                required
              >
                <option value="" disabled>
                  Select a department
                </option>
                {departments.map((d) => (
                  <option key={d.id} value={d.id}>
                    {d.name}
                  </option>
                ))}
              </select>
            </label>

            <label>
              Role
              <select value={form.role} onChange={(e) => setForm((f) => ({ ...f, role: e.target.value as Role }))}>
                {ROLES.map((role) => (
                  <option key={role} value={role}>
                    {role}
                  </option>
                ))}
              </select>
            </label>

            <label>
              Manager
              <select
                value={form.managerId}
                onChange={(e) => setForm((f) => ({ ...f, managerId: e.target.value }))}
              >
                <option value="">No manager</option>
                {managerOptions.map((m) => (
                  <option key={m.id} value={m.id}>
                    {m.firstName} {m.lastName} ({m.role})
                  </option>
                ))}
              </select>
            </label>

            {editingId !== null && (
              <label className="checkbox-field">
                <input
                  type="checkbox"
                  checked={form.isActive}
                  onChange={(e) => setForm((f) => ({ ...f, isActive: e.target.checked }))}
                />
                Active
              </label>
            )}
          </div>

          {formError && <p className="field-error">{formError}</p>}

          <div className="form-actions">
            <button type="submit" className="primary-button" disabled={formSubmitting}>
              {formSubmitting ? "Saving…" : "Save"}
            </button>
            <button type="button" className="secondary-button" onClick={closeForm}>
              Cancel
            </button>
          </div>
        </form>
      )}

      {employees === null && !loadError && <Spinner />}

      {employees && employees.length > 0 && (
        <table className="data-table">
          <thead>
            <tr>
              <th>Code</th>
              <th>Name</th>
              <th>Department</th>
              <th>Role</th>
              <th>Manager</th>
              <th>Status</th>
              {canManage && <th aria-label="Actions" />}
            </tr>
          </thead>
          <tbody>
            {employees.map((employee) => (
              <tr key={employee.id}>
                <td>{employee.employeeCode}</td>
                <td>
                  {employee.firstName} {employee.lastName}
                  <div className="employee-email">{employee.email}</div>
                </td>
                <td>{employee.departmentName}</td>
                <td>{employee.role}</td>
                <td>{employee.managerName ?? "—"}</td>
                <td>
                  <span className={"status-pill" + (employee.isActive ? " active" : " inactive")}>
                    {employee.isActive ? "Active" : "Inactive"}
                  </span>
                </td>
                {canManage && (
                  <td className="actions-cell">
                    <button type="button" className="link-button" onClick={() => openEditForm(employee)}>
                      Edit
                    </button>
                    {employee.isActive && (
                      <button
                        type="button"
                        className="link-button danger"
                        onClick={() => handleDeactivate(employee)}
                        disabled={deactivatingId === employee.id}
                      >
                        {deactivatingId === employee.id ? "Deactivating…" : "Deactivate"}
                      </button>
                    )}
                  </td>
                )}
              </tr>
            ))}
          </tbody>
        </table>
      )}
    </div>
  );
}
