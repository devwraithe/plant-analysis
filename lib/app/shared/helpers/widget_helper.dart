import 'package:flutter/material.dart';
import 'package:plant_analysis/app/shared/theme/app_colors.dart';

class WidgetHelper {
  static Widget shutter(void Function()? onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 70,
        height: 70,
        decoration: BoxDecoration(
          color: AppColors.white,
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withOpacity(0.16),
              blurRadius: 12.0,
              spreadRadius: 8.0,
            ),
          ],
          borderRadius: BorderRadius.circular(100),
        ),
        padding: const EdgeInsets.all(10),
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            border: Border.all(
              color: AppColors.grey,
              width: 2.5,
            ),
            borderRadius: BorderRadius.circular(100),
          ),
        ),
      ),
    );
  }
}
