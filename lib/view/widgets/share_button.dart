

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smile/model/video_model.dart';
import 'package:smile/view/pages/sign_in_page.dart';
import 'package:smile/view_model/auth_view_model.dart';
import 'package:smile/view_model/video_player_view_model.dart';

class ShareButton extends StatelessWidget {
  const ShareButton({Key? key, required this.video}) : super(key: key);
  final VideoModel video;

  @override
  Widget build(BuildContext context) {
    return  IconButton(icon: const Icon(Icons.reply ,size: 50,color: Colors.white,),
    onPressed: () {
      if (Get.find<AuthViewModel>()
          .currentUser!
          .isAnonymous!) {
        Get.find<VideoPlayerViewModel>(
            tag: video.id!)
            .videoPlayerController
            .value
            .pause();
        Get.to(SignInPage(),
            transition: Transition.downToUp);
      }
    },);
  }
}
