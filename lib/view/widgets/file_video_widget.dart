import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class FileVideoWidget extends StatefulWidget {
  const FileVideoWidget({Key? key, required this.videoPath}) : super(key: key);
final String videoPath;
  @override
  State<FileVideoWidget> createState() => _FileVideoWidgetState();
}

class _FileVideoWidgetState extends State<FileVideoWidget> {
  late VideoPlayerController videoPlayerController;
  late Timer _timer;
  int position = 0;

  @override
  void initState() {
    try {
      videoPlayerController = VideoPlayerController.file(File(widget.videoPath));
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
    return Expanded(
      child: Center(
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
              style:const TextStyle(color: Colors.white),
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
            Text(totalStr, style:const TextStyle(color: Colors.white))
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
