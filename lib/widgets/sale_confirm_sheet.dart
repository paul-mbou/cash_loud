import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../data/sales_ledger.dart';
import '../theme/cash_loud_colors.dart';
import '../widgets/cash_loud_widgets.dart';
import 'soft_notice.dart';

/// Safety guardrail: AI draft is shown for visual confirm/correct — never auto-commits.
Future<SaleDraft?> showSaleConfirmSheet({
  required BuildContext context,
  required SaleDraft draft,
}) {
  final colors = context.colors;
  return showModalBottomSheet<SaleDraft>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Colors.transparent,
    barrierColor: colors.overlay,
    elevation: 0,
    builder: (context) => SaleConfirmSheet(initial: draft),
  );
}

class SaleConfirmSheet extends StatefulWidget {
  const SaleConfirmSheet({super.key, required this.initial});

  final SaleDraft initial;

  @override
  State<SaleConfirmSheet> createState() => _SaleConfirmSheetState();
}

class _SaleConfirmSheetState extends State<SaleConfirmSheet> {
  late SaleDraft _draft;
  late final TextEditingController _customerCtrl;
  final Map<int, TextEditingController> _qtyCtrls = {};
  final Map<int, TextEditingController> _priceCtrls = {};
  final Map<int, TextEditingController> _productCtrls = {};

  @override
  void initState() {
    super.initState();
    _draft = widget.initial;
    _customerCtrl = TextEditingController(text: _draft.customerName ?? '');
    _syncLineControllers();
  }

  void _syncLineControllers() {
    for (final c in [
      ..._qtyCtrls.values,
      ..._priceCtrls.values,
      ..._productCtrls.values,
    ]) {
      c.dispose();
    }
    _qtyCtrls.clear();
    _priceCtrls.clear();
    _productCtrls.clear();
    for (var i = 0; i < _draft.lines.length; i++) {
      final line = _draft.lines[i];
      _productCtrls[i] = TextEditingController(text: line.product);
      _qtyCtrls[i] = TextEditingController(text: '${line.quantity}');
      _priceCtrls[i] = TextEditingController(text: '${line.unitPriceFcfa}');
    }
  }

