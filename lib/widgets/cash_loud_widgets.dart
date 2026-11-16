import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../theme/cash_loud_colors.dart';
import 'soft_notice.dart';

/// Soft gradient atmosphere (ref craft, green family — not purple).
class SoftBoardBackdrop extends StatelessWidget {
  const SoftBoardBackdrop({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [colors.bgGlow, colors.bg, colors.bg],
          stops: const [0.0, 0.45, 1.0],
        ),
      ),
      child: child,
    );
  }
}

class BrandWordmark extends StatelessWidget {
  const BrandWordmark({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Text(
      'Cash Loud',
      style: GoogleFonts.sora(
        fontSize: 22,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.5,
        color: colors.primary,
      ),
    );
  }
}

class VoiceModeBadge extends StatelessWidget {
  const VoiceModeBadge({super.key, required this.active});

  final bool active;

  @override
  Widget build(BuildContext context) {
    if (!active) return const SizedBox.shrink();
    final palette = SoftNoticeColors.of(context.colors, SoftNoticeKind.voice);
    return SoftNoticeSurface(
      kind: SoftNoticeKind.voice,
      borderRadius: 999,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Text(
        'Mode vocal',
        style: GoogleFonts.dmSans(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: palette.foreground,
        ),
      ),
    );
  }
}

/// Soft elevated money card.
class SoftMoneyCard extends StatefulWidget {
  const SoftMoneyCard({
    super.key,
    required this.amount,
    this.lastSaleLabel,
    this.stamp = false,
  });

  final num amount;
  final String? lastSaleLabel;
  final bool stamp;

  @override
  State<SoftMoneyCard> createState() => _SoftMoneyCardState();
}

class _SoftMoneyCardState extends State<SoftMoneyCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _stampCtrl;

  @override
  void initState() {
    super.initState();
    _stampCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
  }

  @override
  void didUpdateWidget(covariant SoftMoneyCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.stamp && !oldWidget.stamp) {
      _stampCtrl.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _stampCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return AnimatedBuilder(
      animation: _stampCtrl,
      builder: (context, _) {
        final stamping = _stampCtrl.isAnimating || _stampCtrl.value > 0;
        final stampColor = stamping
            ? Color.lerp(
                colors.accent,
                colors.textPrimary,
                Curves.easeOut.transform(_stampCtrl.value),
              )
            : null;

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(22, 20, 22, 20),
          decoration: BoxDecoration(
            color: colors.surfaceElevated,
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: colors.border.withValues(alpha: 0.9)),
            boxShadow: isDark
                ? null
                : [
                    BoxShadow(
                      color: const Color(0xFF243832).withValues(alpha: 0.05),
                      blurRadius: 28,
                      offset: const Offset(0, 10),
                    ),
                  ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Chiffre du jour',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colors.textSecondary,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              AmountText(
                amount: widget.amount,
                highlight: widget.amount > 0,
                stampColor: stampColor,
              ),
              if (widget.lastSaleLabel != null) ...[
                const SizedBox(height: 10),
                Text(
                  widget.lastSaleLabel!,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colors.success,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}

/// Large centered speak prompt (Asklepios-style clarity).
class SpeakPrompt extends StatelessWidget {
  const SpeakPrompt({super.key, required this.listening});

  final bool listening;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Text(
      listening
          ? 'Je t’écoute…\nDis ta vente.'
          : 'Dis n’importe quoi\npour vendre.',
      textAlign: TextAlign.center,
      style: GoogleFonts.sora(
        fontSize: 28,
        height: 1.3,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.6,
        color: listening ? colors.voice : colors.textPrimary,
      ),
    );
  }
}

class VoiceWaveform extends StatefulWidget {
  const VoiceWaveform({super.key, required this.active});

  final bool active;

  @override
  State<VoiceWaveform> createState() => _VoiceWaveformState();
}

class _VoiceWaveformState extends State<VoiceWaveform>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _sync();
  }

  @override
  void didUpdateWidget(covariant VoiceWaveform oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.active != widget.active) _sync();
  }

  void _sync() {
    final reduce = MediaQuery.disableAnimationsOf(context);
    if (!widget.active || reduce) {
      _ctrl.stop();
      _ctrl.value = widget.active ? 0.4 : 0;
      return;
    }
    _ctrl.repeat(reverse: true);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    if (!widget.active) {
      return SizedBox(
        height: 36,
        child: Center(
          child: Container(
            width: 48,
            height: 3,
            decoration: BoxDecoration(
              color: colors.border,
              borderRadius: BorderRadius.circular(999),
            ),
          ),
        ),
      );
    }

    return AnimatedBuilder(
      animation: _ctrl,
      builder: (context, _) {
        return SizedBox(
          height: 44,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: List.generate(11, (i) {
              final phase = (i / 11) * math.pi;
              final t = (math.sin((_ctrl.value * math.pi) + phase).abs());
              final h = 8.0 + t * 28.0;
              return Container(
                width: 4,
                height: h,
                margin: const EdgeInsets.symmetric(horizontal: 3),
                decoration: BoxDecoration(
                  color: Color.lerp(colors.primary, colors.voice, i / 10)!,
                  borderRadius: BorderRadius.circular(999),
                ),
              );
            }),
          ),
        );
      },
    );
  }
}

class AmountText extends StatelessWidget {
  const AmountText({
    super.key,
    required this.amount,
    this.highlight = false,
    this.style,
    this.compact = false,
    this.stampColor,
  });

