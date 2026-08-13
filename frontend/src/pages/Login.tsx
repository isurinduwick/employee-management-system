import axios from "axios";
import { useState, type FormEvent } from "react";
import { useNavigate } from "react-router-dom";
import { useAuth } from "../auth/AuthContext";
import "./Login.css";

const EMAIL_PATTERN = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;

const EMAIL_MIN_LENGTH = 4;
const EMAIL_MAX_LENGTH = 40;
const PASSWORD_MIN_LENGTH = 6;
const PASSWORD_MAX_LENGTH = 12;

interface FieldErrors {
  email?: string;
  password?: string;
}

function validate(email: string, password: string): FieldErrors {
  const errors: FieldErrors = {};
  const trimmedEmail = email.trim();

  if (!trimmedEmail) {
    errors.email = "Email is required.";
  } else if (trimmedEmail.length < EMAIL_MIN_LENGTH || trimmedEmail.length > EMAIL_MAX_LENGTH) {
    errors.email = `Email must be ${EMAIL_MIN_LENGTH}-${EMAIL_MAX_LENGTH} characters.`;
  } else if (!EMAIL_PATTERN.test(trimmedEmail)) {
    errors.email = "Enter a valid email address.";
  }

  if (!password) {
    errors.password = "Password is required.";
  } else if (password.length < PASSWORD_MIN_LENGTH || password.length > PASSWORD_MAX_LENGTH) {
    errors.password = `Password must be ${PASSWORD_MIN_LENGTH}-${PASSWORD_MAX_LENGTH} characters.`;
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
    } catch (err) {
      // A 401 means the API itself rejected the credentials — anything else
      // (network failure, CORS block, 500) is a different problem and
      // shouldn't be mislabeled as a wrong password.
      if (axios.isAxiosError(err) && err.response?.status === 401) {
        setFormError("Invalid email or password.");
      } else if (axios.isAxiosError(err) && !err.response) {
        setFormError("Couldn't reach the server. Is the API running?");
      } else {
        setFormError("Something went wrong. Please try again.");
      }
    } finally {
      setSubmitting(false);
    }
  }

  return (
    <main className="login-page">
      <div className="login-shell">
        <section className="login-aside" aria-hidden="true">
          <div className="login-aside-brand">
            <span className="login-mark">
              <svg viewBox="0 0 24 24" width="20" height="20" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
                <path d="M12 3.2 20 7v10l-8 3.8L4 17V7z" />
                <path d="M12 11.2 20 7M12 11.2 4 7M12 11.2v9.6" />
              </svg>
            </span>
            <span className="login-aside-name">Employee MS</span>
          </div>

          <div className="login-aside-body">
            <h2>Everything your team runs on, in one place.</h2>
            <ul className="login-points">
              <li>People and departments, always current</li>
              <li>Daily attendance with a full history</li>
              <li>Leave requests and approvals end to end</li>
            </ul>
          </div>

          <p className="login-aside-foot">Employee Management System</p>
        </section>

        <form className="login-card" onSubmit={handleSubmit} noValidate>
          <div className="login-brand">
            <span className="login-mark login-mark-compact" aria-hidden="true">
              <svg viewBox="0 0 24 24" width="18" height="18" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
                <path d="M12 3.2 20 7v10l-8 3.8L4 17V7z" />
                <path d="M12 11.2 20 7M12 11.2 4 7M12 11.2v9.6" />
              </svg>
            </span>
            <h1>Welcome back</h1>
            <p className="login-subtitle">Sign in to continue to your workspace</p>
          </div>

          <div className="login-field">
            <label htmlFor="email">Email</label>
            <input
              id="email"
              type="email"
              placeholder="you@company.com"
              value={email}
              onChange={(event) => setEmail(event.target.value)}
              onBlur={() => setTouched((t) => ({ ...t, email: true }))}
              autoComplete="username"
              autoFocus
              minLength={EMAIL_MIN_LENGTH}
              maxLength={EMAIL_MAX_LENGTH}
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
                placeholder="••••••••"
                value={password}
                onChange={(event) => setPassword(event.target.value)}
                onBlur={() => setTouched((t) => ({ ...t, password: true }))}
                autoComplete="current-password"
                minLength={PASSWORD_MIN_LENGTH}
                maxLength={PASSWORD_MAX_LENGTH}
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
      </div>
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
