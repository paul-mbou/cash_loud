import 'package:flutter/material.dart';

/// Semantic color roles from design-system/MASTER.md (Stall Board · voice-soft).
@immutable
class CashLoudColors extends ThemeExtension<CashLoudColors> {
  const CashLoudColors({
    required this.bg,
    required this.bgGlow,
    required this.surface,
    required this.surfaceElevated,
    required this.textPrimary,
    required this.textSecondary,
    required this.textInverse,
    required this.border,
    required this.primary,
    required this.primaryMuted,
    required this.accent,
    required this.accentMuted,
    required this.voice,
    required this.voiceMuted,
    required this.dock,
    required this.dockIcon,
    required this.success,
    required this.warning,
    required this.danger,
    required this.focusRing,
    required this.overlay,
    required this.skeleton,
    required this.offline,
    required this.online,
    required this.boardRing,
  });

  final Color bg;
  final Color bgGlow;
  final Color surface;
  final Color surfaceElevated;
  final Color textPrimary;
  final Color textSecondary;
  final Color textInverse;
  final Color border;
  final Color primary;
  final Color primaryMuted;
  final Color accent;
  final Color accentMuted;
  final Color voice;
  final Color voiceMuted;
  final Color dock;
  final Color dockIcon;
  final Color success;
  final Color warning;
  final Color danger;
  final Color focusRing;
  final Color overlay;
  final Color skeleton;
  final Color offline;
  final Color online;
  final Color boardRing;

  static const light = CashLoudColors(
    bg: Color(0xFFF5FAF7),
    bgGlow: Color(0xFFFCFDFC),
    surface: Color(0xFFF0F7F3),
    surfaceElevated: Color(0xFFFFFFFF),
    textPrimary: Color(0xFF243832),
    textSecondary: Color(0xFF7A9088),
    textInverse: Color(0xFFFFFFFF),
    border: Color(0xFFE4EEE9),
    primary: Color(0xFF2F7A64),
    primaryMuted: Color(0xFFE4F2EC),
    accent: Color(0xFFC47A2E),
    accentMuted: Color(0xFFF9F0E0),
    voice: Color(0xFFC97B82),
    voiceMuted: Color(0xFFF3EBEC),
    dock: Color(0xFFFFFFFF),
    dockIcon: Color(0xFF8AA399),
    success: Color(0xFF3B9A6A),
    warning: Color(0xFFC4892A),
    danger: Color(0xFFC56B64),
    focusRing: Color(0xFF2F7A64),
    overlay: Color(0x590C1F1A),
    skeleton: Color(0xFFE6F0EB),
    offline: Color(0xFF7A9088),
    online: Color(0xFF3B9A6A),
    boardRing: Color(0x282F7A64),
  );

  static const dark = CashLoudColors(
    bg: Color(0xFF101C19),
    bgGlow: Color(0xFF162420),
    surface: Color(0xFF152420),
    surfaceElevated: Color(0xFF1C2E28),
    textPrimary: Color(0xFFE8F3EE),
    textSecondary: Color(0xFF9BB0A6),
    textInverse: Color(0xFF101C19),
    border: Color(0xFF2E4039),
    primary: Color(0xFF4EC49A),
    primaryMuted: Color(0xFF1A332C),
    accent: Color(0xFFE0B05A),
    accentMuted: Color(0xFF3A3014),
    voice: Color(0xFFE08A90),
    voiceMuted: Color(0xFF2A2224),
    dock: Color(0xFF1C2E28),
    dockIcon: Color(0xFF9BB0A6),
    success: Color(0xFF56D49A),
    warning: Color(0xFFF0C05A),
    danger: Color(0xFFE08A84),
    focusRing: Color(0xFFE0B05A),
    overlay: Color(0x8F000000),
    skeleton: Color(0xFF22332E),
    offline: Color(0xFF9BB0A6),
    online: Color(0xFF56D49A),
    boardRing: Color(0x334EC49A),
  );

  @override
  CashLoudColors copyWith({
    Color? bg,
    Color? bgGlow,
    Color? surface,
    Color? surfaceElevated,
    Color? textPrimary,
    Color? textSecondary,
    Color? textInverse,
    Color? border,
    Color? primary,
    Color? primaryMuted,
    Color? accent,
    Color? accentMuted,
    Color? voice,
    Color? voiceMuted,
    Color? dock,
    Color? dockIcon,
    Color? success,
    Color? warning,
    Color? danger,
    Color? focusRing,
    Color? overlay,
    Color? skeleton,
    Color? offline,
    Color? online,
    Color? boardRing,
  }) {
    return CashLoudColors(
      bg: bg ?? this.bg,
      bgGlow: bgGlow ?? this.bgGlow,
      surface: surface ?? this.surface,
      surfaceElevated: surfaceElevated ?? this.surfaceElevated,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textInverse: textInverse ?? this.textInverse,
      border: border ?? this.border,
      primary: primary ?? this.primary,
      primaryMuted: primaryMuted ?? this.primaryMuted,
      accent: accent ?? this.accent,
      accentMuted: accentMuted ?? this.accentMuted,
      voice: voice ?? this.voice,
      voiceMuted: voiceMuted ?? this.voiceMuted,
      dock: dock ?? this.dock,
      dockIcon: dockIcon ?? this.dockIcon,
      success: success ?? this.success,
      warning: warning ?? this.warning,
      danger: danger ?? this.danger,
      focusRing: focusRing ?? this.focusRing,
      overlay: overlay ?? this.overlay,
      skeleton: skeleton ?? this.skeleton,
      offline: offline ?? this.offline,
      online: online ?? this.online,
      boardRing: boardRing ?? this.boardRing,
    );
  }

  @override
  CashLoudColors lerp(ThemeExtension<CashLoudColors>? other, double t) {
    if (other is! CashLoudColors) return this;
    return CashLoudColors(
      bg: Color.lerp(bg, other.bg, t)!,
      bgGlow: Color.lerp(bgGlow, other.bgGlow, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      surfaceElevated: Color.lerp(surfaceElevated, other.surfaceElevated, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      textInverse: Color.lerp(textInverse, other.textInverse, t)!,
      border: Color.lerp(border, other.border, t)!,
      primary: Color.lerp(primary, other.primary, t)!,
      primaryMuted: Color.lerp(primaryMuted, other.primaryMuted, t)!,
      accent: Color.lerp(accent, other.accent, t)!,
      accentMuted: Color.lerp(accentMuted, other.accentMuted, t)!,
      voice: Color.lerp(voice, other.voice, t)!,
      voiceMuted: Color.lerp(voiceMuted, other.voiceMuted, t)!,
      dock: Color.lerp(dock, other.dock, t)!,
      dockIcon: Color.lerp(dockIcon, other.dockIcon, t)!,
      success: Color.lerp(success, other.success, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      danger: Color.lerp(danger, other.danger, t)!,
      focusRing: Color.lerp(focusRing, other.focusRing, t)!,
      overlay: Color.lerp(overlay, other.overlay, t)!,
      skeleton: Color.lerp(skeleton, other.skeleton, t)!,
      offline: Color.lerp(offline, other.offline, t)!,
      online: Color.lerp(online, other.online, t)!,
      boardRing: Color.lerp(boardRing, other.boardRing, t)!,
    );
  }
}

extension CashLoudColorsX on BuildContext {
  CashLoudColors get colors => Theme.of(this).extension<CashLoudColors>()!;
}
