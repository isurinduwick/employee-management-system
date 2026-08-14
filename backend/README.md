# EMS Backend API

ASP.NET Core Web API for the Enterprise Employee Management System — employee/department management, attendance tracking, and leave management, with JWT-based role authentication.

## Tech stack

- .NET 8 (ASP.NET Core Web API)
- Entity Framework Core 8 (code-first migrations)
- PostgreSQL
- JWT Bearer authentication with role-based access control (Admin / Manager / Employee)
- BCrypt password hashing
- Swagger / OpenAPI

## Prerequisites

- [.NET 8 SDK](https://dotnet.microsoft.com/download/dotnet/8.0)
- PostgreSQL running locally (or reachable), with a database created for this project
- The [`dotnet-ef`](https://learn.microsoft.com/en-us/ef/core/cli/dotnet) global tool: `dotnet tool install --global dotnet-ef`

## Setup

1. **Configure the database connection and JWT signing key**

   These two values are secrets, so `appsettings.json` ships with them blank rather than committed to source control. Set them locally with the [.NET Secret Manager](https://learn.microsoft.com/aspnet/core/security/app-secrets) — it stores values outside the repo (in your user profile), not in a tracked file:

   ```bash
   dotnet user-secrets init
   dotnet user-secrets set "ConnectionStrings:DefaultConnection" "Host=localhost;Port=5432;Database=ems_db;Username=postgres;Password=your-password"
   dotnet user-secrets set "Jwt:Key" "your-own-random-32+-character-value"
   ```

   In production, set the equivalent environment variables instead (`ConnectionStrings__DefaultConnection`, `Jwt__Key`) — ASP.NET Core maps `__` to the same nested config keys.

2. **Restore and apply the database migrations**

   ```bash
   dotnet restore
   dotnet ef database update
   ```

   This creates all four tables (`Departments`, `Employees`, `AttendanceLogs`, `LeaveRequests`) in the configured database. A plain-SQL equivalent is also checked in at [`schema.sql`](./schema.sql) if you'd rather apply it directly instead of using EF migrations.

3. **Run the API**

   ```bash
   dotnet run
   ```

   On first run, the app automatically seeds three default accounts (see below) if the `Employees` table is empty — no manual seeding step required.

   The API listens at `http://localhost:5133` by default (see `Properties/launchSettings.json`), and opens Swagger UI at `http://localhost:5133/swagger`.

## Configuration keys

All configuration lives in `appsettings.json` (and `appsettings.Development.json` for environment overrides). `ConnectionStrings:DefaultConnection` and `Jwt:Key` are blank there and must be supplied via user-secrets locally or environment variables in production (see [Setup](#setup) above):

| Key | Purpose |
|---|---|
| `ConnectionStrings:DefaultConnection` | PostgreSQL connection string |
| `Jwt:Key` | Secret used to sign/validate JWTs (HMAC-SHA256) |
| `Jwt:Issuer` | JWT `iss` claim, validated on every request |
| `Jwt:Audience` | JWT `aud` claim, validated on every request |
| `Jwt:ExpiryMinutes` | How long an issued token stays valid |
| `Cors:AllowedOrigins` | Array of origins allowed to call the API from a browser (the React app's dev URL) |

## Default seeded accounts

| Role | Email | Password | Notes |
|---|---|---|---|
| Admin | `admin@ems.local` | `Passw0rd!` | No manager; can manage Employees/Departments |
| Manager | `manager@ems.local` | `Passw0rd!` | No manager; can approve/reject their team's leave |
| Employee | `employee@ems.local` | `Passw0rd!` | Reports to the seeded Manager |

Log in via `POST /api/auth/login` with `{ "email": ..., "password": ... }` to get a JWT, then send it as `Authorization: Bearer <token>` on subsequent requests.

## API overview

Full interactive documentation is available via Swagger UI at `http://localhost:5133/swagger` once the app is running (`dotnet run` opens it automatically). Summary:

| Resource | Endpoints |
|---|---|
| Auth | `POST /api/auth/login` |
| Departments | `GET`, `GET /{id}`, `POST`, `PUT /{id}`, `DELETE /{id}` — writes require `Admin` |
| Employees | `GET`, `GET /{id}`, `POST`, `PUT /{id}`, `DELETE /{id}` — writes require `Admin` |
| Attendance | `POST /check-in`, `POST /check-out`, `GET` (filter by `employeeId`, `departmentId`, `startDate`, `endDate`) |
| Leave requests | `POST`, `GET` (filter by `employeeId`, `status`), `PUT /{id}/decision` — decision requires `Manager` or `Admin` |

### Using the Authorize button

Every endpoint except `POST /api/auth/login` requires a JWT:

1. In Swagger UI, expand **Auth → POST /api/auth/login**, "Try it out", and submit one of the [seeded accounts](#default-seeded-accounts) above. Copy the `token` field from the response.
2. Click the **Authorize** button (top right of the page), paste just the token (no `Bearer ` prefix — Swagger UI adds that for you) into the `Bearer` field, and confirm.
3. Every subsequent "Try it out" call now sends `Authorization: Bearer <token>` automatically. Endpoints your logged-in role can't call still return `403 Forbidden`, same as via any other client.

### Reading the API without running the project

A static snapshot of the generated OpenAPI document is checked in at [`../docs/openapi.json`](../docs/openapi.json) — open it directly, or paste it into [editor.swagger.io](https://editor.swagger.io), without starting the API or a database.

To regenerate it after changing an endpoint, run the app once and pull the live document:

```bash
dotnet run &
curl http://localhost:5133/swagger/v1/swagger.json -o ../docs/openapi.json
```

## Running tests

Unit tests live in the sibling `backend.Tests` project (xUnit + EF Core InMemory):

```bash
cd ../backend.Tests
dotnet test
```

## Project structure

```
backend/
  Controllers/    API endpoints
  Models/         EF Core entities and enums
  DTOs/           Request/response shapes (never expose entities directly)
  Data/           ApplicationDbContext, DbSeeder
  Helpers/        PasswordHasher, JwtTokenGenerator
  Migrations/      EF Core migration history
  schema.sql       Plain-SQL export of the current schema
```
