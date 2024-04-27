import 'package:flutter/material.dart';
import 'package:plant_analysis/app/shared/helpers/widget_helper.dart';

import '../../shared/theme/app_colors.dart';
import '../../shared/theme/text_theme.dart';

class ScannerEffects extends StatefulWidget {
  const ScannerEffects({Key? key}) : super(key: key);

  @override
  State<ScannerEffects> createState() => _ScannerEffectsState();
}

class _ScannerEffectsState extends State<ScannerEffects>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  Animation<double>? scaleAnimation,
      sizeAnimation,
      widthAnimation,
      heightAnimation,
      paddingAnimation,
      rotateAnimation,
      radiusAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _triggerAnimation() {
    scaleAnimation = Tween(
      begin: 1.0,
      end: 0.64,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5),
      ),
    );
    widthAnimation = Tween(
      begin: MediaQuery.of(context).size.width,
      end: 260.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6),
      ),
    );
    heightAnimation = Tween(
      begin: MediaQuery.of(context).size.height,
      end: 360.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6),
      ),
    );
    rotateAnimation = Tween(
      begin: 0.0,
      end: -0.12,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6),
      ),
    );
    radiusAnimation = Tween(
      begin: 0.0,
      end: 28.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6),
      ),
    );
    sizeAnimation = Tween(begin: 1000.0, end: 500.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6),
      ),
    );
    paddingAnimation = Tween(begin: 0.0, end: 22.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6),
      ),
    );
    _controller.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
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
                          Expanded(
                            child: Container(
                              height: MediaQuery.of(context).size.height,
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(
                                  radiusAnimation?.value ?? 0.0,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 14),
                          Text(
                            "Analyzing wraithe's photo",
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
            // AnimatedBuilder(
            //   animation: _controller,
            //   builder: (context, child) {
            //     return Container(
            //       color: Colors.black,
            //       height: sizeAnimation?.value,
            //     );
            //   },
            // ),
            // Container(
            //   alignment: Alignment.center,
            //   child: Column(
            //     children: [
            //       Container(
            //         height: 240,
            //         decoration: const BoxDecoration(
            //           color: Colors.black,
            //         ),
            //       ),
            //
            //     ],
            //   ),
            // ),
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
                    child: WidgetHelper.shutter(() => _triggerAnimation()),
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
