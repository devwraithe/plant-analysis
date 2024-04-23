import 'package:flutter/material.dart';
import 'package:plant_analysis/app/shared/theme/text_theme.dart';

import '../utilities/constants.dart';
import 'app_scheme.dart';

class AppTheme {
  static final theme = ThemeData(
    fontFamily: Constants.fontFamily,
    textTheme: AppTextTheme.textTheme,
    colorScheme: AppColorScheme.light,
    scaffoldBackgroundColor: AppColorScheme.light.background,
    useMaterial3: true,
    visualDensity: VisualDensity.adaptivePlatformDensity,
  );
}
