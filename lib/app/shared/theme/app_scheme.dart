import 'package:flutter/material.dart';

import 'app_colors.dart';

@immutable
class AppColorScheme {
  static const light = ColorScheme.light(
    primary: AppColors.black,
    secondary: AppColors.white,
    background: AppColors.white,
  );
  static const dark = ColorScheme.dark(
    primary: AppColors.white,
    secondary: AppColors.darkGray,
    background: AppColors.darkGray,
  );
}
