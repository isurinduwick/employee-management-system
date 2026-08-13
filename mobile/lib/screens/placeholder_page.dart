import 'package:flutter/material.dart';

import '../layout/nav_icons.dart';
import '../theme/app_colors.dart';

// Stands in for every nav route until each screen gets built on its own
// branch. Keeping one widget (rather than seven near-identical stubs) means
// there is only one thing to delete as the real screens land.
class PlaceholderPage extends StatelessWidget {
  final String title;
  final String path;

  const PlaceholderPage({super.key, required this.title, required this.path});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: AppColors.accentSoft,
                borderRadius: BorderRadius.circular(AppRadius.lg),
              ),
              child: Icon(navIconFor(path), size: 26, color: AppColors.accent),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.text,
                  ),
            ),
            const SizedBox(height: 6),
            Text(
              'This screen is coming next.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.textMuted),
            ),
          ],
        ),
      ),
    );
  }
}
