# Employee Management System (EMS)

A full-stack employee management system: one ASP.NET Core API backing two independent clients — a React web app and a Flutter mobile app — for managing employees, departments, attendance, and leave, with role-based access for Admin, Manager, and Employee accounts.

## Overview

| Part | What it is | Tech |
|---|---|---|
| [`backend/`](backend/README.md) | REST API, auth, and the database schema | ASP.NET Core 8, EF Core, PostgreSQL |
| [`frontend/`](frontend/README.md) | Web client | React 19, TypeScript, Vite |
| [`mobile/`](mobile/README.md) | Mobile client | Flutter, Riverpod, Clean Architecture |

The web and mobile clients are independent apps that both talk to the same backend and enforce the same role-based permissions — nothing is duplicated or faked on the client side; every screen reflects exactly what the API allows for the signed-in role.

## Features

- **Auth** — JWT login, three roles (Admin / Manager / Employee), each seeing only the sections and actions their role permits
- **Dashboard** — today's attendance status, role-scoped headline stats, and shortcuts into the rest of the app
- **Employees** — directory with create/edit/deactivate (Admin-only writes)
- **Departments** — create/edit/delete, with a live employee count per department (Admin-only writes)
- **Attendance** — self-service check-in/check-out and history, plus a filterable team view for Managers/Admins
- **Leave** — submit leave requests and track their status, plus an approval queue for Managers/Admins (Managers may only decide on their own direct reports)

## Project structure

```
employee-management-system/
  backend/     ASP.NET Core Web API — the single source of truth both clients talk to
  frontend/    React + TypeScript web client
  mobile/      Flutter mobile client
```

Each has its own README with full setup, architecture, and testing details — this file is just the map.

## Getting started

The backend has to be running first; both clients need it.

1. **Backend** — see [backend/README.md](backend/README.md) for full setup (PostgreSQL connection string, JWT key, migrations). Once running:
   ```bash
   cd backend
   dotnet restore
   dotnet ef database update
   dotnet run
   ```
   Listens at `http://localhost:5133`, with Swagger UI at `http://localhost:5133/swagger`. Three accounts (one per role) are seeded automatically on first run — see below.

2. **Web client** — see [frontend/README.md](frontend/README.md):
   ```bash
   cd frontend
   npm install
   npm run dev
   ```
   Opens at `http://localhost:5173`.

3. **Mobile client** — see [mobile/README.md](mobile/README.md):
   ```bash
   cd mobile
   flutter pub get
   flutter run
   ```
   Points at `localhost:5133` by default (`10.0.2.2` automatically on the Android emulator); pass `--dart-define=API_BASE_URL=...` for a physical device on the same network.

## Configuration keys

Backend configuration lives in `backend/appsettings.json` (and `backend/appsettings.Development.json` for environment overrides):

| Key | Purpose |
|---|---|
| `ConnectionStrings:DefaultConnection` | PostgreSQL connection string — set this to your own local database before first run |
| `Jwt:Key` | Secret used to sign/validate JWTs (HMAC-SHA256) — replace with your own random 32+ character value |
| `Jwt:Issuer` | JWT `iss` claim, validated on every request |
| `Jwt:Audience` | JWT `aud` claim, validated on every request |
| `Jwt:ExpiryMinutes` | How long an issued token stays valid |
| `Cors:AllowedOrigins` | Origins allowed to call the API from a browser (the web client's dev URLs) |

The mobile client's API base URL is set in `mobile/lib/core/network/api_host.dart` (`localhost` by default, override with `--dart-define=API_BASE_URL=...`); the web client's is set via `VITE_API_BASE_URL` in `frontend/.env`.

## Default accounts

Seeded automatically the first time the backend runs against an empty database:

| Role | Email | Password |
|---|---|---|
| Admin | `admin@ems.local` | `Passw0rd!` |
| Manager | `manager@ems.local` | `Passw0rd!` |
| Employee | `employee@ems.local` | `Passw0rd!` |

## Testing

```bash
# Mobile (widget + unit tests)
cd mobile && flutter analyze && flutter test
```
