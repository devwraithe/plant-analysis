import 'package:flutter/material.dart';

class WidgetHelper {
  static Widget shutter(void Function()? onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.red,
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(100),
        ),
      ),
    );
  }

  static Widget camControl(Widget shutter) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      padding: const EdgeInsets.all(30),
      child: Center(
        child: shutter,
      ),
    );
  }
}
