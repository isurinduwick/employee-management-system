import { createContext, useContext, useState, type ReactNode } from "react";
import { login as loginRequest } from "../api/auth";
import { AUTH_STORAGE_KEY } from "../api/client";
import type { LoginResponse, Role } from "../types/auth";

interface AuthUser {
  employeeId: number;
  fullName: string;
  role: Role;
}

interface AuthContextValue {
  user: AuthUser | null;
  login: (email: string, password: string) => Promise<void>;
  logout: () => void;
}

const AuthContext = createContext<AuthContextValue | undefined>(undefined);

function readStoredUser(): AuthUser | null {
  const raw = localStorage.getItem(AUTH_STORAGE_KEY);
  if (!raw) return null;

  try {
    const stored = JSON.parse(raw) as LoginResponse;
    return { employeeId: stored.employeeId, fullName: stored.fullName, role: stored.role };
  } catch {
    // Malformed/stale data from an earlier session — don't let it crash the
    // whole app on load, just treat it as "not logged in."
    localStorage.removeItem(AUTH_STORAGE_KEY);
    return null;
  }
}

// Reading from localStorage on mount is what keeps a user logged in across a
// page refresh — otherwise React state alone would reset to null every reload.
export function AuthProvider({ children }: { children: ReactNode }) {
  const [user, setUser] = useState<AuthUser | null>(readStoredUser);

  async function login(email: string, password: string) {
    const response = await loginRequest({ email, password });
    localStorage.setItem(AUTH_STORAGE_KEY, JSON.stringify(response));
    setUser({ employeeId: response.employeeId, fullName: response.fullName, role: response.role });
  }

  function logout() {
    localStorage.removeItem(AUTH_STORAGE_KEY);
    setUser(null);
  }

  return <AuthContext.Provider value={{ user, login, logout }}>{children}</AuthContext.Provider>;
}

export function useAuth(): AuthContextValue {
  const ctx = useContext(AuthContext);
  if (!ctx) {
    throw new Error("useAuth must be used within an AuthProvider");
  }
  return ctx;
}
