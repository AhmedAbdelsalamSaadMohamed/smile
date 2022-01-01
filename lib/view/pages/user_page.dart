import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:smile/model/post_model.dart';
import 'package:smile/model/user_model.dart';
import 'package:smile/model/video_model.dart';
import 'package:smile/services/firebase/user_firestore.dart';
import 'package:smile/view/pages/profile_page.dart';
import 'package:smile/view/pages/sign_in_page.dart';
import 'package:smile/view/pages/user_videos_page.dart';
import 'package:smile/view/widgets/post_widget.dart';
import 'package:smile/view/widgets/profile_circle_avatar.dart';
import 'package:smile/view/widgets/video_thumbnail_widget.dart';
import 'package:smile/view_model/auth_view_model.dart';
import 'package:smile/view_model/post_view_model.dart';
import 'package:smile/view_model/user_view_model.dart';
import 'package:smile/view_model/video_view_model.dart';

class UserPage extends StatelessWidget {
  const UserPage({Key? key, required this.userId}) : super(key: key);
  final String userId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<UserModel?>(
          future: UserFireStore().getUser(userId),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text('Error'.tr),
              );
            } else if (!snapshot.hasData) {
              return Center(
                child: Text('Loading'.tr),
              );
            } else if (snapshot.data == null) {
              return const Center(
                child: Text('Not Found page'),
              );
            } else {
              UserModel user = snapshot.data!;
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ProfileCircleAvatar(
                              imageUrl: user.profileUrl,
                              radius: MediaQuery.of(context).size.width * 0.16),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                user.name ?? '',
                                style: TextStyle(
                                  fontSize: 24,
                                  overflow: TextOverflow.clip,
                                ),
                                maxLines: 2,
                              ),
                              Text(user.username ?? ' ',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.grey,
                                    overflow: TextOverflow.clip,
                                  )),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        StreamBuilder<int>(
                            stream: userViewModel.getFollowingsNum(userId),
                            builder: (context, snapshot) {
                              if (snapshot.hasError || !snapshot.hasData) {
                                return _item(
                                  context: context,
                                  num: '0',
                                  text: 'Followings'.tr,
                                );
                              }
                              return _item(
                                context: context,
                                num: '${snapshot.data!}',
                                text: 'Followings'.tr,
                              );
                            }),
                        StreamBuilder<int>(
                            stream: userViewModel.getFollowersNum(userId),
                            builder: (context, snapshot) {
                              if (snapshot.hasError || !snapshot.hasData) {
                                return _item(
                                  context: context,
                                  num: '0 ',
                                  text: 'Followers'.tr,
                                );
                              }
                              return _item(
                                context: context,
                                num: '${snapshot.data!}',
                                text: 'Followers'.tr,
                              );
                            }),
                        StreamBuilder<bool>(
                            stream: UserViewModel().isFollowing(userId),
                            builder: (context, snapshot) {
                              if (snapshot.hasError ||
                                  !snapshot.hasData ||
                                  userId ==
                                      Get.find<AuthViewModel>()
                                          .currentUser!
                                          .id) {
                                return Container();
                              }
                              return (snapshot.data!)
                                  ? OutlinedButton(
                                      onPressed: () {
                                        if (Get.find<AuthViewModel>()
                                            .currentUser!
                                            .isAnonymous!) {
                                          Get.to(SignInPage(),
                                              transition: Transition.downToUp);
                                        } else
                                          UserViewModel()
                                              .unFollow(userId: userId);
                                      },
                                      child: Text('UnFollow'.tr))
                                  : OutlinedButton(
                                      onPressed: () {
                                        if (Get.find<AuthViewModel>()
                                            .currentUser!
                                            .isAnonymous!) {
                                          Get.to(SignInPage(),
                                              transition: Transition.downToUp);
                                        } else
                                          UserViewModel()
                                              .follow(userId: userId);
                                      },
                                      child: Text('Follow'.tr));
                            })
                      ],
                    ),
                  ),
                  Expanded(
                    // height: MediaQuery.of(context).size.height -
                    //     (MediaQuery.of(context).padding.vertical +
                    //         MainNavigatorBar.height +
                    //         appBarHeight +
                    //         16),
                    child: DefaultTabController(
                        length: 2,
                        child: Center(
                          child: Column(children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TabBar(
                                isScrollable: false,
                                tabs: [
                                  Tab(
                                    child: Text('Videos'.tr),
                                  ),
                                  Tab(
                                    child: Text('Posts'.tr),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                                child: TabBarView(
                              physics: const NeverScrollableScrollPhysics(),
                              children: [
                                _videosTab(),
                                _postsTab(),
                              ],
                            )),
                          ]),
                        )),
                  )
                ],
              );
            }
          }),
    );
  }

  Widget _item({
    required BuildContext context,
    required String num,
    required String text,
    //  required Function() onTab
  }) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.25,
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        title:
            Center(child: FittedBox(fit: BoxFit.scaleDown, child: Text(num))),
        subtitle:
            Center(child: FittedBox(fit: BoxFit.scaleDown, child: Text(text))),
      ),
    );
  }

  Widget _videosTab() {
    return StreamBuilder<List<VideoModel>>(
        stream: VideoViewModel().getUserVideos(userId),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          } else if (!snapshot.hasData) {
            return Text('Loading...'.tr);
          } else {
            List<VideoModel> videosModels = snapshot.data!;
            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 150,
                  mainAxisSpacing: 2,
                  crossAxisSpacing: 2),
              itemCount: videosModels.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                    onTap: () {
                      Get.to(
                          UserVideosPage(
                              initialIndex: index, videos: videosModels),
                          transition: Transition.zoom);
                    },
                    child: VideoThumbnailWidget(url: videosModels[index].url!));
              },
            );
          }
        });
  }

  Widget _postsTab() {
    return StreamBuilder<List<PostModel>>(
      stream:
          PostViewModel().getUserPosts(userId: authViewModel.currentUser!.id!),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Container();
        } else if (!snapshot.hasData) {
          return Center(
            child: Text('Loading...'.tr),
          );
        } else {
          List<PostModel> posts = snapshot.data!;
          return ListView.builder(
            itemCount: posts.length,
            itemBuilder: (context, index) {
              return PostWidget(postId: posts[index].postId!);
            },
          );
        }
      },
    );
  }
}
