/// Form validators shared by every screen, so the same rule reads the same
/// way to the user wherever it is enforced.
///
/// Each returns null when the value is acceptable — the shape [TextFormField]
/// expects — and they compose with [Validators.all].
class Validators {
  const Validators._();

  static final _emailPattern = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');

  /// Runs validators in order and reports the first complaint.
  static String? Function(String?) all(
    List<String? Function(String?)> validators,
  ) {
    return (value) {
      for (final validate in validators) {
        final message = validate(value);
        if (message != null) return message;
      }
      return null;
    };
  }

  static String? Function(String?) notEmpty(String label) {
    return (value) =>
        (value == null || value.trim().isEmpty) ? '$label is required.' : null;
  }

  static String? Function(String?) email({String label = 'Email'}) {
    return (value) {
      final email = value?.trim() ?? '';
      if (email.isEmpty) return null;
      return _emailPattern.hasMatch(email)
          ? null
          : 'Enter a valid email address.';
    };
  }

  static String? Function(String?) lengthBetween(
    String label,
    int min,
    int max,
  ) {
    return (value) {
      final length = (value ?? '').trim().length;
      if (length == 0) return null;
      return (length < min || length > max)
          ? '$label must be $min-$max characters.'
          : null;
    };
  }
}
