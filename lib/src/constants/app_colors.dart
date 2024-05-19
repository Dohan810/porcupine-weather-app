import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  // Define text styles for mobile, tablet, and web with different sizes
  static final textStyleWithShadowMobile = GoogleFonts.lora(
    textStyle: const TextStyle(
      color: Colors.white,
      fontSize: 24,
      shadows: [
        BoxShadow(
          color: Colors.black12,
          spreadRadius: 1,
          blurRadius: 4,
          offset: Offset(0, 0.5),
        ),
      ],
    ),
  );

  static final textStyleWithShadowTablet = GoogleFonts.lora(
    textStyle: const TextStyle(
      color: Colors.white,
      fontSize: 28,
      shadows: [
        BoxShadow(
          color: Colors.black12,
          spreadRadius: 2,
          blurRadius: 8,
          offset: Offset(0, 1),
        ),
      ],
    ),
  );

  static final textStyleWithShadowWeb = GoogleFonts.lora(
    textStyle: const TextStyle(
      color: Colors.white,
      fontSize: 32,
      shadows: [
        BoxShadow(
          color: Colors.black12,
          spreadRadius: 3,
          blurRadius: 12,
          offset: Offset(0, 2),
        ),
      ],
    ),
  );

  static TextTheme getTextTheme(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width >= 1200) {
      // Web
      return TextTheme(
        displayLarge: textStyleWithShadowWeb.copyWith(fontSize: 72),
        displayMedium: textStyleWithShadowWeb.copyWith(fontSize: 60),
        displaySmall: textStyleWithShadowWeb.copyWith(fontSize: 48),
        headlineMedium: textStyleWithShadowWeb.copyWith(fontSize: 34),
        headlineSmall: textStyleWithShadowWeb.copyWith(fontSize: 28),
        titleLarge: textStyleWithShadowWeb.copyWith(fontSize: 24),
        titleMedium: const TextStyle(color: Colors.white, fontSize: 20),
        bodyLarge: const TextStyle(color: Colors.white, fontSize: 18),
        bodyMedium: const TextStyle(color: Colors.white, fontSize: 16),
        bodySmall: const TextStyle(color: Colors.white70, fontSize: 14),
      );
    } else if (width >= 768) {
      // Tablet
      return TextTheme(
        displayLarge: textStyleWithShadowTablet.copyWith(fontSize: 72),
        displayMedium: textStyleWithShadowTablet.copyWith(fontSize: 48),
        displaySmall: textStyleWithShadowTablet.copyWith(fontSize: 34),
        headlineMedium: textStyleWithShadowTablet.copyWith(fontSize: 24),
        headlineSmall: textStyleWithShadowTablet.copyWith(fontSize: 20),
        titleLarge: textStyleWithShadowTablet.copyWith(fontSize: 18),
        titleMedium: const TextStyle(color: Colors.white, fontSize: 18),
        bodyLarge: const TextStyle(color: Colors.white, fontSize: 16),
        bodyMedium: const TextStyle(color: Colors.white, fontSize: 14),
        bodySmall: const TextStyle(color: Colors.white70, fontSize: 12),
      );
    } else {
      // Mobile
      return TextTheme(
        displayLarge: textStyleWithShadowTablet.copyWith(fontSize: 72),
        displayMedium: textStyleWithShadowMobile.copyWith(fontSize: 26),
        displaySmall: textStyleWithShadowMobile.copyWith(fontSize: 22),
        headlineMedium: textStyleWithShadowMobile.copyWith(fontSize: 20),
        headlineSmall: textStyleWithShadowMobile.copyWith(fontSize: 18),
        titleLarge: textStyleWithShadowMobile.copyWith(fontSize: 16),
        titleMedium: const TextStyle(color: Colors.white, fontSize: 16),
        bodyLarge: const TextStyle(color: Colors.white, fontSize: 14),
        bodyMedium: const TextStyle(color: Colors.white, fontSize: 12),
        bodySmall: const TextStyle(color: Colors.white70, fontSize: 10),
      );
    }
  }
}
