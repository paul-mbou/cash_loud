import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../theme/cash_loud_colors.dart';

class _StockItem {
  const _StockItem(this.name, this.qty, this.low);

  final String name;
  final int qty;
  final bool low;
}

class StockScreen extends StatelessWidget {
  const StockScreen({super.key});

  static const _items = [
    _StockItem('Savon de Marseille', 24, false),
    _StockItem('Huile de palme 1L', 6, true),
    _StockItem('Riz 5kg', 11, false),
    _StockItem('Oeufs (plateau)', 2, true),
  ];

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final theme = Theme.of(context);
    final qtyFmt = NumberFormat('#,###', 'fr_FR');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Stock'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
        itemCount: _items.length + 1,
        separatorBuilder: (_, index) {
          if (index == 0) return const SizedBox(height: 16);
          return Divider(color: colors.border, height: 1);
        },
        itemBuilder: (context, index) {
          if (index == 0) {
            return Text(
              'Dis « ajoute savon » ou saisis depuis Plus.',
              style: theme.textTheme.bodyMedium,
            );
          }
          final item = _items[index - 1];
          return ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 56),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 14),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item.name, style: theme.textTheme.bodyLarge),
                        if (item.low) ...[
                          const SizedBox(height: 4),
                          Text(
                            'Stock faible — à réapprovisionner',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colors.warning,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    qtyFmt.format(item.qty),
                    style: GoogleFonts.sora(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: item.low ? colors.warning : colors.textPrimary,
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
