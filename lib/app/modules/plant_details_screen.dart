import 'dart:io';

import 'package:flutter/material.dart';

class PlantDetailsScreen extends StatelessWidget {
  final String plantImage, plantInfo;

  const PlantDetailsScreen({
    super.key,
    required this.plantImage,
    required this.plantInfo,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Image.file(
            width: double.infinity,
            height: 400,
            fit: BoxFit.cover,
            File(plantImage),
          ),
          const SizedBox(height: 30),
          Text(
            plantInfo,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
