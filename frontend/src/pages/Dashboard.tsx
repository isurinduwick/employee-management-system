import { useAuth } from "../auth/AuthContext";

// Placeholder landing page — real role-specific content (Admin/Manager/Employee
// panels) lands on the frontend/layout and later feature branches.
export function Dashboard() {
  const { user, logout } = useAuth();

  return (
    <main>
      <h1>Welcome, {user?.fullName}</h1>
      <p>Role: {user?.role}</p>
      <button onClick={logout}>Log out</button>
    </main>
  );
}
