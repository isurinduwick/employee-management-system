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

1. **Configure the database connection**

   Edit `appsettings.json` (or `appsettings.Development.json`) and set your own PostgreSQL credentials:

   ```json
   "ConnectionStrings": {
     "DefaultConnection": "Host=localhost;Port=5432;Database=ems_db;Username=postgres;Password=your-password"
   }
   ```

2. **Set a JWT signing key**

   Replace the placeholder `Jwt:Key` in `appsettings.json` with your own random secret (32+ characters). Never commit a real production secret — for local development the checked-in value is fine to reuse or replace.

3. **Restore and apply the database migrations**

   ```bash
   dotnet restore
   dotnet ef database update
   ```

   This creates all four tables (`Departments`, `Employees`, `AttendanceLogs`, `LeaveRequests`) in the configured database. A plain-SQL equivalent is also checked in at [`schema.sql`](./schema.sql) if you'd rather apply it directly instead of using EF migrations.

4. **Run the API**

   ```bash
   dotnet run
   ```

   On first run, the app automatically seeds three default accounts (see below) if the `Employees` table is empty — no manual seeding step required.

   The API listens at `http://localhost:5133` by default (see `Properties/launchSettings.json`), and opens Swagger UI at `http://localhost:5133/swagger`.

## Configuration keys

All configuration lives in `appsettings.json` (and `appsettings.Development.json` for environment overrides):

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

Full interactive documentation is available via Swagger UI at `/swagger` once the app is running. Summary:

| Resource | Endpoints |
|---|---|
| Auth | `POST /api/auth/login` |
| Departments | `GET`, `GET /{id}`, `POST`, `PUT /{id}`, `DELETE /{id}` — writes require `Admin` |
| Employees | `GET`, `GET /{id}`, `POST`, `PUT /{id}`, `DELETE /{id}` — writes require `Admin` |
| Attendance | `POST /check-in`, `POST /check-out`, `GET` (filter by `employeeId`, `departmentId`, `startDate`, `endDate`) |
| Leave requests | `POST`, `GET` (filter by `employeeId`, `status`), `PUT /{id}/decision` — decision requires `Manager` or `Admin` |

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
