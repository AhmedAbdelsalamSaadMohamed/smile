import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smile/model/video_model.dart';
import 'package:smile/services/firebase/tag_firestore.dart';
import 'package:smile/view/pages/tag_videos_page.dart';
import 'package:smile/view/widgets/video_thumbnail_widget.dart';
import 'package:smile/view_model/video_view_model.dart';

class DiscoverPage extends StatelessWidget {
  DiscoverPage({Key? key}) : super(key: key);
  String searchValue = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _Search(),
          Expanded(
              child: FutureBuilder<Map<String, List<String>>>(
                  future: TagFireStore().getAllTags(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Center(
                        child: Text(snapshot.error.toString()),
                      );
                    }
                    if (!snapshot.hasData) {
                      return Container(
                        color: Colors.grey,
                      );
                    }
                    List<String> tags = [...snapshot.data!.keys];
                    return ListView.builder(
                      itemCount: tags.length,
                      itemBuilder: (context, index) => _TagWidget(
                          tag: tags[index],
                          videosIds: snapshot.data![tags[index]] ?? []),
                    );
                  }))
        ],
      ),
    );
  }
}

class _Search extends StatelessWidget {
  _Search({Key? key}) : super(key: key);
  final GlobalKey<FormState> _formKy = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Form(
          key: _formKy,
          child: TextFormField(
            scrollPadding: const EdgeInsets.all(0),
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              hintText: 'Search'.tr,
              prefixIcon: IconButton(
                icon: const Icon(Icons.search),
                onPressed: () {},
              ),
            ),
          )),
    );
  }
}

class _TagWidget extends StatelessWidget {
  const _TagWidget({Key? key, required this.tag, required this.videosIds})
      : super(key: key);
  final String tag;
  final List<String> videosIds;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 15,
                  backgroundColor: Colors.grey,
                  child: Text('#'),
                ),
                Text(
                  tag.substring(
                    1,
                  ),
                  style: TextStyle(
                      color: Theme.of(context).primaryColor, fontSize: 24),
                  textAlign: TextAlign.left,
                ),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Future<VideoModel>>>(
                future: TagFireStore().getTagVideos(tag),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Container();
                  } else if (!snapshot.hasData) {
                    return Center(
                      child: Text('Loading...'.tr),
                    );
                  } else {
                    List<Future<VideoModel>> futureVideos = snapshot.data!;
                    return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: videosIds.length,
                      itemBuilder: (context, index) => SizedBox(
                        width: 100,
                        // padding:const EdgeInsets.all(8.0),
                        child: FutureBuilder<VideoModel>(
                            future: VideoViewModel()
                                .getVideo(videoId: videosIds[index]),
                            builder: (context, snapshot) {
                              if (snapshot.hasError || !snapshot.hasData) {
                                return Container(
                                  color: Colors.grey,
                                );
                              }
                              VideoModel video = snapshot.data!;
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 2),
                                child: GestureDetector(
                                  child: VideoThumbnailWidget(
                                    url: video.url ?? '',
                                  ),
                                  onTap: () {
                                    Get.to(TagVideosPage(
                                      initialIndex: index,
                                      videos: futureVideos,
                                    ));
                                  },
                                ),
                              );
                            }),
                      ),
                    );
                  }
                }),
          ),
        ],
      ),
    );
  }
}
