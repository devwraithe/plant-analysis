import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import '../../shared/helpers/widget_helper.dart';

class ScannerScreen extends StatefulWidget {
  const ScannerScreen({super.key});

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
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
            child: CameraPreview(_controller),
          ),
          WidgetHelper.camControl(
            WidgetHelper.shutter(
              () => _controller.takePicture(),
            ),
          ),
        ],
      ),
    );
  }
}
