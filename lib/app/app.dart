import 'package:flutter/material.dart';
import 'package:plant_analysis/app/modules/scanner/scanner_screen.dart';
import 'package:plant_analysis/app/shared/theme/app_theme.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Plant Analysis',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      themeMode: ThemeMode.light,
      home: const ScannerScreen(),
    );
  }
}
