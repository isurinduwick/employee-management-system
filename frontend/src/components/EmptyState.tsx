// Shown wherever a list comes back empty, replacing the bare "No X found."
// paragraphs each page used to render on its own.
export function EmptyState({ title, hint }: { title: string; hint?: string }) {
  return (
    <div className="empty-state">
      <span className="empty-state-icon" aria-hidden="true">
        <svg viewBox="0 0 24 24" width="22" height="22" fill="none" stroke="currentColor" strokeWidth="1.6" strokeLinecap="round" strokeLinejoin="round">
          <path d="M4 7.5 12 3.5l8 4v9l-8 4-8-4z" />
          <path d="M4 7.5 12 11.5l8-4M12 11.5V20.5" />
        </svg>
      </span>
      <p className="empty-state-title">{title}</p>
      {hint && <p className="empty-state-hint">{hint}</p>}
    </div>
  );
}
