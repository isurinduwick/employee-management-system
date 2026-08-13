import 'package:flutter/material.dart';

// Mirrors frontend/src/index.css's :root design tokens (light values only —
// the web app also has a dark palette via light-dark(), which mobile doesn't
// implement yet).
class AppColors {
  static const accent = Color(0xFF0F6B56);
  static const accentHover = Color(0xFF0A5443);
  static const accentContrast = Color(0xFFFFFFFF);
  static const accentSoft = Color(0xFFE7F2EE);

  static const bg = Color(0xFFF4F6F8);
  static const surface = Color(0xFFFFFFFF);
  static const surface2 = Color(0xFFF4F6F8);
  static const surface3 = Color(0xFFEAEEF2);
  static const border = Color(0xFFE4E8ED);
  static const borderStrong = Color(0xFFD1D8E0);
  static const text = Color(0xFF0F1720);
  static const textMuted = Color(0xFF5A6673);
  static const textSubtle = Color(0xFF8B96A3);

  static const success = Color(0xFF0F6F47);
  static const successSoft = Color(0xFFE4F4EC);
  static const warning = Color(0xFF8A5A08);
  static const warningSoft = Color(0xFFFBF1DE);
  static const danger = Color(0xFFB3261E);
  static const dangerSoft = Color(0xFFFDECEA);
  static const info = Color(0xFF1A5FB4);
  static const infoSoft = Color(0xFFE9F1FD);
}

// --radius-* tokens.
class AppRadius {
  static const xs = 6.0;
  static const sm = 8.0;
  static const md = 11.0;
  static const lg = 14.0;
  static const xl = 20.0;
  static const pill = 999.0;
}
