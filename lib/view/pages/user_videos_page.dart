import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:preload_page_view/preload_page_view.dart';
import 'package:smile/model/video_model.dart';
import 'package:smile/view/widgets/video_widget.dart';
import 'package:smile/view_model/video_player_view_model.dart';

class UserVideosPage extends StatelessWidget {
  const UserVideosPage(
      {Key? key, required this.initialIndex, required this.videos})
      : super(key: key);
  final int initialIndex;
  final List<VideoModel> videos;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            PreloadPageView.builder(
              scrollDirection: Axis.vertical,
              controller: PreloadPageController(initialPage: initialIndex,keepPage: true),
              itemCount: videos.length,
             preloadPagesCount: 7,
             // allowImplicitScrolling: true,
              itemBuilder: (context, index) => VideoWidget(autoPlay: index==initialIndex?true:false,
                video:  videos[index],
              ),

              onPageChanged: (value) {
                Get.find<VideoPlayerViewModel>(tag: videos[value].id).videoPlayerController.value.play();
              },
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
