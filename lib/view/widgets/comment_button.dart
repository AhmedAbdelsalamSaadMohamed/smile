import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smile/view/pages/sign_in_page.dart';
import 'package:smile/view/pages/video_comments_page.dart';
import 'package:smile/view_model/auth_view_model.dart';
import 'package:smile/view_model/video_player_view_model.dart';

class CommentButton extends StatelessWidget {
  const CommentButton({Key? key, required this.videoId}) : super(key: key);
  final String videoId;

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () {
          if (Get.find<AuthViewModel>()
              .currentUser!
              .isAnonymous!) {
            Get.find<VideoPlayerViewModel>(
                tag: videoId)
                .videoPlayerController
                .value
                .pause();
            Get.to(SignInPage(),
                transition: Transition.downToUp);
          } else
          showModalBottomSheet(context: context, builder: (context) =>
              VideoCommentsPage(
                videoId: videoId,
              ));
        },
        icon: const Icon(
          Icons.mode_comment,
          size: 40,
          color: Colors.white,
        ));
  }
}
