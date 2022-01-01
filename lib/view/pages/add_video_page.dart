import 'dart:async';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smile/view/pages/Video_review_page.dart';

const double iconsSize = 30;

class AddVideoPage extends StatelessWidget {
  const AddVideoPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const CameraApp(),
          Positioned(
              bottom: 10,
              left: 10,
              right: 10,
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.face_retouching_natural,
                          size: iconsSize,
                          color: Colors.white,
                        )),
                    IconButton(
                        onPressed: () async {
                          final ImagePicker _picker = ImagePicker();
                          await _picker
                              .pickVideo(source: ImageSource.gallery)
                              .then((xFile) {
                            if (xFile != null) {
                              Get.to(VideoReviewPage(xFile: xFile));
                            }
                          });
                        },
                        icon: const Icon(
                          Icons.video_library,
                          size: iconsSize,
                          color: Colors.white,
                        )),
                  ],
                ),
              ))
        ],
      ),
    );
  }
}

class CameraApp extends StatefulWidget {
  const CameraApp({Key? key}) : super(key: key);

  @override
  _CameraAppState createState() => _CameraAppState();
}

class _CameraAppState extends State<CameraApp> {
  CameraController? cameraController;
  CameraValue? cameraValue;
  int currentCamera = 0;
  late Timer _timer;
  int seconds = 0;
  int minutes = 0;
  int hours = 0;

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(oneSec, (Timer timer) {
      if (cameraController!.value.isRecordingVideo &&
          !cameraController!.value.isRecordingPaused) {
        setState(
          () {
            if (seconds < 0) {
              timer.cancel();
            } else {
              seconds = seconds + 1;
              if (seconds > 59) {
                minutes += 1;
                seconds = 0;
                if (minutes > 59) {
                  hours += 1;
                  minutes = 0;
                }
              }
            }
          },
        );
      }
    });
  }

  @override
  void initState() {
    super.initState();
    availableCameras().then((cameras) {
      cameraController =
          CameraController(cameras[currentCamera], ResolutionPreset.medium);
      cameraController!.initialize().then((_) {
        if (!mounted) {
          return;
        }
        setState(() {});
      });
    });

    startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (cameraController == null
        ? true
        : !cameraController!.value.isInitialized) {
      return Container();
    }
    return SafeArea(
      child: Scaffold(
        body: Stack(
          fit: StackFit.expand,
          children: [
            CameraPreview(cameraController!),
            // Positioned(
            //     top: 100,
            //     left: 100,
            //     child: Text(cameraController!.description.lensDirection.name)),
            Positioned(
              top: 10,
              right: 5,
              child: IconButton(
                onPressed: () {
                  availableCameras().then((cameras) {
                    if (currentCamera == cameras.length) {
                      currentCamera = 0;
                    } else {
                      currentCamera++;
                    }

                    cameraController = CameraController(
                        cameras[currentCamera], ResolutionPreset.max);
                    cameraController!.initialize().then((_) {
                      if (!mounted) {
                        return;
                      }
                      setState(() {});
                    });
                  });
                },
                icon: const Icon(Icons.flip_camera_ios_outlined),
              ),
            ),
            Positioned(
              bottom: 10,
              left: MediaQuery.of(context).size.width * 0.5 -
                  ((cameraController!.value.isRecordingVideo ||
                          cameraController!.value.isRecordingPaused)
                      ? (1.6 * iconsSize)
                      : (iconsSize / 2)),
              child: Column(
                children: [
                  Text('$hours:$minutes:$seconds'),
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.grey,
                        border: Border.all(width: 0),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(iconsSize))),
                    child: Wrap(
                      children: [
                        (cameraController!.value.isRecordingVideo ||
                                cameraController!.value.isRecordingPaused)
                            ? IconButton(
                                onPressed: () {},
                                icon: const Icon(
                                  Icons.cancel,
                                  size: iconsSize,
                                ))
                            : Container(),
                        IconButton(
                            onPressed: () {
                              setState(() {
                                if (cameraController!.value.isRecordingPaused) {
                                  cameraController!.resumeVideoRecording();
                                } else if (cameraController!
                                    .value.isRecordingVideo) {
                                  cameraController!.pauseVideoRecording();
                                } else {
                                  cameraController!.startVideoRecording();
                                }
                              });
                            },
                            icon: Icon(
                              _getRecIcon(),
                              size: iconsSize,
                            )),
                        (cameraController!.value.isRecordingVideo ||
                                cameraController!.value.isRecordingPaused)
                            ? IconButton(
                                onPressed: () {
                                  cameraController!
                                      .stopVideoRecording()
                                      .then((xFile) {
                                    Get.to(VideoReviewPage(xFile: xFile));
                                  });
                                },
                                icon: const Icon(
                                  Icons.done,
                                  size: iconsSize,
                                ))
                            : Container(),
                      ],
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

  IconData _getRecIcon() {
    if (cameraController!.value.isRecordingVideo ||
        cameraController!.value.isRecordingPaused) {
      if (cameraController!.value.isRecordingPaused) {
        return Icons.adjust;
      } else {
        return Icons.pause;
      }
    } else {
      return Icons.play_arrow;
    }
  }
}
