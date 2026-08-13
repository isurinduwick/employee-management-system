import { createContext, useCallback, useContext, useState, type ReactNode } from "react";
import "./Toast.css";

interface ToastMessage {
  id: number;
  text: string;
  variant: "success" | "error";
}

interface ToastContextValue {
  showToast: (text: string, variant?: "success" | "error") => void;
}

const ToastContext = createContext<ToastContextValue | undefined>(undefined);

let nextToastId = 1;
const TOAST_LIFETIME_MS = 3500;

// A page-level success (department created, leave approved, ...) previously
// had no feedback at all beyond the list silently updating — only failures
// showed anything. This gives successful actions the same visibility.
export function ToastProvider({ children }: { children: ReactNode }) {
  const [toasts, setToasts] = useState<ToastMessage[]>([]);

  const showToast = useCallback((text: string, variant: "success" | "error" = "success") => {
    const id = nextToastId++;
    setToasts((prev) => [...prev, { id, text, variant }]);
    setTimeout(() => {
      setToasts((prev) => prev.filter((t) => t.id !== id));
    }, TOAST_LIFETIME_MS);
  }, []);

  return (
    <ToastContext.Provider value={{ showToast }}>
      {children}
      <div className="toast-stack" role="status" aria-live="polite">
        {toasts.map((toast) => (
          <div key={toast.id} className={`toast toast-${toast.variant}`}>
            <span className="toast-text">{toast.text}</span>
          </div>
        ))}
      </div>
    </ToastContext.Provider>
  );
}

export function useToast(): ToastContextValue {
  const ctx = useContext(ToastContext);
  if (!ctx) {
    throw new Error("useToast must be used within a ToastProvider");
  }
  return ctx;
}
