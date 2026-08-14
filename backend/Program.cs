using System.Reflection;
using System.Text;
using System.Text.Json.Serialization;
using backend.Data;
using backend.Helpers;
using backend.Swagger;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.EntityFrameworkCore;
using Microsoft.IdentityModel.Tokens;
using Microsoft.OpenApi.Models;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.
// Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen(options =>
{
    options.SwaggerDoc("v1", new OpenApiInfo
    {
        Title = "Employee Management System API",
        Version = "v1",
        Description = "REST API backing the Employee Management System's web and mobile clients, covering three modules: " +
            "employee & identity (employee/department records and JWT login with Admin/Manager/Employee roles), " +
            "attendance (self-service daily check-in/check-out and history), and " +
            "leave (leave requests and the Manager/Admin approval workflow)."
    });

    options.AddSecurityDefinition("Bearer", new OpenApiSecurityScheme
    {
        Type = SecuritySchemeType.Http,
        Scheme = "bearer",
        BearerFormat = "JWT",
        In = ParameterLocation.Header,
        Description = "JWT bearer token. Obtain one from POST /api/auth/login, then paste just the token here " +
            "(Swagger UI adds the 'Bearer ' prefix for you)."
    });
    options.OperationFilter<AuthorizeOperationFilter>();

    // Controller XML <summary> comments become the description shown above each
    // tag's operation group in Swagger UI (Auth, Employees, Departments, Attendance, LeaveRequests).
    var xmlFile = $"{Assembly.GetExecutingAssembly().GetName().Name}.xml";
    options.IncludeXmlComments(Path.Combine(AppContext.BaseDirectory, xmlFile), includeControllerXmlComments: true);
});

builder.Services.AddDbContext<ApplicationDbContext>(options =>
    options.UseNpgsql(builder.Configuration.GetConnectionString("DefaultConnection")));

// Serialize enums (Role, LeaveType, etc.) as their string names (e.g. "Employee"),
// not the default numeric value — readable in requests, responses, and Swagger.
builder.Services.AddControllers()
    .AddJsonOptions(options =>
        options.JsonSerializerOptions.Converters.Add(new JsonStringEnumConverter()));

// Turns any unhandled exception into the same RFC 9110 problem+json shape the API
// already returns for things like 404s, instead of a raw stack trace or a plain 500.
builder.Services.AddProblemDetails();

// Browsers block cross-origin requests by default (CORS is enforced client-side,
// which is why Postman/curl never hit this) — the React dev server runs on a
// different origin than this API, so it needs to be allow-listed explicitly.
// Not relevant to the mobile app: CORS is a browser-only restriction.
var allowedOrigins = builder.Configuration.GetSection("Cors:AllowedOrigins").Get<string[]>()
    ?? Array.Empty<string>();

builder.Services.AddCors(options =>
{
    options.AddPolicy("ReactApp", policy =>
        policy.WithOrigins(allowedOrigins)
            .AllowAnyHeader()
            .AllowAnyMethod());
});

builder.Services.AddSingleton<JwtTokenGenerator>();

builder.Services.AddAuthentication(JwtBearerDefaults.AuthenticationScheme)
    .AddJwtBearer(options =>
    {
        options.TokenValidationParameters = new TokenValidationParameters
        {
            ValidateIssuer = true,
            ValidateAudience = true,
            ValidateLifetime = true,
            ValidateIssuerSigningKey = true,
            ValidIssuer = builder.Configuration["Jwt:Issuer"],
            ValidAudience = builder.Configuration["Jwt:Audience"],
            IssuerSigningKey = new SymmetricSecurityKey(
                Encoding.UTF8.GetBytes(builder.Configuration["Jwt:Key"]!))
        };
    });

builder.Services.AddAuthorization();

var app = builder.Build();

// First in the pipeline, so it can catch exceptions thrown by anything after it.
app.UseExceptionHandler();

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseHttpsRedirection();

app.UseCors("ReactApp");

// Authentication must run before Authorization: it determines *who* the caller is
// (validates the JWT into a ClaimsPrincipal) before Authorization decides what they can do.
app.UseAuthentication();
app.UseAuthorization();

app.MapControllers();

using (var scope = app.Services.CreateScope())
{
    var db = scope.ServiceProvider.GetRequiredService<ApplicationDbContext>();
    await DbSeeder.SeedAsync(db);
}

app.Run();
