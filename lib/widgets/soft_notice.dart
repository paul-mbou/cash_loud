import 'dart:async';

import 'package:flutter/material.dart';

import '../theme/cash_loud_colors.dart';

/// Semantic notice types for snackbars, badges, and inline alerts.
enum SoftNoticeKind { success, warning, danger, info, voice }

@immutable
class SoftNoticeColors {
  const SoftNoticeColors({
    required this.background,
    required this.border,
    required this.foreground,
    required this.icon,
  });

  final Color background;
  final Color border;
  final Color foreground;
  final Color icon;

  static SoftNoticeColors of(CashLoudColors colors, SoftNoticeKind kind) {
    final Color tone = switch (kind) {
      SoftNoticeKind.success => colors.success,
      SoftNoticeKind.warning => colors.warning,
      SoftNoticeKind.danger => colors.danger,
      SoftNoticeKind.info => colors.primary,
      SoftNoticeKind.voice => colors.voice,
    };

    // Voice / danger: muted wash so card backgrounds stay soft, not vivid.
    final isRedFamily =
        kind == SoftNoticeKind.voice || kind == SoftNoticeKind.danger;
    final Color background = kind == SoftNoticeKind.voice
        ? colors.voiceMuted
        : Color.alphaBlend(
            tone.withValues(alpha: isRedFamily ? 0.08 : 0.12),
            colors.surfaceElevated,
          );

    return SoftNoticeColors(
      background: background,
      border: tone.withValues(alpha: isRedFamily ? 0.28 : 0.45),
      foreground: Color.alphaBlend(
        tone.withValues(alpha: isRedFamily ? 0.55 : 0.68),
        colors.textPrimary,
      ),
      icon: Color.alphaBlend(
        tone.withValues(alpha: isRedFamily ? 0.82 : 1),
        colors.textPrimary,
      ),
    );
  }
}

/// Soft typed notice surface — snackbars, chips, inline banners.
class SoftNoticeSurface extends StatelessWidget {
  const SoftNoticeSurface({
    super.key,
    required this.kind,
    required this.child,
    this.padding = const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
    this.borderRadius = 16,
    this.borderWidth = 1.4,
  });

  final SoftNoticeKind kind;
  final Widget child;
  final EdgeInsetsGeometry padding;
  final double borderRadius;
  final double borderWidth;

  @override
  Widget build(BuildContext context) {
    final palette = SoftNoticeColors.of(context.colors, kind);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: palette.background,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(color: palette.border, width: borderWidth),
        boxShadow: isDark
            ? null
            : [
                BoxShadow(
                  color: palette.icon.withValues(
                    alpha:
                        kind == SoftNoticeKind.voice ||
                            kind == SoftNoticeKind.danger
                        ? 0.04
                        : 0.08,
                  ),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
      ),
      child: Padding(padding: padding, child: child),
    );
  }
}

OverlayEntry? _activeSoftNotice;

/// Top floating typed notice — soft slide-in from above for all user toasts.
void showSoftNotice(
  BuildContext context, {
  required String message,
  SoftNoticeKind kind = SoftNoticeKind.info,
  Duration duration = const Duration(seconds: 3),
  IconData? icon,
}) {
  final overlay = Overlay.maybeOf(context);
  if (overlay == null) return;

  hideSoftNotice();

  late final OverlayEntry entry;
  entry = OverlayEntry(
    builder: (context) {
      return _SoftTopNoticeHost(
        message: message,
        kind: kind,
        icon: icon,
        duration: duration,
        onRequestClose: () {
          if (_activeSoftNotice == entry) {
            hideSoftNotice();
          }
        },
      );
    },
  );

  _activeSoftNotice = entry;
  overlay.insert(entry);
}

/// Dismiss the current top soft notice, if any.
void hideSoftNotice() {
  final entry = _activeSoftNotice;
  _activeSoftNotice = null;
  entry?.remove();
}

class _SoftTopNoticeHost extends StatefulWidget {
  const _SoftTopNoticeHost({
    required this.message,
    required this.kind,
    required this.duration,
    required this.onRequestClose,
    this.icon,
  });

  final String message;
  final SoftNoticeKind kind;
  final Duration duration;
  final VoidCallback onRequestClose;
  final IconData? icon;

  @override
  State<_SoftTopNoticeHost> createState() => _SoftTopNoticeHostState();
}

class _SoftTopNoticeHostState extends State<_SoftTopNoticeHost>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;
  Timer? _hold;

  static const _enter = Duration(milliseconds: 280);
  static const _exit = Duration(milliseconds: 220);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: _enter);
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic);
    _slide = Tween<Offset>(
      begin: const Offset(0, -0.35),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    final reduce = WidgetsBinding
        .instance
        .platformDispatcher
        .accessibilityFeatures
        .disableAnimations;
    if (reduce) {
      _controller.value = 1;
      _scheduleHold();
    } else {
      _controller.forward().whenComplete(_scheduleHold);
    }
  }

  void _scheduleHold() {
    _hold?.cancel();
    _hold = Timer(widget.duration, _dismiss);
  }

  Future<void> _dismiss() async {
    if (!mounted) return;
    final reduce = MediaQuery.disableAnimationsOf(context);
    if (reduce) {
      widget.onRequestClose();
      return;
    }
    _controller.duration = _exit;
    await _controller.reverse();
    if (mounted) widget.onRequestClose();
  }

  @override
  void dispose() {
    _hold?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final palette = SoftNoticeColors.of(context.colors, widget.kind);
    final theme = Theme.of(context);

    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Material(
        type: MaterialType.transparency,
        child: SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: SlideTransition(
              position: _slide,
              child: FadeTransition(
                opacity: _fade,
                child: GestureDetector(
                  onTap: _dismiss,
                  child: SoftNoticeSurface(
                    kind: widget.kind,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 12,
                    ),
                    child: Row(
                      children: [
                        if (widget.icon != null) ...[
                          Icon(widget.icon, size: 18, color: palette.icon),
                          const SizedBox(width: 10),
                        ],
                        Expanded(
                          child: Text(
                            widget.message,
                            style: theme.textTheme.bodyLarge?.copyWith(
                              color: palette.foreground,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
