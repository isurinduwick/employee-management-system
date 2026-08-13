import type { ReactNode } from "react";
import { Link } from "react-router-dom";
import "./StatCard.css";

interface StatCardProps {
  label: string;
  value: string | number;
  to?: string;
  icon?: ReactNode;
  hint?: string;
}

export function StatCard({ label, value, to, icon, hint }: StatCardProps) {
  const content = (
    <>
      <div className="stat-card-top">
        {icon && (
          <span className="stat-icon" aria-hidden="true">
            {icon}
          </span>
        )}
        {to && (
          <span className="stat-arrow" aria-hidden="true">
            <svg viewBox="0 0 24 24" width="15" height="15" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
              <path d="M5 12h13m0 0-5-5m5 5-5 5" />
            </svg>
          </span>
        )}
      </div>
      <span className="stat-value">{value}</span>
      <span className="stat-label">{label}</span>
      {hint && <span className="stat-hint">{hint}</span>}
    </>
  );

  return to ? (
    <Link to={to} className="stat-card stat-card-link">
      {content}
    </Link>
  ) : (
    <div className="stat-card">{content}</div>
  );
}
