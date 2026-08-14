using Microsoft.AspNetCore.Authorization;
using Microsoft.OpenApi.Models;
using Swashbuckle.AspNetCore.SwaggerGen;

namespace backend.Swagger;

/// <summary>
/// Adds the Bearer security requirement to an operation only when the action (or its
/// controller) actually carries [Authorize] and isn't opted out with [AllowAnonymous] —
/// so anonymous endpoints like login don't show a misleading padlock in Swagger UI.
/// </summary>
public class AuthorizeOperationFilter : IOperationFilter
{
    public void Apply(OpenApiOperation operation, OperationFilterContext context)
    {
        var hasAllowAnonymous = context.MethodInfo
            .GetCustomAttributes(true)
            .OfType<AllowAnonymousAttribute>()
            .Any();

        if (hasAllowAnonymous)
        {
            return;
        }

        var requiresAuth = context.MethodInfo.GetCustomAttributes(true).OfType<AuthorizeAttribute>().Any()
            || (context.MethodInfo.DeclaringType?.GetCustomAttributes(true).OfType<AuthorizeAttribute>().Any() ?? false);

        if (!requiresAuth)
        {
            return;
        }

        var bearerScheme = new OpenApiSecurityScheme
        {
            Reference = new OpenApiReference { Type = ReferenceType.SecurityScheme, Id = "Bearer" }
        };

        operation.Security.Add(new OpenApiSecurityRequirement
        {
            [bearerScheme] = Array.Empty<string>()
        });
    }
}
