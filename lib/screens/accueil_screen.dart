import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../data/sales_ledger.dart';
import '../theme/cash_loud_colors.dart';
import '../widgets/cash_loud_widgets.dart';
import '../widgets/sale_confirm_sheet.dart';
import '../widgets/soft_notice.dart';
import '../widgets/voice_listening_alert.dart';
import 'plus_screen.dart';
import 'stock_screen.dart';
import 'ventes_screen.dart';

class AccueilScreen extends StatefulWidget {
  const AccueilScreen({
    super.key,
    required this.online,
    required this.pendingSync,
    required this.listening,
    required this.stamp,
    required this.onToggleMic,
    required this.onManualEntry,
    required this.themeMode,
    required this.onThemeModeChanged,
    required this.onOnlineChanged,
  });

  final bool online;
  final int pendingSync;
  final bool listening;
  final bool stamp;
  final VoidCallback onToggleMic;
  final VoidCallback onManualEntry;
  final ThemeMode themeMode;
  final ValueChanged<ThemeMode> onThemeModeChanged;
  final ValueChanged<bool> onOnlineChanged;

  @override
  State<AccueilScreen> createState() => _AccueilScreenState();
}

class _AccueilScreenState extends State<AccueilScreen> {
  final SalesLedger _ledger = SalesLedger.instance;
  final _amountFmt = NumberFormat('#,###', 'fr_FR');

  static const _stockItems = 4;
  static const _stockLow = 2;

  @override
  void initState() {
    super.initState();
    _ledger.seedIfEmpty();
    _ledger.addListener(_onLedger);
  }

  @override
  void dispose() {
    _ledger.removeListener(_onLedger);
    super.dispose();
  }

  void _onLedger() {
    if (mounted) setState(() {});
  }