  @override
  void dispose() {
    _customerCtrl.dispose();
    for (final c in [
      ..._qtyCtrls.values,
      ..._priceCtrls.values,
      ..._productCtrls.values,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  void _confirm() {
    final lines = <SaleLine>[];
    for (var i = 0; i < _draft.lines.length; i++) {
      final qty = int.tryParse(_qtyCtrls[i]!.text.trim()) ?? 1;
      final price = int.tryParse(_priceCtrls[i]!.text.trim()) ?? 0;
      final product = _productCtrls[i]!.text.trim();
      if (product.isEmpty) continue;
      lines.add(
        SaleLine(
          product: product,
          quantity: qty.clamp(1, 9999),
          unitPriceFcfa: price.clamp(0, 99999999),
        ),
      );
    }
    if (lines.isEmpty) return;
    final name = _customerCtrl.text.trim();
    final confirmed = _draft.copyWith(
      lines: lines,
      customerName: name.isEmpty ? null : name,
      clearCustomer: name.isEmpty,
      isCredit: name.isNotEmpty,
    );
    HapticFeedback.lightImpact();
    Navigator.of(context).pop(confirmed);
  }

  void _cancel() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final theme = Theme.of(context);
    final media = MediaQuery.of(context);
    final bottomInset = media.viewInsets.bottom;
    final safeBottom = media.padding.bottom;
    final isDark = theme.brightness == Brightness.dark;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        16,
        12,
        16,
        16 + (bottomInset > 0 ? bottomInset : safeBottom),
      ),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Material(
          color: Colors.transparent,
          child: ConstrainedBox(
            constraints: BoxConstraints(maxHeight: media.size.height * 0.82),
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: colors.surfaceElevated,
                borderRadius: BorderRadius.circular(28),
                border: Border.all(color: colors.border),
                boxShadow: isDark
                    ? null
                    : [
                        BoxShadow(
                          color: const Color(
                            0xFF243832,
                          ).withValues(alpha: 0.12),
                          blurRadius: 32,
                          offset: const Offset(0, 12),
                        ),
                      ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(28),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 10),
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: colors.border,
                          borderRadius: BorderRadius.circular(999),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 16, 12, 0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Vérifie la vente',
                                  style: theme.textTheme.titleLarge,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Rien n’est enregistré tant que tu n’as pas confirmé.',
                                  style: theme.textTheme.bodyMedium,
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            onPressed: _cancel,
                            tooltip: 'Annuler',
                            style: IconButton.styleFrom(
                              backgroundColor: colors.surface,
                              foregroundColor: colors.textSecondary,
                              padding: const EdgeInsets.all(8),
                              minimumSize: const Size(36, 36),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              visualDensity: VisualDensity.compact,
                              shape: const CircleBorder(),
                            ),
                            icon: const Icon(LucideIcons.x, size: 18),
                          ),
                        ],
                      ),
                    ),
                    if (_draft.rawTranscript != null) ...[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                        child: SoftNoticeSurface(
                          kind: SoftNoticeKind.voice,
                          borderRadius: 14,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                LucideIcons.mic,
                                size: 16,
                                color: SoftNoticeColors.of(
                                  colors,
                                  SoftNoticeKind.voice,
                                ).icon,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  '« ${_draft.rawTranscript} »',
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: SoftNoticeColors.of(
                                      colors,
                                      SoftNoticeKind.voice,
                                    ).foreground,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                    Flexible(
                      child: ListView.separated(
                        shrinkWrap: true,
                        padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                        itemCount: _draft.lines.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          return _LineEditor(
                            productCtrl: _productCtrls[index]!,
                            qtyCtrl: _qtyCtrls[index]!,
                            priceCtrl: _priceCtrls[index]!,
                            onChanged: () {
                              final qty =
                                  int.tryParse(_qtyCtrls[index]!.text.trim()) ??
                                  1;
                              final price =
                                  int.tryParse(
                                    _priceCtrls[index]!.text.trim(),
                                  ) ??
                                  0;
                              final product = _productCtrls[index]!.text.trim();
                              final lines = [..._draft.lines];
                              lines[index] = SaleLine(
                                product: product.isEmpty
                                    ? _draft.lines[index].product
                                    : product,
                                quantity: qty.clamp(1, 9999),
                                unitPriceFcfa: price.clamp(0, 99999999),
                              );
                              setState(() {
                                _draft = _draft.copyWith(lines: lines);
                              });
                            },
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
                      child: TextField(
                        controller: _customerCtrl,
                        textCapitalization: TextCapitalization.words,
                        decoration: InputDecoration(
                          labelText: 'Client (optionnel · ardoise)',
                          hintText: 'M. Tabi',
                          prefixIcon: Icon(
                            LucideIcons.user,
                            size: 18,
                            color: colors.textSecondary,
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {
                            final name = value.trim();
                            _draft = _draft.copyWith(
                              customerName: name.isEmpty ? null : name,
                              clearCustomer: name.isEmpty,
                              isCredit: name.isNotEmpty,
                            );
                          });
                        },
                      ),
                    ),
                    if (_draft.customerName != null &&
                        _draft.customerName!.isNotEmpty) ...[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
                        child: SoftNoticeSurface(
                          kind: SoftNoticeKind.warning,
                          borderRadius: 14,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 10,
                          ),
                          child: Row(
                            children: [
                              Icon(
                                LucideIcons.notebookPen,
                                size: 16,
                                color: SoftNoticeColors.of(
                                  colors,
                                  SoftNoticeKind.warning,
                                ).icon,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Crédit / ardoise pour ${_draft.customerName}',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: SoftNoticeColors.of(
                                      colors,
                                      SoftNoticeKind.warning,
                                    ).foreground,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 11,
                        ),
                        decoration: BoxDecoration(
                          color: colors.accentMuted.withValues(alpha: 0.4),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: colors.border),
                        ),
                        child: Row(
                          children: [
                            Text('Total', style: theme.textTheme.titleMedium),
                            const Spacer(),
                            AmountText(
                              amount: _draft.totalFcfa,
                              highlight: true,
                              compact: true,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 14, 20, 18),
                      child: Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: _cancel,
                              child: const Text('Annuler'),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            flex: 2,
                            child: FilledButton(
                              onPressed: _draft.lines.isEmpty ? null : _confirm,
                              child: const Text('Confirmer la vente'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _LineEditor extends StatelessWidget {
  const _LineEditor({
    required this.productCtrl,
    required this.qtyCtrl,
    required this.priceCtrl,
    required this.onChanged,
  });

  final TextEditingController productCtrl;
  final TextEditingController qtyCtrl;
  final TextEditingController priceCtrl;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: colors.surface.withValues(alpha: 0.65),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: colors.border),
      ),
      child: Column(
        children: [
          TextField(
            controller: productCtrl,
            textCapitalization: TextCapitalization.sentences,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: colors.textPrimary,
              fontWeight: FontWeight.w500,
            ),
            decoration: const InputDecoration(labelText: 'Article'),
            onChanged: (_) => onChanged(),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: qtyCtrl,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: colors.textPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                  decoration: const InputDecoration(labelText: 'Qté'),
                  onChanged: (_) => onChanged(),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                flex: 2,
                child: TextField(
                  controller: priceCtrl,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: colors.textPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                  decoration: const InputDecoration(
                    labelText: 'Prix unit. FCFA',
                  ),
                  onChanged: (_) => onChanged(),
                ),
              ),
              const SizedBox(width: 8),
              SizedBox(
                width: 72,
                child: Text(
                  _lineTotalLabel(),
                  textAlign: TextAlign.right,
                  style: GoogleFonts.sora(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: colors.textPrimary,
                    fontFeatures: const [FontFeature.tabularFigures()],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _lineTotalLabel() {
    final qty = int.tryParse(qtyCtrl.text.trim()) ?? 0;
    final price = int.tryParse(priceCtrl.text.trim()) ?? 0;
    final total = qty * price;
    final s = total.toString();
    final buf = StringBuffer();
    for (var i = 0; i < s.length; i++) {
      final fromEnd = s.length - i;
      buf.write(s[i]);
      if (fromEnd > 1 && fromEnd % 3 == 1) buf.write('\u202f');
    }
    return buf.toString();
  }
}
