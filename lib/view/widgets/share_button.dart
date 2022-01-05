import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:smile/model/video_model.dart';
import 'package:smile/view/pages/sign_in_page.dart';
import 'package:smile/view_model/auth_view_model.dart';
import 'package:smile/view_model/video_player_view_model.dart';
import 'package:smile/view_model/video_view_model.dart';

class ShareButton extends StatelessWidget {
  const ShareButton({Key? key, required this.video}) : super(key: key);
  final VideoModel video;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(
        Icons.reply,
        size: 50,
        color: Colors.white,
      ),
      onPressed: () async {
        /// if user ia anonymous
        if (Get.find<AuthViewModel>().currentUser!.isAnonymous!) {
          Get.find<VideoPlayerViewModel>(tag: video.id!)
              .videoPlayerController
              .value
              .pause();
          Get.to(SignInPage(), transition: Transition.downToUp);

          /// if real user
        } else {
          Get.bottomSheet(_bottomSheet());
        }
      },
    );
  }

  BottomSheet _bottomSheet() {
    return BottomSheet(
      onClosing: () {},
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.link_rounded),
              title: Text('Share Video Link'.tr),
              onTap: () {
                Get.back();
                Share.share(video.url!);
              },
            ),
            ListTile(
              leading: Icon(Icons.video_library_rounded),
              title: Text('Save then Share Video'.tr),
              onTap: () {
                Get.back();
                VideoViewModel()
                    .downloadVideo(video: video)
                    .then((value) => Share.shareFiles([value]));
              },
            ),
          ],
        );
      },
    );
  }
}
