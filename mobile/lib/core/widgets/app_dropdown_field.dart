import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Themed picker that matches [AppTextField]'s metrics, so a form mixing text
/// and selects still reads as one column.
class AppDropdownField<T> extends StatelessWidget {
  const AppDropdownField({
    super.key,
    required this.label,
    required this.items,
    required this.itemLabel,
    this.value,
    this.hint,
    this.enabled = true,
    this.onChanged,
    this.validator,
  });

  final String label;
  final List<T> items;

  /// How each option renders — keeps the widget free of entity knowledge.
  final String Function(T item) itemLabel;
  final T? value;
  final String? hint;
  final bool enabled;
  final ValueChanged<T?>? onChanged;
  final String? Function(T?)? validator;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      // A value no longer in items (a deactivated manager, say) would assert;
      // falling back to null shows the hint instead of crashing the form.
      initialValue: items.contains(value) ? value : null,
      isExpanded: true,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        counterText: '',
      ),
      icon: const Icon(Icons.expand_more, color: AppColors.textSubtle),
      borderRadius: BorderRadius.circular(AppRadius.md),
      onChanged: enabled ? onChanged : null,
      validator: validator,
      items: [
        for (final item in items)
          DropdownMenuItem<T>(
            value: item,
            child: Text(itemLabel(item), overflow: TextOverflow.ellipsis),
          ),
      ],
    );
  }
}
