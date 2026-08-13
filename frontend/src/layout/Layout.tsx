import { NavLink, Outlet } from "react-router-dom";
import { useAuth } from "../auth/AuthContext";
import { ThemeToggle } from "../components/ThemeToggle";
import { NavIcon } from "./navIcons";
import { NAV_ITEMS } from "./navItems";
import "./Layout.css";

function initials(fullName: string): string {
  const parts = fullName.trim().split(/\s+/);
  return ((parts[0]?.[0] ?? "") + (parts[parts.length - 1]?.[0] ?? "")).toUpperCase();
}

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
        <div className="sidebar-brand">
          <span className="brand-mark" aria-hidden="true">
            EMS
          </span>
          <span className="brand-name">Employee MS</span>
        </div>
        <nav className="sidebar-nav">
          {visibleItems.map((item) => (
            <NavLink
              key={item.path}
              to={item.path}
              end={item.path === "/"}
              className={({ isActive }) => "nav-link" + (isActive ? " active" : "")}
            >
              <NavIcon path={item.path} />
              {item.label}
            </NavLink>
          ))}
        </nav>
      </aside>

      <div className="main-column">
        <header className="top-bar">
          <div className="top-bar-user">
            <span className="user-avatar" aria-hidden="true">
              {initials(user.fullName)}
            </span>
            <div className="top-bar-user-text">
              <span className="user-name">{user.fullName}</span>
              <span className="user-role">{user.role}</span>
            </div>
          </div>
          <div className="top-bar-actions">
            <ThemeToggle />
            <button type="button" className="logout-button" onClick={logout}>
              Log out
            </button>
          </div>
        </header>

        <main className="page-content">
          <Outlet />
        </main>
      </div>
    </div>
  );
}
