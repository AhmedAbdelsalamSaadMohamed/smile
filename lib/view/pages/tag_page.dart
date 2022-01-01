import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smile/model/video_model.dart';
import 'package:smile/services/firebase/tag_firestore.dart';
import 'package:smile/view/pages/tag_videos_page.dart';
import 'package:smile/view/widgets/video_thumbnail_widget.dart';

class TagPage extends StatelessWidget {
  const TagPage({Key? key, required this.hashtag}) : super(key: key);
  final String hashtag;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(hashtag),
      ),
      body: FutureBuilder<List<Future<VideoModel>>>(
        future: TagFireStore().getTagVideos(hashtag),
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasError || !snapshot.hasData) {
            return Container();
          }
          List<Future<VideoModel>> videos = snapshot.data!;
          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 3 / 4,
                crossAxisSpacing: 2,
                mainAxisSpacing: 2),
            itemCount: snapshot.data!.length,
            scrollDirection: Axis.vertical,
            controller: ScrollController(),
            semanticChildCount: 10,
            itemBuilder: (context, index) {
              return FutureBuilder<VideoModel>(
                  future: snapshot.data![index], //VideoViewModel().video,
                  builder: (context, snapshot) {
                    if (snapshot.hasError || !snapshot.hasData) {
                      return Container();
                    }
                    VideoModel videoModel = snapshot.data!;
                    return GestureDetector(
                        onTap: () {
                          Get.to(TagVideosPage(
                              initialIndex: index, videos: videos));
                        },
                        child: VideoThumbnailWidget(url: videoModel.url ?? ''));
                  });
            },
          );
        },
      ),
    );
  }
}
