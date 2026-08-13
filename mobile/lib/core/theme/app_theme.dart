import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

/// The brand theme, derived from the web app's tokens.
///
/// Shared widgets read their colours from here (or from [AppColors]) rather
/// than hard-coding values, so a token change lands everywhere at once.
class AppTheme {
  const AppTheme._();

  static ThemeData light() {
    final colorScheme =
        ColorScheme.fromSeed(
          seedColor: AppColors.accent,
          brightness: Brightness.light,
        ).copyWith(
          primary: AppColors.accent,
          onPrimary: AppColors.accentContrast,
          secondaryContainer: AppColors.accentSoft,
          surface: AppColors.surface,
          error: AppColors.danger,
          outline: AppColors.borderStrong,
          outlineVariant: AppColors.border,
        );

    final textTheme = GoogleFonts.interTextTheme().apply(
      bodyColor: AppColors.text,
      displayColor: AppColors.text,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.bg,
      fontFamily: GoogleFonts.inter().fontFamily,
      textTheme: textTheme,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.text,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        shape: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      drawerTheme: const DrawerThemeData(
        backgroundColor: AppColors.surface,
        surfaceTintColor: Colors.transparent,
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.border,
        thickness: 1,
        space: 1,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface,
        labelStyle: const TextStyle(color: AppColors.textMuted),
        hintStyle: const TextStyle(color: AppColors.textSubtle),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 13,
          vertical: 14,
        ),
        border: _fieldBorder(AppColors.borderStrong),
        enabledBorder: _fieldBorder(AppColors.borderStrong),
        focusedBorder: _fieldBorder(AppColors.accent, width: 1.6),
        errorBorder: _fieldBorder(AppColors.danger),
        focusedErrorBorder: _fieldBorder(AppColors.danger, width: 1.6),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.accent,
          foregroundColor: AppColors.accentContrast,
          disabledBackgroundColor: AppColors.accent.withValues(alpha: 0.65),
          disabledForegroundColor: AppColors.accentContrast,
          minimumSize: const Size.fromHeight(44),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.sm),
          ),
          textStyle: GoogleFonts.inter(
            fontSize: 14.5,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.text,
          side: const BorderSide(color: AppColors.borderStrong),
          minimumSize: const Size.fromHeight(44),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.sm),
          ),
          textStyle: GoogleFonts.inter(
            fontSize: 14.5,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.accent,
          textStyle: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.text,
        contentTextStyle: GoogleFonts.inter(
          fontSize: 13.5,
          color: AppColors.accentContrast,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.accent,
      ),
    );
  }

  static OutlineInputBorder _fieldBorder(Color color, {double width = 1}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppRadius.sm),
      borderSide: BorderSide(color: color, width: width),
    );
  }
}