  void _open(Widget page) {
    Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => page));
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final theme = Theme.of(context);
    final today = _ledger.todayTotalFcfa;
    final sales = _ledger.todaySales;
    final creditSales = sales.where((s) => s.isCredit).toList();
    final creditTotal = creditSales.fold<int>(0, (s, e) => s + e.totalFcfa);
    final last = _ledger.lastSale;

    return SoftBoardBackdrop(
      child: SafeArea(
        child: Stack(
          children: [
            CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                  sliver: SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const BrandWordmark(),
                            const Spacer(),
                            ConnectivityChip(
                              online: widget.online,
                              pendingSync: widget.pendingSync,
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'Aujourd’hui',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 12),
                      ],
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 132),
                  sliver: SliverToBoxAdapter(
                    child: _MasonryHub(
                      left: [
                        _HubCard(
                          title: 'Ventes',
                          icon: LucideIcons.receipt,
                          accent: colors.accent,
                          onTap: () => _open(const VentesScreen()),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AmountText(
                                amount: today,
                                highlight: today > 0 || widget.stamp,
                                compact: true,
                                stampColor: widget.stamp ? colors.accent : null,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '${sales.length} vente${sales.length > 1 ? 's' : ''}',
                                style: theme.textTheme.bodyMedium,
                              ),
                              if (last != null) ...[
                                const SizedBox(height: 10),
                                Text(
                                  'Dernière · ${last.label}',
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: colors.success,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  '${_amountFmt.format(last.totalFcfa)} FCFA',
                                  style: theme.textTheme.bodySmall,
                                ),
                              ],
                              const SizedBox(height: 12),
                              TextButton(
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  minimumSize: Size.zero,
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                ),
                                onPressed: widget.listening
                                    ? null
                                    : widget.onManualEntry,
                                child: Text(
                                  'Saisie manuelle',
                                  style: theme.textTheme.labelLarge?.copyWith(
                                    color: colors.primary,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        _HubCard(
                          title: 'Ardoise',
                          icon: LucideIcons.notebookPen,
                          accent: colors.warning,
                          onTap: () => _open(const VentesScreen()),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                creditSales.isEmpty
                                    ? 'Aucune dette'
                                    : '${creditSales.length} crédit${creditSales.length > 1 ? 's' : ''}',
                                style: theme.textTheme.bodyLarge?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 6),
                              if (creditTotal == 0)
                                Text(
                                  'Tout est à jour',
                                  style: GoogleFonts.sora(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w700,
                                    color: colors.textSecondary,
                                  ),
                                )
                              else
                                AmountText(
                                  amount: creditTotal,
                                  highlight: true,
                                  compact: true,
                                  stampColor: colors.warning,
                                  style: theme.textTheme.displayMedium!
                                      .copyWith(fontSize: 22),
                                ),
                              const SizedBox(height: 8),
                              Text(
                                'Rappels WhatsApp bientôt',
                                style: theme.textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ),
                      ],
                      right: [
                        _HubCard(
                          title: 'Stock',
                          icon: LucideIcons.package,
                          accent: colors.primary,
                          onTap: () => _open(const StockScreen()),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              FittedBox(
                                fit: BoxFit.scaleDown,
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  '$_stockItems articles',
                                  maxLines: 1,
                                  softWrap: false,
                                  style: GoogleFonts.sora(
                                    fontSize:
                                        26 *
                                        AmountText.scaleForDigits(
                                          '$_stockItems'.length,
                                        ),
                                    fontWeight: FontWeight.w700,
                                    color: colors.textPrimary,
                                    letterSpacing: '$_stockItems'.length >= 6
                                        ? -0.6
                                        : -0.8,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              SoftNoticeSurface(
                                kind: SoftNoticeKind.warning,
                                borderRadius: 999,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 6,
                                ),
                                child: Text(
                                  '$_stockLow à réapprovisionner',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: SoftNoticeColors.of(
                                      colors,
                                      SoftNoticeKind.warning,
                                    ).foreground,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'Huile · Œufs en alerte',
                                style: theme.textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ),
                        _HubCard(
                          title: 'Boutique',
                          icon: LucideIcons.store,
                          accent: colors.primary,
                          onTap: () => _open(
                            PlusScreen(
                              themeMode: widget.themeMode,
                              onThemeModeChanged: widget.onThemeModeChanged,
                              online: widget.online,
                              onOnlineChanged: widget.onOnlineChanged,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Marché Central',
                                style: theme.textTheme.bodyLarge?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text('Douala', style: theme.textTheme.bodyMedium),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  Icon(
                                    widget.online
                                        ? LucideIcons.wifi
                                        : LucideIcons.wifiOff,
                                    size: 14,
                                    color: widget.online
                                        ? colors.online
                                        : colors.offline,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    widget.online ? 'En ligne' : 'Hors ligne',
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: widget.online
                                          ? colors.online
                                          : colors.offline,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Thème · Plus',
                                style: theme.textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ),
                        _HubCard(
                          title: 'Coach',
                          icon: LucideIcons.sparkles,
                          accent: colors.primary,
                          onTap: () {
                            showSoftNotice(
                              context,
                              message: 'Le coach arrive bientôt.',
                              kind: SoftNoticeKind.info,
                              icon: LucideIcons.sparkles,
                            );
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Conseils IA',
                                style: theme.textTheme.bodyLarge?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'Bientôt : alertes stock et idées de vente.',
                                style: theme.textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            VoiceListeningAlert(visible: widget.listening),
            Positioned(
              left: 0,
              right: 0,
              bottom: 28,
              child: Center(
                child: _VoiceFab(
                  listening: widget.listening,
                  onPressed: widget.onToggleMic,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Two-column masonry: independent column heights.
class _MasonryHub extends StatelessWidget {
  const _MasonryHub({required this.left, required this.right});

  final List<Widget> left;
  final List<Widget> right;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            children: [
              for (var i = 0; i < left.length; i++) ...[
                if (i > 0) const SizedBox(height: 12),
                left[i],
              ],
            ],
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            children: [
              for (var i = 0; i < right.length; i++) ...[
                if (i > 0) const SizedBox(height: 12),
                right[i],
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _HubCard extends StatelessWidget {
  const _HubCard({
    required this.title,
    required this.icon,
    required this.accent,
    required this.onTap,
    required this.child,
  });

  final String title;
  final IconData icon;
  final Color accent;
  final VoidCallback onTap;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(24),
      clipBehavior: Clip.antiAlias,
      elevation: 0,
      child: InkWell(
        onTap: () {
          HapticFeedback.selectionClick();
          onTap();
        },
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: colors.border),
            gradient: LinearGradient(
              // Bas → haut, droite → gauche — vert limité à ~40% de la carte
              begin: Alignment.bottomRight,
              end: Alignment.topLeft,
              colors: isDark
                  ? [
                      Color.alphaBlend(
                        colors.primary.withValues(alpha: 0.28),
                        colors.surfaceElevated,
                      ),
                      Color.alphaBlend(
                        colors.primary.withValues(alpha: 0.10),
                        colors.surfaceElevated,
                      ),
                      colors.surfaceElevated,
                      colors.surfaceElevated,
                    ]
                  : [
                      Color.alphaBlend(
                        colors.primary.withValues(alpha: 0.20),
                        colors.surfaceElevated,
                      ),
                      Color.alphaBlend(
                        colors.primaryMuted.withValues(alpha: 0.75),
                        colors.surfaceElevated,
                      ),
                      colors.surfaceElevated,
                      colors.surfaceElevated,
                    ],
              stops: const [0.0, 0.22, 0.40, 1.0],
            ),
            boxShadow: isDark
                ? null
                : [
                    BoxShadow(
                      color: const Color(0xFF243832).withValues(alpha: 0.05),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: accent.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(icon, size: 18, color: accent),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        title,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontSize: 16,
                        ),
                      ),
                    ),
                    Icon(
                      LucideIcons.arrowUpRight,
                      size: 18,
                      color: colors.textSecondary,
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                child,
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _VoiceFab extends StatefulWidget {
  const _VoiceFab({required this.listening, required this.onPressed});

  final bool listening;
  final VoidCallback onPressed;

  @override
  State<_VoiceFab> createState() => _VoiceFabState();
}

class _VoiceFabState extends State<_VoiceFab>
    with SingleTickerProviderStateMixin {
  static const double _size = 60;

  late final AnimationController _glow;

  @override
  void initState() {
    super.initState();
    _glow = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _syncGlow();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _syncGlow();
  }

  @override
  void didUpdateWidget(covariant _VoiceFab oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.listening != widget.listening) _syncGlow();
  }

  void _syncGlow() {
    final reduce = MediaQuery.disableAnimationsOf(context);
    if (reduce) {
      _glow.stop();
      _glow.value = 0.35;
      return;
    }
    if (!_glow.isAnimating) {
      _glow.repeat();
    }
  }

  @override
  void dispose() {
    _glow.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final reduce = MediaQuery.disableAnimationsOf(context);

    return Semantics(
      button: true,
      label: widget.listening
          ? 'Arrêter l’écoute'
          : 'Parler pour enregistrer une vente',
      child: SizedBox(
        width: _size + 48,
        height: _size + 48,
        child: AnimatedBuilder(
          animation: _glow,
          builder: (context, child) {
            final t = reduce ? 0.35 : _glow.value;
            return Stack(
              alignment: Alignment.center,
              clipBehavior: Clip.none,
              children: [
                CustomPaint(
                  size: const Size(_size + 48, _size + 48),
                  painter: _SoftRoundGlowPainter(
                    progress: t,
                    color: colors.voice,
                    listening: widget.listening,
                    buttonSize: _size,
                  ),
                ),
                child!,
              ],
            );
          },
          child: Material(
            color: colors.voice,
            shape: const CircleBorder(),
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: () {
                HapticFeedback.mediumImpact();
                widget.onPressed();
              },
              child: SizedBox(
                width: _size,
                height: _size,
                child: Icon(
                  widget.listening ? LucideIcons.micOff : LucideIcons.mic,
                  size: 24,
                  color: const Color(0xFFFFFFFF),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Soft circular glow that follows the button’s round silhouette.
class _SoftRoundGlowPainter extends CustomPainter {
  _SoftRoundGlowPainter({
    required this.progress,
    required this.color,
    required this.listening,
    required this.buttonSize,
  });

  final double progress;
  final Color color;
  final bool listening;
  final double buttonSize;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final baseRadius = buttonSize / 2;

    // Soft static-ish halo with gentle breathe
    final breathe = Curves.easeInOut.transform(
      (math.sin(progress * math.pi * 2) + 1) / 2,
    );
    canvas.drawCircle(
      center,
      baseRadius + 4 + breathe * 3,
      Paint()
        ..color = color.withValues(alpha: 0.14 + breathe * 0.06)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 16),
    );

    // Soft expanding rings (classic pulse, eased)
    final ringCount = listening ? 2 : 2;
    for (var i = 0; i < ringCount; i++) {
      final raw = (progress + i / ringCount) % 1.0;
      final phase = Curves.easeOut.transform(raw);
      final radius = baseRadius + 2 + phase * (listening ? 16.0 : 12.0);
      final opacity = (1 - phase) * (listening ? 0.38 : 0.26);
      canvas.drawCircle(
        center,
        radius,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.2 - phase * 0.9
          ..color = color.withValues(alpha: opacity.clamp(0.0, 1.0))
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2.5),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _SoftRoundGlowPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.color != color ||
        oldDelegate.listening != listening;
  }
}

/// Shared sale confirm flow used from the voice FAB.
Future<void> runVoiceSaleFlow({
  required BuildContext context,
  required SaleDraft draft,
  required VoidCallback onStamp,
}) async {
  final confirmed = await showSaleConfirmSheet(context: context, draft: draft);
  if (!context.mounted || confirmed == null) return;
  final sale = SalesLedger.instance.commit(confirmed);
  HapticFeedback.mediumImpact();
  onStamp();
  final amountFmt = NumberFormat('#,###', 'fr_FR');
  showSoftNotice(
    context,
    message:
        'Vente confirmée · ${sale.label} · ${amountFmt.format(sale.totalFcfa)} FCFA',
    kind: SoftNoticeKind.success,
    icon: LucideIcons.check,
  );
}
