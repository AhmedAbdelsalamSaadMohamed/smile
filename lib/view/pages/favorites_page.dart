import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smile/model/video_model.dart';
import 'package:smile/view/widgets/video_thumbnail_widget.dart';
import 'package:smile/view_model/video_view_model.dart';

import 'favorite_videos_page.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorites'.tr),
      ),
      body: StreamBuilder<List<Future<VideoModel>>>(
        stream: VideoViewModel().getFavoriteVideos(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Container();
          } else if (!snapshot.hasData) {
            return Center(
              child: Text('Loading...'.tr),
            );
          } else {
            List<Future<VideoModel>> futureVideos = snapshot.data!;
            return GridView.builder(
              itemCount: futureVideos.length,
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 150,
                  mainAxisSpacing: 2,
                  crossAxisSpacing: 2),
              itemBuilder: (context, index) {
                return FutureBuilder<VideoModel>(
                    future: futureVideos[index],
                    builder: (context, snapshot) {
                      if (snapshot.hasError || !snapshot.hasData) {
                        return Container();
                      } else {
                        VideoModel video = snapshot.data!;
                        return GestureDetector(
                            onTap: () {
                              Get.to(
                                  FavoriteVideosPage(
                                      initialIndex: index,
                                      videos: futureVideos),
                                  transition: Transition.zoom);
                            },
                            child:
                                //Text(video.name??'ddd')
                                VideoThumbnailWidget(url: video.url ?? ' '));
                      }
                    });
              },
            );
          }
        },
      ),
    );
  }
}
