import { Link } from "react-router-dom";
import "./StatCard.css";

interface StatCardProps {
  label: string;
  value: string | number;
  to?: string;
}

export function StatCard({ label, value, to }: StatCardProps) {
  const content = (
    <>
      <span className="stat-value">{value}</span>
      <span className="stat-label">{label}</span>
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
