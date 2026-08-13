import { Navigate, Outlet } from "react-router-dom";
import { useAuth } from "./AuthContext";

// Client-side gate, not a security boundary by itself — the API still enforces
// [Authorize(Roles=...)] on every request. This just avoids flashing a page
// the user can't actually use before the API would reject it.
export function ProtectedRoute() {
  const { user } = useAuth();

  if (!user) {
    return <Navigate to="/login" replace />;
  }

  return <Outlet />;
}
