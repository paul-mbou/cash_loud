import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../data/sales_ledger.dart';
import '../theme/cash_loud_colors.dart';
import '../widgets/cash_loud_widgets.dart';

class VentesScreen extends StatefulWidget {
  const VentesScreen({super.key});

  @override
  State<VentesScreen> createState() => _VentesScreenState();
}

class _VentesScreenState extends State<VentesScreen> {
  final SalesLedger _ledger = SalesLedger.instance;
  final _amountFmt = NumberFormat('#,###', 'fr_FR');

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

  String _formatTime(DateTime dt) {
    final h = dt.hour.toString().padLeft(2, '0');
    final m = dt.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final theme = Theme.of(context);
    final sales = _ledger.todaySales;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ventes'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
      ),
      body: sales.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Text(
                  'Dis une vente, puis confirme le résumé avant d’enregistrer.',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: colors.textSecondary,
                  ),
                ),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
              itemCount: sales.length + 1,
              separatorBuilder: (_, index) {
                if (index == 0) return const SizedBox(height: 16);
                return Divider(color: colors.border, height: 1);
              },
              itemBuilder: (context, index) {
                if (index == 0) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Aujourd’hui',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      AmountText(
                        amount: _ledger.todayTotalFcfa,
                        highlight: true,
                        compact: true,
                      ),
                    ],
                  );
                }
                final sale = sales[index - 1];
                return ConstrainedBox(
                  constraints: const BoxConstraints(minHeight: 56),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                sale.label,
                                style: theme.textTheme.bodyLarge,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                sale.isCredit
                                    ? '${_formatTime(sale.createdAt)} · ardoise'
                                    : _formatTime(sale.createdAt),
                                style: GoogleFonts.ibmPlexMono(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: sale.isCredit
                                      ? colors.warning
                                      : colors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          '${_amountFmt.format(sale.totalFcfa)} FCFA',
                          style: GoogleFonts.sora(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: colors.textPrimary,
                            fontFeatures: const [FontFeature.tabularFigures()],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
