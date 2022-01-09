import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:preload_page_view/preload_page_view.dart';
import 'package:smile/model/notification_model.dart';
import 'package:smile/model/user_model.dart';
import 'package:smile/model/video_model.dart';
import 'package:smile/view/pages/comments_screen.dart';
import 'package:smile/view/widgets/profile_circle_avatar.dart';
import 'package:smile/view/widgets/video_widget.dart';
import 'package:smile/view_model/notification_view_model.dart';
import 'package:smile/view_model/user_view_model.dart';
import 'package:smile/view_model/video_player_view_model.dart';
import 'package:smile/view_model/video_view_model.dart';

class NotificationWidget extends StatelessWidget {
  const NotificationWidget({Key? key, required this.notification})
      : super(key: key);
  final NotificationModel notification;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserModel>(
        future: UserViewModel().getUser(userId: notification.userId!),
        builder: (context, snapshot) {
          if (snapshot.hasError || !snapshot.hasData) {
            return ListTile(
              leading: ProfileCircleAvatar(
                imageUrl: '',
                radius: 25,
              ),
              title: Text(' '),
              subtitle: Text(' '),
            );
          }
          return Container(
            child: ListTile(
              leading: ProfileCircleAvatar(
                imageUrl: snapshot.data!.profileUrl,
                radius: 25,
              ),
              title: RichText(
                text: TextSpan(children: [
                  TextSpan(
                    text: snapshot.data!.name ?? "",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Theme.of(context).colorScheme.secondary),
                    // recognizer: TapGestureRecognizer()
                    //   ..onTap = () => Get.to(
                    //       UserPage(userId: snapshot.data!.id!),
                    //       transition: Transition.leftToRight),
                  ),
                  TextSpan(
                      text: ' ' +
                          (NotificationViewModel()
                              .getText(notification.action ?? ' ')),
                      style: TextStyle(
                          fontSize: 18,
                          color: Theme.of(context).colorScheme.secondary)),
                ]),
              ),
              subtitle: Text(notification.time == null
                  ? '00:00'
                  : DateFormat('MMM-dd – kk:mm').format(
                      DateTime.fromMicrosecondsSinceEpoch(
                          notification.time!.microsecondsSinceEpoch))),
              onTap: () {
                NotificationViewModel()
                    .seeNotification(notification: notification);
                if (notification.postId != null) {
                  Get.to(CommentsScreen(postId: notification.postId!),
                      transition: Transition.leftToRight);
                }
                if (notification.videoId != null &&
                    notification.action == "upload_video") {
                  Get.to(NotifyVideo(videoId: notification.videoId!));
                }
              },
            ),
            decoration: BoxDecoration(
              color: notification.isSeem!
                  ? Colors.transparent
                  : Theme.of(context).colorScheme.background,
            ),
          );
        });
  }
}

class NotifyVideo extends StatelessWidget {
  const NotifyVideo({Key? key, required this.videoId}) : super(key: key);
  final String videoId;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<VideoModel>(
        future: VideoViewModel().getVideo(videoId: videoId),
        builder: (context, snapshot) {
          if (snapshot.hasError || !snapshot.hasData) {
            return Container();
          }
          VideoModel video = snapshot.data!;
          return FutureBuilder<List<VideoModel>>(
              future: VideoViewModel().getUserVideos(video.ownerId!).first,
              builder: (context, snapshot) {
                if (snapshot.hasError || !snapshot.hasData) {
                  return Container();
                }
                List<VideoModel> videos = snapshot.data!;

                int initialIndex = videos.indexOf(
                    videos.firstWhere((element) => element.id == videoId));
                return SafeArea(
                  child: Scaffold(
                    backgroundColor: Colors.black,
                    body: Stack(
                      children: [
                        PreloadPageView.builder(
                          scrollDirection: Axis.vertical,
                          controller: PreloadPageController(
                              initialPage: initialIndex, keepPage: true),
                          itemCount: videos.length,
                          preloadPagesCount: 7,
                          // allowImplicitScrolling: true,
                          itemBuilder: (context, index) => VideoWidget(
                            autoPlay: index == initialIndex ? true : false,
                            video: videos[index],
                          ),

                          onPageChanged: (value) {
                            Get.find<VideoPlayerViewModel>(
                                    tag: videos[value].id)
                                .videoPlayerController
                                .value
                                .play();
                          },
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
              });
        });
  }
}
