import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:plant_analysis/app/shared/helpers/widget_helper.dart';
import 'package:plant_analysis/app/shared/theme/text_theme.dart';

import '../../shared/theme/app_colors.dart';

class ScannerScreen extends StatefulWidget {
  const ScannerScreen({super.key});

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen>
    with TickerProviderStateMixin {
  final ValueNotifier isCapture = ValueNotifier(false);
  String? imagePath;

  // Handling animations
  late AnimationController _animationController;
  Animation<double>? scaleAnimation,
      sizeAnimation,
      widthAnimation,
      heightAnimation,
      paddingAnimation,
      rotateAnimation,
      radiusAnimation;

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
            Container(
              color: Colors.blue,
              alignment: Alignment.center,
              margin: const EdgeInsets.only(bottom: 80),
              height: MediaQuery.of(context).size.height,
              // Analyzing card
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return Transform.rotate(
                    angle: rotateAnimation?.value ?? 0,
                    child: Container(
                      height: heightAnimation?.value,
                      width: widthAnimation?.value,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(
                          radiusAnimation?.value ?? 0.0,
                        ),
                      ),
                      padding: EdgeInsets.all(
                        paddingAnimation?.value ?? 0,
                      ),
                      child: Column(
                        children: [
                          // Expanded(
                          //   child: isCapture.value == true
                          //       ? ClipRRect(
                          //           borderRadius: BorderRadius.circular(
                          //             radiusAnimation?.value ?? 0.0,
                          //           ),
                          //           child: Image.file(
                          //             width: double.infinity,
                          //             height:
                          //                 MediaQuery.of(context).size.height,
                          //             fit: BoxFit.cover,
                          //             File(imagePath!),
                          //           ),
                          //         )
                          //       : CameraPreview(_controller),
                          // ),
                          const SizedBox(height: 14),
                          Text(
                            "Analyzing Nick's photo",
                            style: AppTextTheme.textTheme.bodyLarge?.copyWith(
                              color: AppColors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            // In-app camera preview
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
                  child: GestureDetector(
                    onTap: _triggerAnimation,
                    child: WidgetHelper.shutter(
                      () async {
                        isCapture.value = true;
                        debugPrint("Captured image!");

                        try {
                          final capturedImage = await _controller.takePicture();
                          setState(() => imagePath = capturedImage.path);
                          _triggerAnimation();
                        } catch (e) {
                          debugPrint(e.toString());
                        }
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
