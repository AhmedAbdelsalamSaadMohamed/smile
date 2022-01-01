import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smile/model/video_model.dart';
import 'package:smile/view/widgets/video_widget.dart';

class FavoriteVideosPage extends StatelessWidget {
  const FavoriteVideosPage(
      {Key? key, required this.initialIndex, required this.videos})
      : super(key: key);
  final int initialIndex;
  final List<Future<VideoModel>> videos;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            PageView.builder(
              scrollDirection: Axis.vertical,
              controller: PageController(initialPage: initialIndex),
              itemCount: videos.length,
              itemBuilder: (context, index) => FutureBuilder<VideoModel>(
                  future: videos[index],
                  builder: (context, snapshot) {
                    if (snapshot.hasError || !snapshot.hasData) {
                      return Container();
                    }

                    return VideoWidget(
                      autoPlay: index== initialIndex?true:false,
                      video:  snapshot.data!,
                    );
                  }),
            ),
            Positioned(
                top: 20,
                left: 20,
                child: IconButton(
                    onPressed: () {
                      Get.back();
                    },
                    icon: const Icon(
                      Icons.close,
                      color: Colors.white,
                    )))
          ],
        ),
      ),
    );
  }
}
