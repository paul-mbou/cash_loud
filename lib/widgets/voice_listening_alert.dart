import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../theme/cash_loud_colors.dart';
import 'soft_notice.dart';

/// Styled listening alert with soft speak animation.
/// Dismiss only via the voice mic FAB — overlay and card are not tappable exits.
class VoiceListeningAlert extends StatefulWidget {
  const VoiceListeningAlert({super.key, required this.visible});

  final bool visible;

  @override
  State<VoiceListeningAlert> createState() => _VoiceListeningAlertState();
}

class _VoiceListeningAlertState extends State<VoiceListeningAlert>
    with TickerProviderStateMixin {
  late final AnimationController _enter;
  late final AnimationController _pulse;
  late final Animation<double> _fade;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _enter = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 420),
    );
    _fade = CurvedAnimation(parent: _enter, curve: Curves.easeOutCubic);
    _scale = Tween<double>(
      begin: 0.92,
      end: 1,
    ).animate(CurvedAnimation(parent: _enter, curve: Curves.easeOutBack));
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );
    if (widget.visible) {
      _enter.value = 1;
      _pulse.repeat();
    }
  }

  @override
  void didUpdateWidget(covariant VoiceListeningAlert oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.visible == widget.visible) return;
    final reduce = MediaQuery.disableAnimationsOf(context);
    if (widget.visible) {
      if (reduce) {
        _enter.value = 1;
      } else {
        _enter.forward(from: 0);
        _pulse.repeat();
      }
    } else {
      _pulse.stop();
      if (reduce) {
        _enter.value = 0;
      } else {
        _enter.reverse();
      }
    }
  }

  @override
  void dispose() {
    _enter.dispose();
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final palette = SoftNoticeColors.of(colors, SoftNoticeKind.voice);
    final reduce = MediaQuery.disableAnimationsOf(context);

    return IgnorePointer(
      ignoring: !widget.visible,
      child: AnimatedBuilder(
        animation: Listenable.merge([_enter, _pulse]),
        builder: (context, _) {
          if (_enter.value == 0 && !widget.visible) {
            return const SizedBox.shrink();
          }
          final t = reduce ? 1.0 : _fade.value;
          final pulse = reduce ? 0.5 : _pulse.value;

          return Opacity(
            opacity: t,
            child: Stack(
              children: [
                Positioned.fill(
                  child: AbsorbPointer(
                    child: ColoredBox(
                      color: colors.overlay.withValues(alpha: 0.28 * t),
                    ),
                  ),
                ),
                Align(
                  alignment: const Alignment(0, -0.15),
                  child: Transform.scale(
                    scale: reduce ? 1 : _scale.value,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 28),
                      child: SoftNoticeSurface(
                        kind: SoftNoticeKind.voice,
                        borderRadius: 28,
                        borderWidth: 1.5,
                        padding: const EdgeInsets.fromLTRB(22, 22, 22, 20),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _ListeningOrb(progress: pulse, color: palette.icon),
                            const SizedBox(height: 16),
                            Text(
                              'Je t’écoute…',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.sora(
                                fontSize: 22,
                                fontWeight: FontWeight.w700,
                                color: palette.foreground,
                                letterSpacing: -0.4,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Dis ta vente à voix haute',
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(color: palette.foreground),
                            ),
                            const SizedBox(height: 18),
                            _SpeakingBars(progress: pulse, color: palette.icon),
                            const SizedBox(height: 14),
                            Text(
                              'Touche le micro pour arrêter',
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(
                                    color: palette.foreground.withValues(
                                      alpha: 0.85,
                                    ),
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _ListeningOrb extends StatelessWidget {
  const _ListeningOrb({required this.progress, required this.color});

  final double progress;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final breathe = Curves.easeInOut.transform(
      (math.sin(progress * math.pi * 2) + 1) / 2,
    );

    return SizedBox(
      width: 88,
      height: 88,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: const Size(88, 88),
            painter: _AlertPulsePainter(progress: progress, color: color),
          ),
          Container(
            width: 56 + breathe * 2,
            height: 56 + breathe * 2,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color,
              boxShadow: [
                BoxShadow(
                  color: color.withValues(alpha: 0.28),
                  blurRadius: 16,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: const Icon(
              LucideIcons.mic,
              color: Color(0xFFFFFFFF),
              size: 24,
            ),
          ),
        ],
      ),
    );
  }
}

class _AlertPulsePainter extends CustomPainter {
  _AlertPulsePainter({required this.progress, required this.color});

  final double progress;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    for (var i = 0; i < 2; i++) {
      final raw = (progress + i * 0.5) % 1.0;
      final phase = Curves.easeOut.transform(raw);
      final radius = 28 + phase * 18;
      canvas.drawCircle(
        center,
        radius,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.2 - phase
          ..color = color.withValues(alpha: (1 - phase) * 0.35)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _AlertPulsePainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.color != color;
  }
}

class _SpeakingBars extends StatelessWidget {
  const _SpeakingBars({required this.progress, required this.color});

  final double progress;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 36,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(9, (i) {
          final phase = (progress + i / 9) % 1.0;
          final wave = (math.sin(phase * math.pi * 2) + 1) / 2;
          final h = 8.0 + wave * 22.0;
          return AnimatedContainer(
            duration: const Duration(milliseconds: 80),
            width: 3.5,
            height: h,
            margin: const EdgeInsets.symmetric(horizontal: 2.5),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.55 + wave * 0.35),
              borderRadius: BorderRadius.circular(999),
            ),
          );
        }),
      ),
    );
  }
}
