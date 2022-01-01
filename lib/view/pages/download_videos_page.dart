import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smile/view/widgets/file_video_widget.dart';


class DownloadVideosPage extends StatefulWidget {
  const DownloadVideosPage(
      {Key? key, required this.initialIndex, required this.videosPaths})
      : super(key: key);
  final int initialIndex;
  final List<String> videosPaths;

  @override
  State<DownloadVideosPage> createState() => _DownloadVideosPageState();
}

class _DownloadVideosPageState extends State<DownloadVideosPage> {

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            PageView.builder(
              scrollDirection: Axis.vertical,
              controller: PageController(initialPage: widget.initialIndex),
              itemCount: widget.videosPaths.length,
              itemBuilder: (context, index) {

                return FileVideoWidget(videoPath: widget.videosPaths[index]);},
            ),
            Positioned(
                top: 20,
                left: 20,
                child: IconButton(
                    onPressed: () {
                      Get.back();
                    },
                    icon:const Icon(Icons.close , color: Colors.white,)))
          ],
        ),
      ),
    );
  }

}


