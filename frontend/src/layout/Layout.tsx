import { NavLink, Outlet } from "react-router-dom";
import { useAuth } from "../auth/AuthContext";
import { NAV_ITEMS } from "./navItems";
import "./Layout.css";

export function Layout() {
  const { user, logout } = useAuth();

  // ProtectedRoute already guarantees `user` is set before Layout ever
  // renders, but TypeScript doesn't know that across components — this keeps
  // the rest of the component free of `user?.` everywhere.
  if (!user) {
    return null;
  }

  const visibleItems = NAV_ITEMS.filter((item) => item.roles.includes(user.role));

  return (
    <div className="app-shell">
      <aside className="sidebar">
        <div className="sidebar-brand">EMS</div>
        <nav className="sidebar-nav">
          {visibleItems.map((item) => (
            <NavLink
              key={item.path}
              to={item.path}
              end={item.path === "/"}
              className={({ isActive }) => "nav-link" + (isActive ? " active" : "")}
            >
              {item.label}
            </NavLink>
          ))}
        </nav>
      </aside>

      <div className="main-column">
        <header className="top-bar">
          <div className="top-bar-user">
            <span className="user-name">{user.fullName}</span>
            <span className="user-role">{user.role}</span>
          </div>
          <button type="button" className="logout-button" onClick={logout}>
            Log out
          </button>
        </header>

        <main className="page-content">
          <Outlet />
        </main>
      </div>
    </div>
  );
}
