import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Themed form field. Wraps [TextFormField] so every screen gets the same
/// label/hint/validation treatment and the counter stays hidden while
/// `maxLength` still enforces the backend's limits.
class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    required this.label,
    this.controller,
    this.hint,
    this.keyboardType,
    this.textInputAction,
    this.autofillHints,
    this.maxLength,
    this.maxLines = 1,
    this.enabled = true,
    this.obscureText = false,
    this.prefixIcon,
    this.suffixIcon,
    this.validator,
    this.onSubmitted,
  });

  final String label;
  final TextEditingController? controller;
  final String? hint;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final Iterable<String>? autofillHints;
  final int? maxLength;

  /// Above 1 the field grows into a text area — used for free-text notes such
  /// as a leave request's reason.
  final int maxLines;
  final bool enabled;
  final bool obscureText;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onSubmitted;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      autofillHints: autofillHints,
      maxLength: maxLength,
      maxLines: maxLines,
      enabled: enabled,
      obscureText: obscureText,
      validator: validator,
      onFieldSubmitted: onSubmitted,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        // The theme's border already communicates the limit; the counter just
        // adds noise under the field.
        counterText: '',
        prefixIcon: prefixIcon == null
            ? null
            : Icon(prefixIcon, size: 19, color: AppColors.textSubtle),
        suffixIcon: suffixIcon,
      ),
    );
  }
}

/// Password field with the show/hide toggle wired up.
class AppPasswordField extends StatefulWidget {
  const AppPasswordField({
    super.key,
    required this.label,
    this.controller,
    this.hint,
    this.maxLength,
    this.enabled = true,
    this.textInputAction,
    this.validator,
    this.onSubmitted,
  });

  final String label;
  final TextEditingController? controller;
  final String? hint;
  final int? maxLength;
  final bool enabled;
  final TextInputAction? textInputAction;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onSubmitted;

  @override
  State<AppPasswordField> createState() => _AppPasswordFieldState();
}

class _AppPasswordFieldState extends State<AppPasswordField> {
  bool _visible = false;

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      label: widget.label,
      controller: widget.controller,
      hint: widget.hint,
      maxLength: widget.maxLength,
      enabled: widget.enabled,
      textInputAction: widget.textInputAction,
      obscureText: !_visible,
      autofillHints: const [AutofillHints.password],
      validator: widget.validator,
      onSubmitted: widget.onSubmitted,
      suffixIcon: IconButton(
        icon: Icon(
          _visible ? Icons.visibility_off_outlined : Icons.visibility_outlined,
        ),
        tooltip: _visible ? 'Hide password' : 'Show password',
        color: AppColors.textSubtle,
        onPressed: () => setState(() => _visible = !_visible),
      ),
    );
  }
}
