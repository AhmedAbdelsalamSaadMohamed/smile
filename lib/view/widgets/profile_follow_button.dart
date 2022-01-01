import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smile/model/user_model.dart';
import 'package:smile/model/video_model.dart';
import 'package:smile/view/pages/profile_page.dart';
import 'package:smile/view/pages/sign_in_page.dart';
import 'package:smile/view/pages/user_page.dart';
import 'package:smile/view/widgets/profile_circle_avatar.dart';
import 'package:smile/view_model/auth_view_model.dart';
import 'package:smile/view_model/user_view_model.dart';
import 'package:smile/view_model/video_player_view_model.dart';

class ProfileFollowButton extends StatelessWidget {
  ProfileFollowButton({Key? key, required this.video}) : super(key: key);
  final VideoModel video;

  final String currentUserId = Get.find<AuthViewModel>().currentUser!.id!;

  @override
  Widget build(BuildContext context) {
    String userId = video.ownerId!;
    return SizedBox(
      height: 60,
      width: 50,
      child: FutureBuilder<UserModel?>(
          future: UserViewModel().getUser(userId: userId),
          builder: (context, snapshot) {
            if (snapshot.hasError || !snapshot.hasData) {
              return const ProfileCircleAvatar(imageUrl: '', radius: 25);
            }
            return Stack(
              children: [
                GestureDetector(
                  child: ProfileCircleAvatar(
                      imageUrl: snapshot.data!.profileUrl, radius: 25),
                  onTap: () {
                    Get.find<VideoPlayerViewModel>(tag: video.id!)
                        .videoPlayerController
                        .value
                        .pause();
                    Get.to(UserPage(userId: video.ownerId!));
                  },
                ),

                /// follow button
                StreamBuilder<bool>(
                    stream: UserViewModel().isFollowing(userId),
                    builder: (context, snapshot) {
                      if (snapshot.hasError || !snapshot.hasData) {
                        return Container(
                          height: 20,
                        );
                      }
                      RxBool hideButton = (userId == currentUserId).obs;
                      return Obx(() => hideButton.value
                          ? Container()
                          : Positioned(
                              bottom: 0,
                              left: 12,
                              child: GestureDetector(
                                child: Container(
                                  child: Icon(
                                    snapshot.data! ? Icons.done : Icons.add,
                                    size: 20,
                                    color: Colors.white,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: snapshot.data!
                                        ? Colors.green
                                        : Theme.of(context).primaryColor,
                                  ),
                                ),
                                onTap: () {
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
                                  } else
                                    snapshot.data!
                                        ? userViewModel.unFollow(userId: userId)
                                        : userViewModel.follow(userId: userId);
                                  // hideButton.value = true;
                                },
                              ),
                            ));
                    }),
              ],
            );
          }),
    );
  }
}
