import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import '../../shared/helpers/widget_helper.dart';
import '../../shared/theme/app_colors.dart';
import '../../shared/theme/text_theme.dart';

class ScannerScreen extends StatefulWidget {
  const ScannerScreen({super.key});

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen>
    with SingleTickerProviderStateMixin {
  late List<CameraDescription> _cameras;
  late CameraController _cameraController;
  late Future<void> _initCameraController;

  final ValueNotifier isShutterClicked = ValueNotifier(false);
  final ValueNotifier isImageCaptured = ValueNotifier(false);
  final ValueNotifier imagePath = ValueNotifier("");

  // Animations
  late AnimationController _animationController;
  Animation<double>? widthAnimation,
      heightAnimation,
      paddingAnimation,
      rotateAnimation,
      radiusAnimation,
      imageRadius;

  @override
  void initState() {
    super.initState();
    initializeCamera();
    _animationController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
  }

  Future<void> initializeCamera() async {
    _cameras = await availableCameras();
    _cameraController = CameraController(_cameras[0], ResolutionPreset.max);
    await _cameraController.initialize();
    setState(() => _initCameraController = Future.value());
  }

  void _triggerAnimation() {
    widthAnimation = Tween(
      begin: MediaQuery.of(context).size.width,
      end: 280.0,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(
          0.0,
          1.0,
          curve: Curves.ease,
        ),
      ),
    );
    heightAnimation = Tween(
      begin: MediaQuery.of(context).size.height,
      end: 410.0,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(
          0.0,
          1.0,
          curve: Curves.ease,
        ),
      ),
    );
    rotateAnimation = Tween(
      begin: 0.0,
      end: -0.12,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(
          0.0,
          1.0,
          curve: Curves.ease,
        ),
      ),
    );
    radiusAnimation = Tween(
      begin: 0.0,
      end: 32.0,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(
          0.0,
          1.0,
          curve: Curves.ease,
        ),
      ),
    );
    imageRadius = Tween(
      begin: 0.0,
      end: 24.0,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(
          0.0,
          1.0,
          curve: Curves.ease,
        ),
      ),
    );
    paddingAnimation = Tween(
      begin: 0.0,
      end: 26.0,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(
          0.0,
          1.0,
          curve: Curves.ease,
        ),
      ),
    );
    _animationController.forward(from: 0);
  }

  @override
  void dispose() {
    _animationController.dispose();
    _cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background
          Container(
            color: Colors.red.withOpacity(0.16),
            height: double.infinity,
          ),
          FutureBuilder<void>(
            future: initializeCamera(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                // If the Future is complete, display the preview.
                return CameraPreview(_cameraController);
              } else {
                // Otherwise, display a loading indicator.
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
          // Camera
          // _isCameraInitialized
          //     ? ValueListenableBuilder(
          //         valueListenable: isShutterClicked,
          //         builder: (context, _, child) {
          //           if (isShutterClicked.value != true) {
          //             return SizedBox(
          //               height: double.infinity,
          //               child: CameraPreview(_cameraController),
          //             );
          //           } else {
          //             return const SizedBox();
          //           }
          //         },
          //       )
          //     : Center(
          //         child: Text(
          //           "Camera is not initialized!",
          //           style: AppTextTheme.textTheme.bodyLarge,
          //         ),
          //       ),
          // Analysis Card (Image and Text)
          ValueListenableBuilder(
            valueListenable: isImageCaptured,
            builder: (context, _, child) {
              if (isImageCaptured.value == true) {
                Future.delayed(
                  const Duration(seconds: 2),
                  () => _triggerAnimation(),
                );

                return Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.only(bottom: 80),
                  child: AnimatedBuilder(
                    animation: _animationController,
                    builder: (context, child) {
                      return Transform.rotate(
                        angle: rotateAnimation?.value ?? 0,
                        child: Container(
                          height: heightAnimation?.value,
                          width: widthAnimation?.value ?? double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(
                              radiusAnimation?.value ?? 0.0,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.black.withOpacity(0.14),
                                blurRadius: 12.0,
                                spreadRadius: 10.0,
                              ),
                            ],
                          ),
                          padding: EdgeInsets.all(
                            paddingAnimation?.value ?? 0,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(
                                    imageRadius?.value ?? 0.0,
                                  ),
                                  child: Image.file(
                                    width: double.infinity,
                                    File(imagePath.value),
                                    fit: BoxFit.cover,
                                    gaplessPlayback: true,
                                    isAntiAlias: true,
                                    filterQuality: FilterQuality.low,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                "Analyzing Nick's photo",
                                style:
                                    AppTextTheme.textTheme.bodyLarge?.copyWith(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                );
              } else {
                return const SizedBox();
              }
            },
          ),
          // Camera Controller
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
                    if (isShutterClicked.value != true) {
                      isShutterClicked.value = true;
                      try {
                        final image = await _cameraController.takePicture();
                        imagePath.value = image.path;
                        isImageCaptured.value = true;
                      } catch (e) {
                        debugPrint(e.toString());
                      }
                    }
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
