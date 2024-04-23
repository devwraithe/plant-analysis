import 'package:flutter/material.dart';

@immutable
class AppTextTheme {
  static TextTheme textTheme = const TextTheme(
    headlineMedium: TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.w700,
    ),
    headlineSmall: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w500,
    ),
    bodyLarge: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
    ),
    bodyMedium: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
    ),
  );
}
