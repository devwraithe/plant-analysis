import 'dart:io';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:mime/mime.dart';
import 'package:plant_analysis/app/modules/plant_details_screen.dart';

import '../../shared/helpers/widget_helper.dart';

class ScannerScreen extends StatefulWidget {
  const ScannerScreen({super.key});

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  final String apiKey = "AIzaSyCnuSoAywPxinSPDs7Mz9KnFFmfs9veZK4";

  final ValueNotifier plantDetailsAvailable = ValueNotifier(false);

  String? aiResponse;

  void _testGenAI(String mimeType, Uint8List imageBytes) async {
    final model = GenerativeModel(
      model: 'gemini-pro-vision',
      apiKey: apiKey,
    );
    const prompt = "Give a brief analysis on this item";
    final content = [
      Content.multi([
        TextPart(prompt),
        DataPart(mimeType, imageBytes),
      ]),
    ];
    final response = await model.generateContent(content);

    setState(() => aiResponse = response.text);

    plantDetailsAvailable.value = true;

    debugPrint("Plant details - $aiResponse");
  }

  late List<CameraDescription> _cameras;
  late CameraController _controller;

  void _getAvailableCameras() async {
    _cameras = await availableCameras();
    _controller = CameraController(_cameras[0], ResolutionPreset.max);
    _controller.initialize().then((_) {
      if (!mounted) return;
      setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _getAvailableCameras();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: ValueListenableBuilder(
              valueListenable: showPreview,
              builder: (context, _, child) {
                return Stack(
                  children: [
                    plantDetailsAvailable.value == true
                        ? _retrievedImage(
                            () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) {
                                    return PlantDetailsScreen(
                                      plantImage: imagePath!,
                                      plantInfo: aiResponse!,
                                    );
                                  },
                                ),
                              );
                            },
                          )
                        : showPreview.value == true
                            ? _previewImage(
                                imagePath!,
                                () {
                                  showPreview.value = false;
                                  imagePath = null;

                                  debugPrint("Preview false, Path cleaned!");
                                },
                              )
                            : CameraPreview(_controller),
                  ],
                );
              },
            ),
          ),
          WidgetHelper.camControl(
            WidgetHelper.shutter(
              () async {
                try {
                  // Attempt to take a picture and then get the location
                  // where the image file is saved.
                  final XFile image = await _controller.takePicture();
                  showPreview.value = true;
                  _testGenAI(
                    lookupMimeType(image.path)!,
                    await image.readAsBytes(),
                  );

                  setState(() {
                    imagePath = image.path;
                  });
                  debugPrint("Image captured! ${image.path}");
                } catch (e) {
                  // If an error occurs, log the error to the console.
                  print(e);
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  String? imagePath;

  final ValueNotifier showPreview = ValueNotifier(false);

  Widget _previewImage(
    String imagePath,
    void Function()? onTap,
  ) {
    return Expanded(
      child: Hero(
        tag: "hero_image",
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.redAccent.withOpacity(0.16),
            ),
            child: Center(
              child: Container(
                height: 440,
                width: 320,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 26,
                  vertical: 26,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(24),
                        child: Image.file(
                          width: double.infinity,
                          fit: BoxFit.cover,
                          File(imagePath),
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    const Text(
                      "Analyzing Nick's photos...",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _retrievedImage(
    void Function()? onTap,
  ) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.redAccent.withOpacity(0.16),
          ),
          child: Center(
            child: Container(
              height: 440,
              width: 320,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 26,
                vertical: 26,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: Image.file(
                        width: double.infinity,
                        fit: BoxFit.cover,
                        File(imagePath!),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    aiResponse!,
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
