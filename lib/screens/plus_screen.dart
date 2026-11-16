import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../theme/cash_loud_colors.dart';

class PlusScreen extends StatelessWidget {
  const PlusScreen({
    super.key,
    required this.themeMode,
    required this.onThemeModeChanged,
    required this.online,
    required this.onOnlineChanged,
  });

  final ThemeMode themeMode;
  final ValueChanged<ThemeMode> onThemeModeChanged;
  final bool online;
  final ValueChanged<bool> onOnlineChanged;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Plus'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
        children: [
          Text('Boutique', style: theme.textTheme.titleMedium),
          const SizedBox(height: 8),
          Text('Marché Central · Douala', style: theme.textTheme.bodyLarge),
          Text(
            'Mode démo — données locales',
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: 32),
          Text('Apparence', style: theme.textTheme.titleMedium),
          const SizedBox(height: 12),
          SegmentedButton<ThemeMode>(
            showSelectedIcon: false,
            segments: const [
              ButtonSegment(
                value: ThemeMode.system,
                label: Text('Auto'),
                icon: Icon(LucideIcons.sunMoon, size: 18),
              ),
              ButtonSegment(
                value: ThemeMode.light,
                label: Text('Clair'),
                icon: Icon(LucideIcons.sun, size: 18),
              ),
              ButtonSegment(
                value: ThemeMode.dark,
                label: Text('Sombre'),
                icon: Icon(LucideIcons.moon, size: 18),
              ),
            ],
            selected: {themeMode},
            onSelectionChanged: (set) => onThemeModeChanged(set.first),
            style: ButtonStyle(
              visualDensity: VisualDensity.compact,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              padding: const WidgetStatePropertyAll(
                EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
              foregroundColor: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.selected)) {
                  return colors.textInverse;
                }
                return colors.textPrimary;
              }),
              backgroundColor: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.selected)) {
                  return colors.primary;
                }
                return colors.surfaceElevated;
              }),
              side: WidgetStatePropertyAll(BorderSide(color: colors.border)),
              shape: WidgetStatePropertyAll(
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              textStyle: WidgetStatePropertyAll(
                theme.textTheme.labelLarge?.copyWith(fontSize: 13),
              ),
            ),
          ),
          const SizedBox(height: 32),
          Text('Connexion (démo)', style: theme.textTheme.titleMedium),
          const SizedBox(height: 4),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(
              online ? 'En ligne' : 'Hors ligne',
              style: theme.textTheme.bodyLarge,
            ),
            subtitle: Text(
              'Simuler la pastille de synchro',
              style: theme.textTheme.bodyMedium,
            ),
            value: online,
            activeThumbColor: colors.textInverse,
            activeTrackColor: colors.primary,
            onChanged: onOnlineChanged,
          ),
          const SizedBox(height: 32),
          Text(
            'Cash Loud · POS vocal · Cameroun',
            style: theme.textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}
