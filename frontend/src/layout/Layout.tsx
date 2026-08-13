import { NavLink, Outlet, useLocation } from "react-router-dom";
import { useAuth } from "../auth/AuthContext";
import { ThemeToggle } from "../components/ThemeToggle";
import { NavIcon } from "./navIcons";
import { NAV_GROUPS, NAV_ITEMS, type NavItem } from "./navItems";
import "./Layout.css";

function initials(fullName: string): string {
  const parts = fullName.trim().split(/\s+/);
  return ((parts[0]?.[0] ?? "") + (parts[parts.length - 1]?.[0] ?? "")).toUpperCase();
}

function today(): string {
  return new Date().toLocaleDateString(undefined, { weekday: "long", day: "numeric", month: "long" });
}

export function Layout() {
  const { user, logout } = useAuth();
  const { pathname } = useLocation();

  // ProtectedRoute already guarantees `user` is set before Layout ever
  // renders, but TypeScript doesn't know that across components — this keeps
  // the rest of the component free of `user?.` everywhere.
  if (!user) {
    return null;
  }

  const visibleItems = NAV_ITEMS.filter((item) => item.roles.includes(user.role));

  // Only sections that still have a link for this role get a heading.
  const sections = NAV_GROUPS.map((group) => ({
    group,
    items: visibleItems.filter((item) => item.group === group),
  })).filter((section) => section.items.length > 0);

  // Drives the top-bar breadcrumb. Every route in App.tsx has a matching nav
  // item, so an exact match is enough.
  const current: NavItem | undefined = visibleItems.find((item) => item.path === pathname);

  return (
    <div className="app-shell">
      <aside className="sidebar">
        <div className="sidebar-brand">
          <span className="brand-mark" aria-hidden="true">
            <svg viewBox="0 0 24 24" width="18" height="18" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
              <path d="M12 3.2 20 7v10l-8 3.8L4 17V7z" />
              <path d="M12 11.2 20 7M12 11.2 4 7M12 11.2v9.6" />
            </svg>
          </span>
          <span className="brand-text">
            <span className="brand-name">Employee MS</span>
            <span className="brand-tagline">Workforce console</span>
          </span>
        </div>

        <nav className="sidebar-nav" aria-label="Main">
          {sections.map((section) => (
            <div className="nav-group" key={section.group}>
              <p className="nav-group-title">{section.group}</p>
              {section.items.map((item) => (
                <NavLink
                  key={item.path}
                  to={item.path}
                  end={item.path === "/"}
                  className={({ isActive }) => "nav-link" + (isActive ? " active" : "")}
                >
                  <NavIcon path={item.path} />
                  <span>{item.label}</span>
                </NavLink>
              ))}
            </div>
          ))}
        </nav>

        <div className="sidebar-footer">
          <div className="today-chip">
            <svg viewBox="0 0 24 24" width="15" height="15" fill="none" stroke="currentColor" strokeWidth="1.8" strokeLinecap="round" strokeLinejoin="round" aria-hidden="true">
              <rect x="3.5" y="4.5" width="17" height="16" rx="2.5" />
              <path d="M3.5 9.5h17M8 3v3M16 3v3" />
            </svg>
            <span>{today()}</span>
          </div>
        </div>
      </aside>

      <div className="main-column">
        <header className="top-bar">
          <nav className="breadcrumb" aria-label="Breadcrumb">
            <span className="breadcrumb-root">Employee MS</span>
            {current && (
              <>
                <span className="breadcrumb-sep" aria-hidden="true">
                  /
                </span>
                <span className="breadcrumb-group">{current.group}</span>
                <span className="breadcrumb-sep" aria-hidden="true">
                  /
                </span>
                <span className="breadcrumb-current" aria-current="page">
                  {current.label}
                </span>
              </>
            )}
          </nav>

          <div className="top-bar-actions">
            <ThemeToggle />
            <span className="top-bar-divider" aria-hidden="true" />
            <div className="user-chip">
              <span className="user-avatar" aria-hidden="true">
                {initials(user.fullName)}
              </span>
              <span className="user-chip-text">
                <span className="user-name">{user.fullName}</span>
                <span className="user-role">{user.role}</span>
              </span>
            </div>
            <button type="button" className="logout-button" onClick={logout}>
              <svg viewBox="0 0 24 24" width="16" height="16" fill="none" stroke="currentColor" strokeWidth="1.8" strokeLinecap="round" strokeLinejoin="round" aria-hidden="true">
                <path d="M15 17v1.5a2 2 0 0 1-2 2H6a2 2 0 0 1-2-2v-13a2 2 0 0 1 2-2h7a2 2 0 0 1 2 2V7" />
                <path d="M10 12h10m0 0-3-3m3 3-3 3" />
              </svg>
              <span className="logout-label">Log out</span>
            </button>
          </div>
        </header>

        <main className="page-content">
          <div className="page-container">
            <Outlet />
          </div>
        </main>
      </div>
    </div>
  );
}
