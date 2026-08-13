import { useState, type FormEvent } from "react";
import { useNavigate } from "react-router-dom";
import { useAuth } from "../auth/AuthContext";
import "./Login.css";

const EMAIL_PATTERN = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;

interface FieldErrors {
  email?: string;
  password?: string;
}

function validate(email: string, password: string): FieldErrors {
  const errors: FieldErrors = {};

  if (!email.trim()) {
    errors.email = "Email is required.";
  } else if (!EMAIL_PATTERN.test(email.trim())) {
    errors.email = "Enter a valid email address.";
  }

  if (!password) {
    errors.password = "Password is required.";
  }

  return errors;
}

export function Login() {
  const { login } = useAuth();
  const navigate = useNavigate();

  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [showPassword, setShowPassword] = useState(false);
  const [touched, setTouched] = useState({ email: false, password: false });
  const [formError, setFormError] = useState<string | null>(null);
  const [submitting, setSubmitting] = useState(false);

  const fieldErrors = validate(email, password);

  async function handleSubmit(event: FormEvent) {
    event.preventDefault();
    setTouched({ email: true, password: true });
    setFormError(null);

    // Client-side validation catches empty/malformed input before it ever
    // reaches the network — the API is still the real source of truth for
    // whether the credentials are actually correct.
    if (fieldErrors.email || fieldErrors.password) {
      return;
    }

    setSubmitting(true);
    try {
      await login(email.trim(), password);
      navigate("/", { replace: true });
    } catch {
      setFormError("Invalid email or password.");
    } finally {
      setSubmitting(false);
    }
  }

  return (
    <main className="login-page">
      <form className="login-card" onSubmit={handleSubmit} noValidate>
        <div className="login-brand">
          <span className="login-mark" aria-hidden="true">
            EMS
          </span>
          <h1>Welcome back</h1>
          <p className="login-subtitle">Sign in to the Employee Management System</p>
        </div>

        <div className="login-field">
          <label htmlFor="email">Email</label>
          <input
            id="email"
            type="email"
            value={email}
            onChange={(event) => setEmail(event.target.value)}
            onBlur={() => setTouched((t) => ({ ...t, email: true }))}
            autoComplete="username"
            autoFocus
            aria-invalid={touched.email && Boolean(fieldErrors.email)}
            aria-describedby={fieldErrors.email ? "email-error" : undefined}
          />
          {touched.email && fieldErrors.email && (
            <p className="field-error" id="email-error">
              {fieldErrors.email}
            </p>
          )}
        </div>

        <div className="login-field">
          <label htmlFor="password">Password</label>
          <div className="password-input">
            <input
              id="password"
              type={showPassword ? "text" : "password"}
              value={password}
              onChange={(event) => setPassword(event.target.value)}
              onBlur={() => setTouched((t) => ({ ...t, password: true }))}
              autoComplete="current-password"
              aria-invalid={touched.password && Boolean(fieldErrors.password)}
              aria-describedby={fieldErrors.password ? "password-error" : undefined}
            />
            <button
              type="button"
              className="password-toggle"
              onClick={() => setShowPassword((v) => !v)}
              aria-label={showPassword ? "Hide password" : "Show password"}
              tabIndex={-1}
            >
              {showPassword ? <EyeOffIcon /> : <EyeIcon />}
            </button>
          </div>
          {touched.password && fieldErrors.password && (
            <p className="field-error" id="password-error">
              {fieldErrors.password}
            </p>
          )}
        </div>

        {formError && (
          <p className="login-alert" role="alert">
            {formError}
          </p>
        )}

        <button type="submit" className="login-submit" disabled={submitting}>
          {submitting && <span className="login-spinner" aria-hidden="true" />}
          {submitting ? "Signing in…" : "Sign in"}
        </button>
      </form>
    </main>
  );
}

function EyeIcon() {
  return (
    <svg viewBox="0 0 24 24" width="18" height="18" fill="none" stroke="currentColor" strokeWidth="1.8" strokeLinecap="round" strokeLinejoin="round">
      <path d="M1.5 12s4-7 10.5-7 10.5 7 10.5 7-4 7-10.5 7S1.5 12 1.5 12z" />
      <circle cx="12" cy="12" r="3" />
    </svg>
  );
}

function EyeOffIcon() {
  return (
    <svg viewBox="0 0 24 24" width="18" height="18" fill="none" stroke="currentColor" strokeWidth="1.8" strokeLinecap="round" strokeLinejoin="round">
      <path d="M3 3l18 18" />
      <path d="M10.6 5.1A10.9 10.9 0 0 1 12 5c6.5 0 10.5 7 10.5 7a17.4 17.4 0 0 1-3.2 4.1M6.4 6.4C3.6 8.1 1.5 12 1.5 12s4 7 10.5 7a10.6 10.6 0 0 0 4.9-1.2" />
      <path d="M9.9 9.9a3 3 0 0 0 4.2 4.2" />
    </svg>
  );
}
