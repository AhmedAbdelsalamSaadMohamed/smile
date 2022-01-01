import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smile/view/pages/publish_video_page.dart';
import 'package:video_player/video_player.dart';

class VideoReviewPage extends StatefulWidget {
  const VideoReviewPage({Key? key, required this.xFile}) : super(key: key);
  final XFile xFile;

  @override
  State<VideoReviewPage> createState() => _VideoReviewPageState();
}

class _VideoReviewPageState extends State<VideoReviewPage> {
  late VideoPlayerController videoPlayerController;
  late Timer _timer;
  int position = 0;

  @override
  void initState() {
    try {
      videoPlayerController =
          VideoPlayerController.file(File(widget.xFile.path));
    } catch (e) {
      print(e.toString());
    }
    videoPlayerController.initialize().then((_) {
      setState(() {
        videoPlayerController.play();
        videoPlayerController.setLooping(true);
      });
      _timer = Timer.periodic(const Duration(milliseconds: 500), (t) {
        videoPlayerController.position.then((value) {
          if (value != null && position != value.inSeconds) {
            setState(() {
              position = value.inSeconds;
            });
          }
        });
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    videoPlayerController.pause();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [
        Expanded(
          child: GestureDetector(
            onDoubleTap: () {},
            onTap: () {
              setState(() {
                if (videoPlayerController.value.isPlaying) {
                  videoPlayerController.pause();
                } else {
                  videoPlayerController.play();
                }
              });
            },
            child: Center(
              child: SizedBox(
                height: videoPlayerController.value.size.height,
                child: Stack(
                  // fit: StackFit.expand,
                  children: [
                    VideoPlayer(
                      videoPlayerController,

                    ),

                    /// play button
                    videoPlayerController.value.isPlaying
                        ? Container()
                        : Positioned(
                            top: MediaQuery.of(context).size.height * 0.5 - 25,
                            left: MediaQuery.of(context).size.width * 0.5 - 25,
                            child: const Icon(
                              Icons.play_arrow_rounded,
                              size: 60,
                              color: Colors.white,
                            )),
                    timeLine(),
                  ],
                ),
              ),
            ),
          ),
        ),

        // VideoWidget(videoUrl: widget.xFile.path, type: 'file')),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
              onPressed: () {
                // Get.find<VideoPlayerViewModel>().stopVideo();
                videoPlayerController.pause();
                Get.to(PublishVideoPage(xFile: widget.xFile));
              },
              child: Text('Next'.tr)),
        )
      ]),
    );
  }

  timeLine() {
    Duration duration = Duration(seconds: position);
    Duration total = videoPlayerController.value.duration;
    String sDuration =
        "${duration.inHours == 0 ? '' : duration.inHours.toString() + ':'}${duration.inMinutes.remainder(60)}:${(duration.inSeconds.remainder(60))}";
    String totalStr =
        "${total.inHours == 0 ? '' : total.inHours.toString() + ':'}${total.inMinutes.remainder(60)}:${(total.inSeconds.remainder(60))}";

    return Column(
      children: [
        Expanded(child: Container()),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              sDuration,
              style: TextStyle(color: Colors.white),
            ),
            Expanded(
              child: Slider(
                value: 0.0 + position,
                onChanged: (newValue) {
                  setState(() {
                    position = newValue.toInt();
                    videoPlayerController
                        .seekTo(Duration(seconds: newValue.toInt()));
                  });
                },
                max: 0.0 + videoPlayerController.value.duration.inSeconds,
              ),
            ),
            Text(totalStr, style: TextStyle(color: Colors.white))
          ],
        ),

//         Stack(
//           children: [
//             // Text('         ' + DividerThemeData().endIndent.toString()),
//             const Divider(
//               color: Colors.grey,
//               thickness:2 ,
//               indent: 0,
//             ),
//             Divider(
//               color: Colors.white,
// thickness: 2,
//               indent: 0,
//               endIndent: (MediaQuery.of(context).size.width -
//                   MediaQuery.of(context).size.width *
//                       (position /
//                           viewModel
//                               .videoPlayerController.value.duration.inSeconds)),
//             ),
//           ],
//         ),
      ],
    );
  }
}
