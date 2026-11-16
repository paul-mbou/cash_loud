import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'screens/shell_screen.dart';
import 'theme/cash_loud_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
  );
  runApp(const CashLoudApp());
}

class CashLoudApp extends StatefulWidget {
  const CashLoudApp({super.key});

  @override
  State<CashLoudApp> createState() => _CashLoudAppState();
}

class _CashLoudAppState extends State<CashLoudApp> {
  ThemeMode _themeMode = ThemeMode.system;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cash Loud',
      debugShowCheckedModeBanner: false,
      theme: CashLoudTheme.light(),
      darkTheme: CashLoudTheme.dark(),
      themeMode: _themeMode,
      home: ShellScreen(
        themeMode: _themeMode,
        onThemeModeChanged: (mode) => setState(() => _themeMode = mode),
      ),
    );
  }
}
