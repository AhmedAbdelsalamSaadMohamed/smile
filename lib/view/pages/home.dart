import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:preload_page_view/preload_page_view.dart';
import 'package:smile/model/user_model.dart';
import 'package:smile/model/video_model.dart';
import 'package:smile/view/pages/posts_page.dart';
import 'package:smile/view/pages/profile_page.dart';
import 'package:smile/view/pages/search_page.dart';
import 'package:smile/view/widgets/video_widget.dart';
import 'package:smile/view_model/auth_view_model.dart';
import 'package:smile/view_model/home_view_model.dart';
import 'package:smile/view_model/user_view_model.dart';
import 'package:smile/view_model/video_player_view_model.dart';
import 'package:smile/view_model/video_view_model.dart';

import 'followers_page.dart';
import 'user_page.dart';

enum tabs { forYou, followings, posts }

class Homepage extends StatefulWidget {
  Homepage({Key? key}) : super(key: key);
  final HomeViewModel homeViewModel = Get.find<HomeViewModel>();
  tabs tabIndex = tabs.forYou;
  Rx<VideoModel> video = VideoModel().obs;

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final PageController _pageController = PageController(keepPage: true);

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: _pageController,
      scrollDirection: Axis.horizontal,
      onPageChanged: (_) {
        Get.find<VideoPlayerViewModel>(tag: widget.video.value.id!)
            .videoPlayerController
            .value
            .pause();
      },
      children: [
        Stack(
          children: [
            widget.tabIndex == tabs.forYou
                ? _forYou2()
                : widget.tabIndex == tabs.followings
                    ? _followingTab()
                    : _postsTab(),
            SizedBox(
              height: 50,
              width: MediaQuery.of(context).size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {
                      setState(() {
                        Get.find<VideoPlayerViewModel>(
                                tag: widget.video.value.id)
                            .videoPlayerController
                            .value
                            .pause();
                        widget.tabIndex = tabs.posts;
                      });
                    },
                    child: Text(
                      'Posts'.tr,
                      style: TextStyle(
                          color: widget.tabIndex == tabs.posts
                              ? Colors.white
                              : Colors.grey,
                          fontSize: widget.tabIndex == tabs.posts ? 18 : 14,
                          fontWeight: widget.tabIndex == tabs.posts
                              ? FontWeight.bold
                              : FontWeight.normal),
                    ),
                  ),
                  Row(
                    children: [
                      TextButton(
                          onPressed: () {
                            setState(() {
                              Get.find<VideoPlayerViewModel>(
                                      tag: widget.video.value.id)
                                  .videoPlayerController
                                  .value
                                  .pause();
                              widget.tabIndex = tabs.followings;
                            });
                          },
                          child: Text(
                            'Following'.tr,
                            style: TextStyle(
                                color: widget.tabIndex == tabs.followings
                                    ? Colors.white
                                    : Colors.grey,
                                fontSize: widget.tabIndex == tabs.followings
                                    ? 18
                                    : 14,
                                fontWeight: widget.tabIndex == tabs.followings
                                    ? FontWeight.bold
                                    : FontWeight.normal),
                          )),
                      const VerticalDivider(
                        color: Colors.white,
                        width: 0,
                        indent: 15,
                        endIndent: 20,
                        thickness: 1.5,
                      ),
                      TextButton(
                          onPressed: () {
                            setState(() {
                              Get.find<VideoPlayerViewModel>(
                                      tag: widget.video.value.id)
                                  .videoPlayerController
                                  .value
                                  .pause();
                              widget.tabIndex = tabs.forYou;
                            });
                          },
                          child: Text(
                            'For You'.tr,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize:
                                    widget.tabIndex == tabs.forYou ? 18 : 14,
                                fontWeight: widget.tabIndex == tabs.forYou
                                    ? FontWeight.bold
                                    : FontWeight.normal),
                          )),
                    ],
                  ),
                  IconButton(
                      onPressed: () {
                        Get.find<VideoPlayerViewModel>(
                                tag: widget.video.value.id)
                            .videoPlayerController
                            .value
                            .pause();
                        Get.to(SearchPage(),
                            transition: Get.locale == const Locale('en')
                                ? Transition.rightToLeft
                                : Transition.leftToRight);
                      },
                      icon: const Icon(
                        Icons.search,
                        color: Colors.white,
                      )),
                ],
              ),
            ),
          ],
        ),
        widget.tabIndex != tabs.posts
            ? Obx(() => UserPage(
                  userId: widget.video.value.ownerId!,
                ))
            : null,
      ].whereType<Widget>().toList(),
    );
  }

  // Widget _forYouTab() {
  //   return FutureBuilder<int>(
  //       future: widget.homeViewModel.allVideos.then((value) => value.length),
  //       builder: (context, snapshot) {
  //         if (snapshot.hasError) {
  //           return Center(
  //             child: Text('Error'.tr),
  //           );
  //         } else if (!snapshot.hasData) {
  //           return Center(
  //             child: Text('Loading...'.tr),
  //           );
  //         } else {
  //           return Builder(builder: (context) {
  //             return Obx(() => PreloadPageView(
  //                   preloadPagesCount: 10,
  //                   scrollDirection: Axis.vertical,
  //                   controller: PreloadPageController(
  //                     initialPage: widget.homeViewModel.lastIndex,
  //                     keepPage: true,
  //                   ),
  //                   onPageChanged: (index) async {
  //                     widget.homeViewModel.lastIndex = index;
  //
  //                     /// pause before video
  //                     widget.homeViewModel.allVideos.then((videos) {
  //                       widget.video.value = videos[index];
  //
  //                       setState(() {
  //                         /// pause before video
  //                         Get.find<VideoPlayerViewModel>(
  //                                 tag: videos[index - 1].id)
  //                             .videoPlayerController
  //                             .value
  //                             .pause();
  //                       });
  //
  //                       /// pause after video
  //                       setState(() {
  //                         Get.find<VideoPlayerViewModel>(
  //                                 tag: videos[index + 1].id)
  //                             .videoPlayerController
  //                             .value
  //                             .pause();
  //                       });
  //
  //                       /// play video
  //                       setState(() {
  //                         Get.find<VideoPlayerViewModel>(tag: videos[index].id)
  //                             .videoPlayerController
  //                             .value
  //                             .play();
  //                       });
  //                     });
  //                     widget.homeViewModel
  //                         .getVideo(index: index, max: snapshot.data!);
  //                   },
  //                   children: [...widget.homeViewModel.widgets],
  //                   //allowImplicitScrolling: true,
  //                 ));
  //           });
  //         }
  //       });
  // }

  Widget _forYou2() {
    return FutureBuilder<List<VideoModel>>(
      future: VideoViewModel().getForYouVideos(),
      builder: (context, snapshot) {
        if (snapshot.hasError || !snapshot.hasData) {
          return Container();
        }
        return PreloadPageView.builder(
          itemCount: snapshot.data!.length,
          itemBuilder: (BuildContext context, int index) {
            if (widget.video.value.id == null) {
              widget.video.value = snapshot.data![index];
            }
            if (index == widget.homeViewModel.lastIndex) {
              return VideoWidget(
                  video: snapshot.data![widget.homeViewModel.lastIndex],
                  autoPlay: true);
            } else {
              return VideoWidget(video: snapshot.data![index], autoPlay: false);
            }
          },
          controller: PreloadPageController(
            initialPage: widget.homeViewModel.lastIndex,
            keepPage: true,
          ),
          preloadPagesCount: 7,
          scrollDirection: Axis.vertical,
          // pageSnapping: true,

          onPageChanged: (index) async {
            widget.homeViewModel.lastIndex = index;
            widget.video.value = snapshot.data![index];
            //  setState(
            // ()async {
            Get.find<VideoPlayerViewModel>(tag: snapshot.data![index].id)
                .videoPlayerController
                .value
                .play();
            if (index != 0) {
              Get.find<VideoPlayerViewModel>(tag: snapshot.data![index - 1].id)
                  .videoPlayerController
                  .value
                  .pause();
            }

            if (index != snapshot.data!.length - 1) {
              Get.find<VideoPlayerViewModel>(tag: snapshot.data![index + 1].id)
                  .videoPlayerController
                  .value
                  .pause();
            }
            // };
            //);
          },
        );
      },
    );
  }

  Widget _followingTab() {
    return (Get.find<AuthViewModel>().currentUser!.isAnonymous!)
        ? Anonymous()
        : Container(
            child: FutureBuilder<List<VideoModel>>(
              future: VideoViewModel().getFollowingVideos(),
              builder: (context, snapshot) {
                if (snapshot.hasError || !snapshot.hasData) {
                  return Container();
                }
                if (snapshot.data!.length == 0) {
                  return suggestedTab();
                }
                return PreloadPageView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (BuildContext context, int index) {
                    if (index == 0) {
                      widget.video.value = snapshot.data![0];
                    }
                    if (index == widget.homeViewModel.lastFollowingIndex) {
                      return VideoWidget(
                          video: snapshot
                              .data![widget.homeViewModel.lastFollowingIndex],
                          autoPlay: true);
                    } else {
                      return VideoWidget(
                          video: snapshot.data![index], autoPlay: false);
                    }
                  },
                  controller: PreloadPageController(
                    initialPage: widget.homeViewModel.lastFollowingIndex,
                    keepPage: true,
                  ),
                  preloadPagesCount: 7,
                  scrollDirection: Axis.vertical,
                  pageSnapping: true,
                  onPageChanged: (index) {
                    widget.homeViewModel.lastFollowingIndex = index;
                    widget.video.value = snapshot.data![index];
                    //  setState(()async {
                    Get.find<VideoPlayerViewModel>(
                            tag: snapshot.data![index].id)
                        .videoPlayerController
                        .value
                        .play();
                    if (index != 0) {
                      Get.find<VideoPlayerViewModel>(
                              tag: snapshot.data![index - 1].id)
                          .videoPlayerController
                          .value
                          .pause();
                    }

                    if (index != snapshot.data!.length - 1) {
                      Get.find<VideoPlayerViewModel>(
                              tag: snapshot.data![index + 1].id)
                          .videoPlayerController
                          .value
                          .pause();
                    }
                    // });
                  },
                );
              },
            ),
          );
  }

  Widget _postsTab() {
    return const Center(
      child: PostsPage(),
    );
  }

// @override
// void dispose() {
//   Get.find<VideoPlayerViewModel>(
//       tag: widget.video.value.id)
//       .videoPlayerController
//       .value
//       .pause();
//   super.dispose();
// }
  Widget suggestedTab() {
    return Scaffold(
      appBar: AppBar(),
      body: StreamBuilder<Stream<List<UserModel>>>(
          stream: UserViewModel().getAllSuggestedUsers(),
          builder: (context, snapshot) {
            if (snapshot.hasError || !snapshot.hasData) {
              return Container();
            }
            // List<UserModel> suggestedUsers = snapshot.data!;
            return StreamBuilder<List<UserModel>>(
                stream: snapshot.data!,
                builder: (context, snapshot) {
                  if (snapshot.hasError || !snapshot.hasData) {
                    return Container();
                  }
                  List<UserModel> suggestedUsers = snapshot.data!;
                  return ListView.builder(
                    itemCount: suggestedUsers.length,
                    itemBuilder: (context, index) {
                      return SuggestedWidget(user: suggestedUsers[index]);
                    },
                  );
                });
          }),
    );
  }
}
