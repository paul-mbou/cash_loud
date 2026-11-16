import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'cash_loud_colors.dart';

abstract final class CashLoudTheme {
  static ThemeData light() => _build(Brightness.light, CashLoudColors.light);

  static ThemeData dark() => _build(Brightness.dark, CashLoudColors.dark);

  static ThemeData _build(Brightness brightness, CashLoudColors colors) {
    final isDark = brightness == Brightness.dark;

    final textTheme = TextTheme(
      displayLarge: GoogleFonts.sora(
        fontSize: 40,
        height: 1.08,
        fontWeight: FontWeight.w700,
        color: colors.textPrimary,
        letterSpacing: -1.0,
      ),
      displayMedium: GoogleFonts.sora(
        fontSize: 32,
        height: 1.12,
        fontWeight: FontWeight.w700,
        color: colors.textPrimary,
        letterSpacing: -0.6,
      ),
      titleLarge: GoogleFonts.sora(
        fontSize: 22,
        height: 1.25,
        fontWeight: FontWeight.w600,
        color: colors.textPrimary,
      ),
      titleMedium: GoogleFonts.sora(
        fontSize: 18,
        height: 1.3,
        fontWeight: FontWeight.w600,
        color: colors.textPrimary,
      ),
      bodyLarge: GoogleFonts.dmSans(
        fontSize: 16,
        height: 1.45,
        fontWeight: FontWeight.w500,
        color: colors.textPrimary,
      ),
      bodyMedium: GoogleFonts.dmSans(
        fontSize: 14,
        height: 1.4,
        fontWeight: FontWeight.w400,
        color: colors.textSecondary,
      ),
      bodySmall: GoogleFonts.dmSans(
        fontSize: 12,
        height: 1.35,
        fontWeight: FontWeight.w500,
        color: colors.textSecondary,
      ),
      labelLarge: GoogleFonts.dmSans(
        fontSize: 14,
        height: 1.3,
        fontWeight: FontWeight.w600,
        color: colors.textPrimary,
      ),
      labelSmall: GoogleFonts.ibmPlexMono(
        fontSize: 12,
        height: 1.35,
        fontWeight: FontWeight.w500,
        color: colors.textSecondary,
      ),
    );

    final scheme = ColorScheme(
      brightness: brightness,
      primary: colors.primary,
      onPrimary: colors.textInverse,
      primaryContainer: colors.primaryMuted,
      onPrimaryContainer: colors.textPrimary,
      secondary: colors.accent,
      onSecondary: isDark ? colors.textInverse : const Color(0xFF0C1F1A),
      secondaryContainer: colors.accentMuted,
      onSecondaryContainer: colors.textPrimary,
      tertiary: colors.voice,
      onTertiary: const Color(0xFFFFFFFF),
      tertiaryContainer: colors.voiceMuted,
      onTertiaryContainer: colors.textPrimary,
      error: colors.danger,
      onError: colors.textInverse,
      surface: colors.surface,
      onSurface: colors.textPrimary,
      onSurfaceVariant: colors.textSecondary,
      outline: colors.border,
      outlineVariant: colors.border.withValues(alpha: 0.65),
      shadow: const Color(0xFF0C1F1A),
      scrim: colors.overlay,
      inverseSurface: isDark ? colors.surfaceElevated : colors.primary,
      onInverseSurface: colors.textInverse,
      surfaceContainerHighest: colors.surfaceElevated,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      scaffoldBackgroundColor: colors.bg,
      canvasColor: colors.bg,
      extensions: [colors],
      textTheme: textTheme,
      primaryTextTheme: textTheme,
      iconTheme: IconThemeData(size: 24, color: colors.textPrimary),
      appBarTheme: AppBarTheme(
        backgroundColor: colors.bg,
        foregroundColor: colors.textPrimary,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: textTheme.titleLarge,
      ),
      dividerTheme: DividerThemeData(
        color: colors.border,
        thickness: 1,
        space: 1,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: colors.surfaceElevated,
        indicatorColor: colors.primaryMuted,
        elevation: 0,
        height: 72,
        overlayColor: WidgetStateProperty.all(Colors.transparent),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return GoogleFonts.dmSans(
            fontSize: 12,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
            color: selected ? colors.primary : colors.textSecondary,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return IconThemeData(
            size: 24,
            color: selected ? colors.primary : colors.textSecondary,
          );
        }),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(40, 44),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 11),
          elevation: 0,
          shadowColor: Colors.transparent,
          backgroundColor: colors.primary,
          foregroundColor: colors.textInverse,
          disabledBackgroundColor: colors.primaryMuted,
          disabledForegroundColor: colors.textSecondary,
          textStyle: GoogleFonts.dmSans(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.1,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(40, 44),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 11),
          elevation: 0,
          foregroundColor: colors.textPrimary,
          backgroundColor: colors.surfaceElevated,
          side: BorderSide(color: colors.border.withValues(alpha: 0.9)),
          textStyle: GoogleFonts.dmSans(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.1,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          minimumSize: const Size(36, 36),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          foregroundColor: colors.primary,
          textStyle: GoogleFonts.dmSans(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.1,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: colors.surfaceElevated,
        modalBarrierColor: colors.overlay,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
        ),
        showDragHandle: false,
      ),
      inputDecorationTheme: InputDecorationTheme(
        isDense: true,
        filled: true,
        fillColor: colors.surfaceElevated,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 12,
        ),
        prefixIconConstraints: const BoxConstraints(
          minWidth: 40,
          minHeight: 40,
        ),
        suffixIconConstraints: const BoxConstraints(
          minWidth: 40,
          minHeight: 40,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: colors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: colors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: colors.focusRing, width: 1.4),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: colors.danger.withValues(alpha: 0.7)),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: colors.danger, width: 1.4),
        ),
        labelStyle: textTheme.bodyMedium,
        floatingLabelStyle: textTheme.bodySmall?.copyWith(
          color: colors.textSecondary,
          fontWeight: FontWeight.w600,
        ),
        hintStyle: textTheme.bodyMedium?.copyWith(
          color: colors.textSecondary.withValues(alpha: 0.85),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: Colors.transparent,
        contentTextStyle: textTheme.bodyLarge,
        behavior: SnackBarBehavior.floating,
        elevation: 0,
      ),
    );
  }
}
