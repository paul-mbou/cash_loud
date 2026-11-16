import 'package:flutter/foundation.dart';

/// One product line in a draft or committed sale.
@immutable
class SaleLine {
  const SaleLine({
    required this.product,
    required this.quantity,
    required this.unitPriceFcfa,
  });

  final String product;
  final int quantity;
  final int unitPriceFcfa;

  int get lineTotalFcfa => quantity * unitPriceFcfa;

  SaleLine copyWith({String? product, int? quantity, int? unitPriceFcfa}) {
    return SaleLine(
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
      unitPriceFcfa: unitPriceFcfa ?? this.unitPriceFcfa,
    );
  }

  String get label {
    if (quantity <= 1) return product;
    return '$quantity $product';
  }
}

/// AI / voice proposal — never persisted until the merchant confirms.
@immutable
class SaleDraft {
  const SaleDraft({
    required this.lines,
    this.customerName,
    this.rawTranscript,
    this.isCredit = false,
  });

  final List<SaleLine> lines;
  final String? customerName;
  final String? rawTranscript;
  final bool isCredit;

  int get totalFcfa => lines.fold(0, (sum, line) => sum + line.lineTotalFcfa);

  String get summaryLabel => lines.map((l) => l.label).join(' + ');

  SaleDraft copyWith({
    List<SaleLine>? lines,
    String? customerName,
    String? rawTranscript,
    bool? isCredit,
    bool clearCustomer = false,
  }) {
    return SaleDraft(
      lines: lines ?? this.lines,
      customerName: clearCustomer ? null : (customerName ?? this.customerName),
      rawTranscript: rawTranscript ?? this.rawTranscript,
      isCredit: isCredit ?? this.isCredit,
    );
  }
}

/// Committed sale — only created after explicit merchant confirmation.
@immutable
class Sale {
  const Sale({
    required this.id,
    required this.lines,
    required this.totalFcfa,
    required this.createdAt,
    this.customerName,
    this.isCredit = false,
    this.rawTranscript,
  });

  final String id;
  final List<SaleLine> lines;
  final int totalFcfa;
  final DateTime createdAt;
  final String? customerName;
  final bool isCredit;
  final String? rawTranscript;

  String get label {
    final base = lines.map((l) => l.label).join(' + ');
    if (customerName == null || customerName!.isEmpty) return base;
    return '$base · $customerName';
  }

  factory Sale.fromConfirmedDraft(SaleDraft draft, {required String id}) {
    return Sale(
      id: id,
      lines: List.unmodifiable(draft.lines),
      totalFcfa: draft.totalFcfa,
      createdAt: DateTime.now(),
      customerName: draft.customerName,
      isCredit: draft.isCredit,
      rawTranscript: draft.rawTranscript,
    );
  }
}

/// In-memory ledger for the safe checkout loop (offline-ready shape later).
class SalesLedger extends ChangeNotifier {
  SalesLedger._();

  static final SalesLedger instance = SalesLedger._();

  final List<Sale> _sales = [];
  int _seq = 0;

  /// Seed demo history so Ventes isn't empty on first open.
  void seedIfEmpty() {
    if (_sales.isNotEmpty) return;
    final now = DateTime.now();
    _sales.addAll([
      Sale(
        id: 'seed-1',
        lines: const [
          SaleLine(product: 'savons', quantity: 3, unitPriceFcfa: 500),
        ],
        totalFcfa: 1500,
        createdAt: now.subtract(const Duration(hours: 2)),
      ),
      Sale(
        id: 'seed-2',
        lines: const [
          SaleLine(product: 'Huile 1L', quantity: 1, unitPriceFcfa: 2500),
        ],
        totalFcfa: 2500,
        createdAt: now.subtract(const Duration(hours: 3)),
      ),
      Sale(
        id: 'seed-3',
        lines: const [
          SaleLine(product: 'Pain', quantity: 1, unitPriceFcfa: 400),
          SaleLine(product: 'oeufs', quantity: 4, unitPriceFcfa: 200),
        ],
        totalFcfa: 1200,
        createdAt: now.subtract(const Duration(hours: 5)),
      ),
      Sale(
        id: 'seed-4',
        lines: const [
          SaleLine(product: 'Riz 5kg', quantity: 1, unitPriceFcfa: 4500),
        ],
        totalFcfa: 4500,
        createdAt: now.subtract(const Duration(hours: 7)),
      ),
    ]);
  }

  List<Sale> get sales => List.unmodifiable(_sales);

  List<Sale> get todaySales {
    final now = DateTime.now();
    return _sales
        .where(
          (s) =>
              s.createdAt.year == now.year &&
              s.createdAt.month == now.month &&
              s.createdAt.day == now.day,
        )
        .toList();
  }

  int get todayTotalFcfa => todaySales.fold(0, (sum, s) => sum + s.totalFcfa);

  Sale? get lastSale => _sales.isEmpty ? null : _sales.first;

  /// ONLY entry point that creates a sale — call after confirmation sheet.
  Sale commit(SaleDraft draft) {
    assert(draft.lines.isNotEmpty, 'Cannot commit empty draft');
    _seq += 1;
    final sale = Sale.fromConfirmedDraft(draft, id: 'sale-$_seq');
    _sales.insert(0, sale);
    notifyListeners();
    return sale;
  }
}

/// Demo voice → draft parser. Cycles phrases; never commits.
abstract final class VoiceSaleParser {
  static int _cursor = 0;

  static const _demos = <SaleDraft>[
    SaleDraft(
      rawTranscript: 'trois savons à 500',
      lines: [SaleLine(product: 'savon', quantity: 3, unitPriceFcfa: 500)],
    ),
    SaleDraft(
      rawTranscript: 'vends 2 riz et 1 huile à M. Tabi',
      customerName: 'M. Tabi',
      isCredit: true,
      lines: [
        SaleLine(product: 'riz', quantity: 2, unitPriceFcfa: 2500),
        SaleLine(product: 'huile', quantity: 1, unitPriceFcfa: 2500),
      ],
    ),
    SaleDraft(
      rawTranscript: 'un sachet de sucre 1000',
      lines: [SaleLine(product: 'sucre', quantity: 1, unitPriceFcfa: 1000)],
    ),
    SaleDraft(
      rawTranscript: 'pain et 6 oeufs',
      lines: [
        SaleLine(product: 'pain', quantity: 1, unitPriceFcfa: 400),
        SaleLine(product: 'oeufs', quantity: 6, unitPriceFcfa: 200),
      ],
    ),
  ];

  static SaleDraft nextDraft() {
    final draft = _demos[_cursor % _demos.length];
    _cursor += 1;
    return draft;
  }
}