  final num amount;
  final bool highlight;
  final TextStyle? style;
  final bool compact;
  final Color? stampColor;

  static final formatter = NumberFormat('#,###', 'fr_FR');

  /// Soft step-down so 5–6+ digit totals stay readable in cards.
  static double scaleForDigits(int digits) {
    if (digits <= 5) return 1;
    if (digits == 6) return 0.88;
    if (digits == 7) return 0.76;
    if (digits == 8) return 0.66;
    return 0.58;
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final theme = Theme.of(context);
    final base =
        style ??
        (compact
            ? theme.textTheme.displayMedium!
            : theme.textTheme.displayLarge!.copyWith(fontSize: 40));
    final amountColor =
        stampColor ?? (highlight ? colors.accent : colors.textPrimary);

    final digits = amount.abs().truncate().toString().length;
    final scale = scaleForDigits(digits);
    final fontSize = (base.fontSize ?? 40) * scale;

    return FittedBox(
      fit: BoxFit.scaleDown,
      alignment: Alignment.centerLeft,
      child: Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: formatter.format(amount),
              style: GoogleFonts.sora(
                fontSize: fontSize,
                height: base.height,
                fontWeight: FontWeight.w700,
                letterSpacing: digits >= 6 ? -0.8 : -1.2,
                color: amountColor,
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
            ),
            TextSpan(
              text: ' FCFA',
              style: GoogleFonts.dmSans(
                fontSize: fontSize * 0.34,
                height: 1.2,
                fontWeight: FontWeight.w700,
                color: highlight
                    ? amountColor.withValues(alpha: 0.85)
                    : colors.textSecondary,
              ),
            ),
          ],
        ),
        maxLines: 1,
        softWrap: false,
      ),
    );
  }
}

class ConnectivityChip extends StatelessWidget {
  const ConnectivityChip({
    super.key,
    required this.online,
    this.pendingSync = 0,
  });

  final bool online;
  final int pendingSync;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final kind = online ? SoftNoticeKind.success : SoftNoticeKind.warning;
    final palette = SoftNoticeColors.of(colors, kind);
    final label = online
        ? (pendingSync > 0 ? 'En ligne · $pendingSync' : 'En ligne')
        : 'Hors ligne';

    return Semantics(
      label: online
          ? (pendingSync > 0
                ? 'En ligne · $pendingSync en attente'
                : 'En ligne')
          : 'Hors ligne · synchro en attente',
      child: SoftNoticeSurface(
        kind: kind,
        borderRadius: 999,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              online ? LucideIcons.wifi : LucideIcons.wifiOff,
              size: 14,
              color: palette.icon,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: palette.foreground,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Floating dock with raised center mic — primary signature.
class FloatingVoiceDock extends StatelessWidget {
  const FloatingVoiceDock({
    super.key,
    required this.index,
    required this.listening,
    required this.onSelect,
    required this.onMicPressed,
  });

  final int index;
  final bool listening;
  final ValueChanged<int> onSelect;
  final VoidCallback onMicPressed;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final bottom = MediaQuery.paddingOf(context).bottom;

    return Padding(
      padding: EdgeInsets.fromLTRB(20, 0, 20, math.max(bottom, 12)),
      child: SizedBox(
        height: 78,
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.bottomCenter,
          children: [
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                height: 64,
                decoration: BoxDecoration(
                  color: colors.dock,
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(color: colors.border),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF243832).withValues(alpha: 0.07),
                      blurRadius: 24,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: _DockItem(
                        icon: LucideIcons.house,
                        label: 'Accueil',
                        selected: index == 0,
                        onTap: () => onSelect(0),
                      ),
                    ),
                    Expanded(
                      child: _DockItem(
                        icon: LucideIcons.receipt,
                        label: 'Ventes',
                        selected: index == 1,
                        onTap: () => onSelect(1),
                      ),
                    ),
                    const SizedBox(width: 72),
                    Expanded(
                      child: _DockItem(
                        icon: LucideIcons.package,
                        label: 'Stock',
                        selected: index == 2,
                        onTap: () => onSelect(2),
                      ),
                    ),
                    Expanded(
                      child: _DockItem(
                        icon: LucideIcons.ellipsis,
                        label: 'Plus',
                        selected: index == 3,
                        onTap: () => onSelect(3),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: -6,
              child: _CenterMic(listening: listening, onPressed: onMicPressed),
            ),
          ],
        ),
      ),
    );
  }
}

class _DockItem extends StatelessWidget {
  const _DockItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final color = selected ? colors.primary : colors.dockIcon;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 22, color: color),
          const SizedBox(height: 2),
          Text(
            label,
            style: GoogleFonts.dmSans(
              fontSize: 10,
              fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class _CenterMic extends StatelessWidget {
  const _CenterMic({required this.listening, required this.onPressed});

  final bool listening;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Semantics(
      button: true,
      label: listening
          ? 'Arrêter l’écoute'
          : 'Parler pour enregistrer une vente',
      child: Material(
        color: colors.voice,
        shape: const CircleBorder(),
        elevation: 3,
        shadowColor: colors.voice.withValues(alpha: 0.28),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: () {
            HapticFeedback.mediumImpact();
            onPressed();
          },
          child: Ink(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: colors.voice,
              border: Border.all(color: colors.surfaceElevated, width: 3),
            ),
            child: Icon(
              listening ? LucideIcons.micOff : LucideIcons.mic,
              size: 26,
              color: const Color(0xFFFFFFFF),
            ),
          ),
        ),
      ),
    );
  }
}
