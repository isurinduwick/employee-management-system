import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../utils/date_format.dart';

/// Tappable field that opens the platform date picker, styled to match
/// [AppTextField] so a form mixing text and dates still reads as one column.
class AppDateField extends StatelessWidget {
  const AppDateField({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    this.firstDate,
    this.lastDate,
    this.enabled = true,
    this.errorText,
  });

  final String label;
  final DateTime? value;
  final ValueChanged<DateTime> onChanged;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final bool enabled;
  final String? errorText;

  Future<void> _pick(BuildContext context) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: value ?? now,
      firstDate: firstDate ?? DateTime(now.year - 5),
      lastDate: lastDate ?? DateTime(now.year + 5),
    );
    if (picked != null) onChanged(picked);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: enabled ? () => _pick(context) : null,
      borderRadius: BorderRadius.circular(AppRadius.sm),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          errorText: errorText,
          suffixIcon: const Icon(
            Icons.calendar_today_outlined,
            size: 18,
            color: AppColors.textSubtle,
          ),
        ),
        child: Text(
          value == null ? 'Select a date' : DateFormatting.date(value!),
          style: TextStyle(
            fontSize: 14.5,
            color: value == null ? AppColors.textSubtle : AppColors.text,
          ),
        ),
      ),
    );
  }
}
