import { useAuth } from "../auth/AuthContext";

// Placeholder landing page — real role-specific content (Admin/Manager/Employee
// panels) lands on later feature branches. Logout lives in the Layout's top
// bar now, not duplicated here.
export function Dashboard() {
  const { user } = useAuth();

  return (
    <div>
      <h1>Welcome, {user?.fullName}</h1>
      <p>Role: {user?.role}</p>
    </div>
  );
}
