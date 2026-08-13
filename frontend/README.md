# EMS Frontend

React web client for the Enterprise Employee Management System — login, role-based navigation, and screens for Departments, Employees, Attendance, and Leave, backed by the [backend API](../backend/README.md).

## Tech stack

- React 19 + TypeScript
- Vite (dev server + build)
- React Router (routing, protected routes)
- Axios (API client, JWT attached via interceptor)

## Prerequisites

- Node.js 18+
- The [backend API](../backend/README.md) running locally (default `http://localhost:5133`), with its database migrated and seeded

## Setup

1. **Install dependencies**

   ```bash
   npm install
   ```

2. **Point the app at the backend**

   The API base URL is read from `.env`:

   ```
   VITE_API_BASE_URL=http://localhost:5133
   ```

   Change this if your backend runs on a different port. Note: Vite only reads `.env` at startup — if you edit it, restart `npm run dev`.

3. **Run the dev server**

   ```bash
   npm run dev
   ```

   Opens at `http://localhost:5173` by default. If that port is already in use, Vite picks the next free one (`5174`, `5175`, ...) — the backend's CORS policy is configured to allow all three, so this doesn't break anything.

## Logging in

Use one of the backend's seeded accounts (see [backend/README.md](../backend/README.md) for the full list), e.g.:

| Email | Password | Role |
|---|---|---|
| `admin@ems.local` | `Passw0rd!` | Admin |
| `manager@ems.local` | `Passw0rd!` | Manager |
| `employee@ems.local` | `Passw0rd!` | Employee |

## Routes

| Route | Page | Visible to |
|---|---|---|
| `/login` | Login | everyone |
| `/` | Dashboard | everyone |
| `/departments` | Departments (list open to all; create/edit/delete Admin-only) | everyone |
| `/employees` | Employees (list open to all; create/edit/deactivate Admin-only) | everyone |
| `/attendance`, `/attendance/team` | Check-in/out + history (filters for Manager/Admin) | everyone |
| `/leave`, `/leave/approvals` | Submit + approve/reject (Manager only decides on their own direct reports) | everyone |

The sidebar only *links* to the sections a role can use (see `src/layout/navItems.ts`), but every route mirrors the backend's actual permissions rather than enforcing its own separate rules — visiting a URL directly behaves the same as what the API would allow.

## Available scripts

```bash
npm run dev      # start the dev server
npm run build    # type-check (tsc -b) and produce a production build in dist/
npm run preview  # serve the production build locally
npm run lint      # oxlint
```

## Project structure

```
src/
  api/          axios client + one module per resource (auth, employees, departments, attendance, leave)
  auth/         AuthContext (JWT/session state), ProtectedRoute
  layout/       Sidebar/top-bar shell and the role-filtered nav item list
  components/   Shared UI: Toast (success/error notifications), Spinner
  pages/        One component per route, plus its page-specific CSS
  styles/       data-page.css — shared table/form/button styling used by every CRUD screen
  types/        TypeScript types mirroring the backend's DTOs exactly
```
