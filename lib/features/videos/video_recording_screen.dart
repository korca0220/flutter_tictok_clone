import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../constants/gaps.dart';
import '../../constants/sizes.dart';
import 'video_preview_screen.dart';

class VideoRecordingScreen extends StatefulWidget {
  static const String routeName = 'postVideo';
  static const String routeURL = '/upload';
  const VideoRecordingScreen({super.key});

  @override
  State<VideoRecordingScreen> createState() => _VideoRecordingScreenState();
}

class _VideoRecordingScreenState extends State<VideoRecordingScreen>
    with TickerProviderStateMixin {
  bool hasPermission = false;

  bool isSelfieMode = false;

  late FlashMode flashMode;

  late CameraController cameraController;

  late final AnimationController animationController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 200),
  );

  late final AnimationController progressAnimationController =
      AnimationController(
    vsync: this,
    duration: const Duration(
      seconds: 10,
    ),
    lowerBound: 0.0,
    upperBound: 1.0,
  );

  late final Animation<double> buttonAnimation =
      Tween<double>(begin: 1.0, end: 1.3).animate(animationController);

  @override
  void initState() {
    super.initState();

    initPermissions();
    progressAnimationController.addListener(() {
      setState(() {});
    });

    progressAnimationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        stopRecording();
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    progressAnimationController.dispose();
    animationController.dispose();
    cameraController.dispose();
    super.dispose();
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
      enableAudio: false,
    );

    await cameraController.initialize();

    await cameraController.prepareForVideoRecording();

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

  Future<void> startRecording(TapDownDetails _) async {
    if (cameraController.value.isRecordingVideo) return;

    animationController.forward();
    progressAnimationController.forward();

    await cameraController.startVideoRecording();
  }

  Future<void> stopRecording() async {
    if (!cameraController.value.isRecordingVideo) return;
    animationController.reverse();
    progressAnimationController.reset();

    final file = await cameraController.stopVideoRecording();

    if (!mounted) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VideoPreviewScreen(video: file),
      ),
    );
  }

  Future<void> onPickVideoPressed() async {
    final file = await ImagePicker().pickVideo(source: ImageSource.gallery);

    if (file != null) {
      if (!mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => VideoPreviewScreen(
            video: file,
            isPicked: true,
          ),
        ),
      );
    }
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
                  const Positioned(
                    top: Sizes.size40,
                    left: Sizes.size20,
                    child: CloseButton(
                      color: Colors.white,
                    ),
                  ),
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
                              ? Colors.amber.shade200
                              : Colors.white,
                        ),
                        Gaps.v10,
                        IconButton(
                          onPressed: () => setFlashMode(FlashMode.always),
                          icon: const Icon(Icons.flash_on_rounded),
                          color: flashMode == FlashMode.always
                              ? Colors.amber.shade200
                              : Colors.white,
                        ),
                        Gaps.v10,
                        IconButton(
                          onPressed: () => setFlashMode(FlashMode.auto),
                          icon: const Icon(Icons.flash_auto_rounded),
                          color: flashMode == FlashMode.auto
                              ? Colors.amber.shade200
                              : Colors.white,
                        ),
                        Gaps.v10,
                        IconButton(
                          onPressed: () => setFlashMode(FlashMode.torch),
                          icon: const Icon(Icons.flashlight_on_rounded),
                          color: flashMode == FlashMode.torch
                              ? Colors.amber.shade200
                              : Colors.white,
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: Sizes.size40,
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      children: [
                        const Spacer(),
                        GestureDetector(
                          onTapDown: startRecording,
                          onTapUp: (details) => stopRecording(),
                          child: ScaleTransition(
                            scale: buttonAnimation,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                SizedBox(
                                  width: Sizes.size80 + Sizes.size10,
                                  height: Sizes.size80 + Sizes.size10,
                                  child: CircularProgressIndicator(
                                    color: Colors.red.shade400,
                                    strokeWidth: Sizes.size6,
                                    value: progressAnimationController.value,
                                  ),
                                ),
                                Container(
                                  width: Sizes.size80,
                                  height: Sizes.size80,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.red.shade500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            alignment: Alignment.center,
                            child: IconButton(
                              onPressed: onPickVideoPressed,
                              icon: const FaIcon(
                                FontAwesomeIcons.image,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
