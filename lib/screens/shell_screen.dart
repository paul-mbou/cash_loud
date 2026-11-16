import 'package:flutter/material.dart';

import '../data/sales_ledger.dart';
import '../theme/cash_loud_colors.dart';
import 'accueil_screen.dart';

class ShellScreen extends StatefulWidget {
  const ShellScreen({
    super.key,
    required this.themeMode,
    required this.onThemeModeChanged,
  });

  final ThemeMode themeMode;
  final ValueChanged<ThemeMode> onThemeModeChanged;

  @override
  State<ShellScreen> createState() => _ShellScreenState();
}

class _ShellScreenState extends State<ShellScreen> {
  bool _online = false;
  int _pendingSync = 3;
  bool _listening = false;
  bool _stamp = false;

  Future<void> _toggleMic() async {
    if (_listening) {
      setState(() => _listening = false);
      await runVoiceSaleFlow(
        context: context,
        draft: VoiceSaleParser.nextDraft(),
        onStamp: _triggerStamp,
      );
      return;
    }
    setState(() => _listening = true);
  }

  Future<void> _manualEntry() async {
    if (_listening) setState(() => _listening = false);
    await runVoiceSaleFlow(
      context: context,
      draft: const SaleDraft(
        lines: [SaleLine(product: 'Article', quantity: 1, unitPriceFcfa: 500)],
      ),
      onStamp: _triggerStamp,
    );
  }

  void _triggerStamp() {
    setState(() => _stamp = true);
    Future<void>.delayed(const Duration(milliseconds: 420), () {
      if (mounted) setState(() => _stamp = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Scaffold(
      backgroundColor: colors.bg,
      body: AccueilScreen(
        online: _online,
        pendingSync: _pendingSync,
        listening: _listening,
        stamp: _stamp,
        onToggleMic: _toggleMic,
        onManualEntry: _manualEntry,
        themeMode: widget.themeMode,
        onThemeModeChanged: widget.onThemeModeChanged,
        onOnlineChanged: (value) {
          setState(() {
            _online = value;
            _pendingSync = value ? 0 : 3;
          });
        },
      ),
    );
  }
}
