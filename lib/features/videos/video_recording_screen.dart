import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../constants/gaps.dart';
import '../../constants/sizes.dart';

class VideoRecordingScreen extends StatefulWidget {
  const VideoRecordingScreen({super.key});

  @override
  State<VideoRecordingScreen> createState() => _VideoRecordingScreenState();
}

class _VideoRecordingScreenState extends State<VideoRecordingScreen> {
  bool hasPermission = false;

  bool isSelfieMode = false;

  late FlashMode flashMode;

  late CameraController cameraController;

  @override
  void initState() {
    super.initState();

    initPermissions();
  }

  Future<void> initPermissions() async {
    final cameraPermission = await Permission.camera.request();
    final micPermission = await Permission.microphone.request();

    final cameraDenied =
        cameraPermission.isDenied || cameraPermission.isPermanentlyDenied;

    final micDenied =
        cameraPermission.isDenied || micPermission.isPermanentlyDenied;

    if (!cameraDenied && !micDenied) {
      hasPermission = true;
      await initCamera();
      setState(() {});
    }
  }

  Future<void> initCamera() async {
    final cameras = await availableCameras();

    if (cameras.isEmpty) return;

    cameraController = CameraController(
      cameras[isSelfieMode ? 1 : 0],
      ResolutionPreset.ultraHigh,
    );

    await cameraController.initialize();

    flashMode = cameraController.value.flashMode;
  }

  Future<void> toggleSelfieMode() async {
    isSelfieMode = !isSelfieMode;
    await initCamera();
    setState(() {});
  }

  Future<void> setFlashMode(FlashMode newFlashMode) async {
    await cameraController.setFlashMode(newFlashMode);
    flashMode = newFlashMode;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: !hasPermission || !cameraController.value.isInitialized
            ? const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Yoi don\'t grant permission.',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: Sizes.size20,
                    ),
                  ),
                  Gaps.v20,
                  CircularProgressIndicator.adaptive()
                ],
              )
            : Stack(
                alignment: Alignment.center,
                children: [
                  CameraPreview(cameraController),
                  Positioned(
                    top: Sizes.size20,
                    right: Sizes.size20,
                    child: Column(
                      children: [
                        IconButton(
                          onPressed: toggleSelfieMode,
                          icon: const Icon(Icons.cameraswitch),
                          color: Colors.white,
                        ),
                        Gaps.v10,
                        IconButton(
                          onPressed: () => setFlashMode(FlashMode.off),
                          icon: const Icon(Icons.flash_off_rounded),
                          color: flashMode == FlashMode.off
                              ? Colors.red
                              : Colors.white,
                        ),
                        Gaps.v10,
                        IconButton(
                          onPressed: () => setFlashMode(FlashMode.always),
                          icon: const Icon(Icons.flash_on_rounded),
                          color: flashMode == FlashMode.always
                              ? Colors.red
                              : Colors.white,
                        ),
                        Gaps.v10,
                        IconButton(
                          onPressed: () => setFlashMode(FlashMode.auto),
                          icon: const Icon(Icons.flash_auto_rounded),
                          color: flashMode == FlashMode.auto
                              ? Colors.red
                              : Colors.white,
                        ),
                        Gaps.v10,
                        IconButton(
                          onPressed: () => setFlashMode(FlashMode.torch),
                          icon: const Icon(Icons.flashlight_on_rounded),
                          color: flashMode == FlashMode.torch
                              ? Colors.red
                              : Colors.white,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
