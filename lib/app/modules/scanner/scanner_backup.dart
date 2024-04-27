import 'dart:io';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:plant_analysis/app/shared/helpers/widget_helper.dart';
import 'package:plant_analysis/app/shared/theme/text_theme.dart';
import 'package:plant_analysis/app/shared/utilities/env_config.dart';

import '../../shared/theme/app_colors.dart';

class ScannerScreen extends StatefulWidget {
  const ScannerScreen({super.key});

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen>
    with TickerProviderStateMixin {
  final ValueNotifier isInfoAvailable = ValueNotifier(false);
  final ValueNotifier isCapture = ValueNotifier(false);
  String? plantInfo;
  String? capturedImagePath;

  // Handling animations
  late AnimationController _animationController;
  Animation<double>? scaleAnimation,
      sizeAnimation,
      widthAnimation,
      heightAnimation,
      paddingAnimation,
      rotateAnimation,
      radiusAnimation;

  void _testGenAI(String mimeType, Uint8List imageBytes) async {
    final model = GenerativeModel(
      model: 'gemini-pro-vision',
      apiKey: EnvConfig.aiKey,
    );
    const prompt = "Give a brief analysis on this item";
    final content = [
      Content.multi([
        TextPart(prompt),
        DataPart(mimeType, imageBytes),
      ]),
    ];
    final response = await model.generateContent(content);

    setState(() => plantInfo = response.text);

    isInfoAvailable.value = true;
  }

  late List<CameraDescription> _cameras;
  late CameraController _controller;

  void _getAvailableCameras() async {
    _cameras = await availableCameras();
    _controller = CameraController(
      _cameras[0],
      ResolutionPreset.max,
    );
    _controller.initialize().then((_) {
      if (!mounted) return;
      setState(() {});
    });
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );
    _getAvailableCameras();
  }

  void _triggerAnimation() {
    scaleAnimation = Tween(
      begin: 1.0,
      end: 0.64,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.5),
      ),
    );
    widthAnimation = Tween(
      begin: MediaQuery.of(context).size.width,
      end: 260.0,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.6),
      ),
    );
    heightAnimation = Tween(
      begin: MediaQuery.of(context).size.height,
      end: 360.0,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.6),
      ),
    );
    rotateAnimation = Tween(
      begin: 0.0,
      end: -0.12,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.6),
      ),
    );
    radiusAnimation = Tween(
      begin: 0.0,
      end: 20.0,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.6),
      ),
    );
    sizeAnimation = Tween(begin: 1000.0, end: 500.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.6),
      ),
    );
    paddingAnimation = Tween(begin: 0.0, end: 22.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.6),
      ),
    );
    _animationController.forward(from: 0);
  }

  @override
  void dispose() {
    _controller.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = AppTextTheme.textTheme;

    return Scaffold(
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: [
            // In-app camera preview
            Container(
              height: double.infinity,
              color: AppColors.red,
              child: isCapture.value == true
                  ? _imagePreview(capturedImagePath!)
                  : CameraPreview(_controller),
              // child: ValueListenableBuilder(
              //   valueListenable: showPreview,
              //   builder: (context, _, child) {
              //     return Stack(
              //       children: [
              //         plantDetailsAvailable.value == true
              //             ? _retrievedImage(
              //                 () {
              //                   Navigator.push(
              //                     context,
              //                     MaterialPageRoute(
              //                       builder: (_) {
              //                         return PlantDetailsScreen(
              //                           plantImage: imagePath!,
              //                           plantInfo: aiResponse!,
              //                         );
              //                       },
              //                     ),
              //                   );
              //                 },
              //               )
              //             : showPreview.value == true
              //                 ? _previewImage(
              //                     imagePath!,
              //                     () {
              //                       showPreview.value = false;
              //                       imagePath = null;
              //
              //                       debugPrint("Preview false, Path cleaned!");
              //                     },
              //                   )
              //                 : CameraPreview(_controller),
              //       ],
              //     );
              //   },
              // ),
            ),
            Container(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 140,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(36),
                    topRight: Radius.circular(36),
                  ),
                ),
                padding: const EdgeInsets.all(26),
                child: Center(
                  child: WidgetHelper.shutter(
                    () async {
                      isCapture.value = true;

                      try {
                        final capturedImage = await _controller.takePicture();
                        showPreview.value = true;
                        // _testGenAI(
                        //   lookupMimeType(_capturedImage.path)!,
                        //   await _capturedImage.readAsBytes(),
                        // );
                        setState(() => capturedImagePath = capturedImage.path);
                        sizeAnimation = Tween(begin: 100.0, end: 300.0).animate(
                          CurvedAnimation(
                            parent: _animationController,
                            curve: const Interval(0.0, 0.5),
                          ),
                        );
                        debugPrint(
                          "Animating the sizes - ${sizeAnimation?.value}",
                        );
                      } catch (e) {
                        // If an error occurs, log the error to the console.
                        debugPrint(e.toString());
                      }
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  final ValueNotifier showPreview = ValueNotifier(false);

  Widget _imagePreview(String imagePath) {
    return Container(
      // height: double.infinity,
      height: 100,
      color: AppColors.red,
      child: Image.file(
        width: double.infinity,
        fit: BoxFit.cover,
        File(imagePath),
      ),
    );
  }

  Widget _imageAnalyzing(
    String imagePath,
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
                        File(capturedImagePath!),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    plantInfo!,
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
