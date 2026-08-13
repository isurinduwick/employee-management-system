import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Initials bubble for a person, matching the web app's user chip.
class UserAvatar extends StatelessWidget {
  const UserAvatar({super.key, required this.fullName, this.radius = 16});

  final String fullName;
  final double radius;

  /// First + last initial, e.g. "Alex Manager" -> "AM".
  static String initialsOf(String fullName) {
    final parts = fullName.trim().split(RegExp(r'\s+'))
      ..removeWhere((part) => part.isEmpty);
    if (parts.isEmpty) return '?';

    final first = parts.first[0];
    final last = parts.length > 1 ? parts.last[0] : '';
    return (first + last).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: AppColors.accentSoft,
      child: Text(
        initialsOf(fullName),
        style: TextStyle(
          fontSize: radius * 0.75,
          fontWeight: FontWeight.w600,
          color: AppColors.accent,
        ),
      ),
    );
  }
}
