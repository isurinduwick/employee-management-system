import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// The gradient app mark, used by the splash, the login card and the drawer
/// header. One widget so the three never drift apart.
class BrandMark extends StatelessWidget {
  const BrandMark({super.key, this.size = 40, this.glow = false});

  final double size;

  /// Adds the accent-coloured drop shadow used on the marketing-ish surfaces
  /// (splash + login), which the compact drawer version omits.
  final bool glow;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.md),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.accent, AppColors.accentDeep],
        ),
        boxShadow: glow
            ? [
                BoxShadow(
                  color: AppColors.accent.withValues(alpha: 0.35),
                  blurRadius: size * 0.5,
                  offset: Offset(0, size * 0.2),
                ),
              ]
            : null,
      ),
      child: Icon(
        Icons.business_center_rounded,
        size: size * 0.5,
        color: AppColors.accentContrast,
      ),
    );
  }
}
