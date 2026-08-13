import { useEffect, useState, type FormEvent } from "react";
import { extractErrorMessage } from "../api/client";
import { createDepartment, deleteDepartment, getDepartments, updateDepartment } from "../api/departments";
import { useAuth } from "../auth/AuthContext";
import type { Department } from "../types/department";
import "../styles/data-page.css";

export function Departments() {
  const { user } = useAuth();
  const canManage = user?.role === "Admin"; // reads are open to everyone; writes are Admin-only, same as the API

  const [departments, setDepartments] = useState<Department[] | null>(null);
  const [loadError, setLoadError] = useState<string | null>(null);

  const [isCreating, setIsCreating] = useState(false);
  const [newName, setNewName] = useState("");
  const [createError, setCreateError] = useState<string | null>(null);
  const [createSubmitting, setCreateSubmitting] = useState(false);

  const [editingId, setEditingId] = useState<number | null>(null);
  const [editName, setEditName] = useState("");
  const [editError, setEditError] = useState<string | null>(null);
  const [editSubmitting, setEditSubmitting] = useState(false);

  const [deletingId, setDeletingId] = useState<number | null>(null);
  const [deleteError, setDeleteError] = useState<string | null>(null);

  useEffect(() => {
    loadDepartments();
  }, []);

  async function loadDepartments() {
    setLoadError(null);
    try {
      const data = await getDepartments();
      setDepartments(data);
    } catch (err) {
      setLoadError(extractErrorMessage(err, "Failed to load departments."));
    }
  }

  async function handleCreate(event: FormEvent) {
    event.preventDefault();
    if (!newName.trim()) {
      setCreateError("Department name is required.");
      return;
    }

    setCreateSubmitting(true);
    setCreateError(null);
    try {
      const created = await createDepartment({ name: newName.trim() });
      setDepartments((prev) => [...(prev ?? []), created]);
      setNewName("");
      setIsCreating(false);
    } catch (err) {
      setCreateError(extractErrorMessage(err, "Failed to create department."));
    } finally {
      setCreateSubmitting(false);
    }
  }

  function startEdit(department: Department) {
    setEditingId(department.id);
    setEditName(department.name);
    setEditError(null);
  }

  function cancelEdit() {
    setEditingId(null);
    setEditError(null);
  }

  async function handleEditSave(id: number) {
    if (!editName.trim()) {
      setEditError("Department name is required.");
      return;
    }

    setEditSubmitting(true);
    setEditError(null);
    try {
      const updated = await updateDepartment(id, { name: editName.trim() });
      setDepartments((prev) => prev?.map((d) => (d.id === id ? updated : d)) ?? null);
      setEditingId(null);
    } catch (err) {
      setEditError(extractErrorMessage(err, "Failed to update department."));
    } finally {
      setEditSubmitting(false);
    }
  }

  async function handleDelete(department: Department) {
    if (!window.confirm(`Delete "${department.name}"? This can't be undone.`)) {
      return;
    }

    setDeletingId(department.id);
    setDeleteError(null);
    try {
      await deleteDepartment(department.id);
      setDepartments((prev) => prev?.filter((d) => d.id !== department.id) ?? null);
    } catch (err) {
      setDeleteError(extractErrorMessage(err, "Failed to delete department."));
    } finally {
      setDeletingId(null);
    }
  }

  return (
    <div className="data-page">
      <div className="page-header">
        <h1>Departments</h1>
        {canManage && !isCreating && (
          <button type="button" className="primary-button" onClick={() => setIsCreating(true)}>
            New Department
          </button>
        )}
      </div>

      {loadError && <p className="page-alert">{loadError}</p>}
      {deleteError && <p className="page-alert">{deleteError}</p>}

      {isCreating && (
        <form className="create-row" onSubmit={handleCreate}>
          <input
            type="text"
            placeholder="Department name"
            value={newName}
            onChange={(event) => setNewName(event.target.value)}
            maxLength={100}
            autoFocus
          />
          <button type="submit" className="primary-button" disabled={createSubmitting}>
            {createSubmitting ? "Saving…" : "Save"}
          </button>
          <button
            type="button"
            className="secondary-button"
            onClick={() => {
              setIsCreating(false);
              setNewName("");
              setCreateError(null);
            }}
          >
            Cancel
          </button>
          {createError && <p className="field-error">{createError}</p>}
        </form>
      )}

      {departments === null && !loadError && <p>Loading…</p>}

      {departments && departments.length === 0 && <p>No departments yet.</p>}

      {departments && departments.length > 0 && (
        <table className="data-table">
          <thead>
            <tr>
              <th>Name</th>
              <th>Employees</th>
              {canManage && <th aria-label="Actions" />}
            </tr>
          </thead>
          <tbody>
            {departments.map((department) => (
              <tr key={department.id}>
                {editingId === department.id ? (
                  <td colSpan={canManage ? 1 : 2}>
                    <div className="edit-row">
                      <input
                        type="text"
                        value={editName}
                        onChange={(event) => setEditName(event.target.value)}
                        maxLength={100}
                        autoFocus
                      />
                    </div>
                    {editError && <p className="field-error">{editError}</p>}
                  </td>
                ) : (
                  <td>{department.name}</td>
                )}

                {editingId !== department.id && <td>{department.employeeCount}</td>}

                {canManage && (
                  <td className="actions-cell">
                    {editingId === department.id ? (
                      <>
                        <button
                          type="button"
                          className="link-button"
                          onClick={() => handleEditSave(department.id)}
                          disabled={editSubmitting}
                        >
                          {editSubmitting ? "Saving…" : "Save"}
                        </button>
                        <button type="button" className="link-button" onClick={cancelEdit}>
                          Cancel
                        </button>
                      </>
                    ) : (
                      <>
                        <button type="button" className="link-button" onClick={() => startEdit(department)}>
                          Edit
                        </button>
                        <button
                          type="button"
                          className="link-button danger"
                          onClick={() => handleDelete(department)}
                          disabled={deletingId === department.id}
                        >
                          {deletingId === department.id ? "Deleting…" : "Delete"}
                        </button>
                      </>
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
