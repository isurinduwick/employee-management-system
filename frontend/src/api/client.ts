import axios from "axios";

// The whole LoginResponse is stored under one key, so the token, role, and
// name all load back together on a page refresh instead of drifting apart.
export const AUTH_STORAGE_KEY = "ems_auth";

export const apiClient = axios.create({
  baseURL: import.meta.env.VITE_API_BASE_URL,
});

// Attaches the JWT to every outgoing request — this is what replaces manually
// setting the Authorization header on each call.
apiClient.interceptors.request.use((config) => {
  const stored = localStorage.getItem(AUTH_STORAGE_KEY);
  if (stored) {
    try {
      const { token } = JSON.parse(stored) as { token: string };
      config.headers.Authorization = `Bearer ${token}`;
    } catch {
      // Malformed/stale data — drop it rather than let a parse error abort
      // every outgoing request (including login itself) before it's even sent.
      localStorage.removeItem(AUTH_STORAGE_KEY);
    }
  }
  return config;
});

// A 401 means the token is missing, expired, or invalid — the backend already
// decided that, so there's nothing to retry. Clearing the stale session and
// bouncing to /login stops every subsequent request from failing the same way.
apiClient.interceptors.response.use(
  (response) => response,
  (error) => {
    if (error.response?.status === 401 && window.location.pathname !== "/login") {
      localStorage.removeItem(AUTH_STORAGE_KEY);
      window.location.href = "/login";
    }
    return Promise.reject(error);
  },
);

// Controller actions like Conflict("...")/BadRequest("...") return the message
// as a raw JSON string body; validation failures instead return a
// ProblemDetails object with a `title`. This normalizes both into one string
// so every page can show a real backend message instead of a generic one.
export function extractErrorMessage(err: unknown, fallback: string): string {
  if (axios.isAxiosError(err)) {
    const data = err.response?.data;
    if (typeof data === "string") return data;
    if (data && typeof data === "object" && "title" in data) {
      return String((data as { title: unknown }).title);
    }
  }
  return fallback;
}
