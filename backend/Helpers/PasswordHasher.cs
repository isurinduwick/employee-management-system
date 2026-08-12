namespace backend.Helpers;

/// <summary>
/// Wraps BCrypt so hashing/verification logic (and its work factor) lives in one place,
/// used both when seeding default accounts and when verifying a login attempt.
/// </summary>
public static class PasswordHasher
{
    private const int WorkFactor = 11;

    public static string HashPassword(string password) =>
        BCrypt.Net.BCrypt.HashPassword(password, workFactor: WorkFactor);

    public static bool Verify(string password, string hash) =>
        BCrypt.Net.BCrypt.Verify(password, hash);
}
