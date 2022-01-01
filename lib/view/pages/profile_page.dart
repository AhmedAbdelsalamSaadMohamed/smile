import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:smile/model/post_model.dart';
import 'package:smile/model/video_model.dart';
import 'package:smile/utils/constants.dart';
import 'package:smile/view/pages/favorites_page.dart';
import 'package:smile/view/pages/followers_page.dart';
import 'package:smile/view/pages/sign_in_page.dart';
import 'package:smile/view/pages/user_videos_page.dart';
import 'package:smile/view/widgets/new_post_wiget.dart';
import 'package:smile/view/widgets/post_widget.dart';
import 'package:smile/view/widgets/profile_circle_avatar.dart';
import 'package:smile/view/widgets/sign_in_buttom.dart';
import 'package:smile/view/widgets/up_route.dart';
import 'package:smile/view/widgets/video_thumbnail_widget.dart';
import 'package:smile/view_model/auth_view_model.dart';
import 'package:smile/view_model/post_view_model.dart';
import 'package:smile/view_model/settings_view_model.dart';
import 'package:smile/view_model/user_view_model.dart';
import 'package:smile/view_model/video_view_model.dart';

import 'add_video_page.dart';
import 'download_videos_page.dart';

final AuthViewModel authViewModel = Get.find<AuthViewModel>();
final UserViewModel userViewModel = Get.put(UserViewModel(), permanent: true);
const double appBarHeight = 50;

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(appBarHeight),
        child: AppBar(
          title:  Text('Profile'.tr),
        ),
      ),
      drawer: const MyDrawer(),
      body: (authViewModel.currentUser == null ||
              authViewModel.currentUser!.isAnonymous!)
          ? const Anonymous()
          : const Body(),
    );
  }
}

class Anonymous extends StatelessWidget {
  const Anonymous({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.person_outline,
              size: 150,
              color: Colors.grey,
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text('Sign up for an account'.tr),
            ),
            OutlinedButton(
              onPressed: () {
                Get.to(SignInPage(),transition: Transition.downToUp);
                // Navigator.of(context)
                //     .push(DirecteRoute(SignUPDialog(), routeDirection.up));
              },
              child: Text('Sign Up'.tr + ' / ' + 'Sign In'.tr),
              style: ButtonStyle(
                  fixedSize: MaterialStateProperty.all(Size(
                      MediaQuery.of(context).size.width * 0.6,
                      double.infinity))),
            )
          ],
        ),
      ),
    );
  }
}

class Body extends StatelessWidget {
  const Body({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          child: Row(children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: ProfileCircleAvatar(
                  imageUrl: authViewModel.currentUser?.profileUrl,
                  radius: MediaQuery.of(context).size.width * 0.16),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    authViewModel.currentUser?.name ?? '',
                    style: TextStyle(
                      fontSize: 24,
                      overflow: TextOverflow.clip,
                    ),
                    maxLines: 1,
                  ),
                  Text(authViewModel.currentUser!.username ?? ' ',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey,
                        overflow: TextOverflow.clip,
                      )),
                ],
              ),
            ),
          ]),
        ),

        //  const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              StreamBuilder<int>(
                  stream: userViewModel
                      .getFollowingsNum(authViewModel.currentUser!.id!),
                  builder: (context, snapshot) {
                    if (snapshot.hasError || !snapshot.hasData) {
                      return _item(
                        context: context,
                        num: '0',
                        text: 'Followings'.tr,
                        onTab: () {
                          Get.to(FollowersPage(initialIndex: 0),
                              transition: Transition.downToUp);
                        },
                      );
                    }
                    return _item(
                      context: context,
                      num: '${snapshot.data!}',
                      text: 'Followings'.tr,
                      onTab: () {
                        Get.to(FollowersPage(initialIndex: 0),
                            transition: Transition.downToUp);
                      },
                    );
                  }),
              StreamBuilder<int>(
                  stream: userViewModel
                      .getFollowersNum(authViewModel.currentUser!.id!),
                  builder: (context, snapshot) {
                    if (snapshot.hasError || !snapshot.hasData) {
                      return _item(
                        context: context,
                        num: '0 ',
                        text: 'Followers'.tr,
                        onTab: () {
                          Get.to(FollowersPage(initialIndex: 1),
                              transition: Transition.downToUp);
                        },
                      );
                    }
                    return _item(
                      context: context,
                      num: '${snapshot.data!}',
                      text: 'Followers'.tr,
                      onTab: () {
                        Get.to(FollowersPage(initialIndex: 1),
                            transition: Transition.downToUp);
                      },
                    );
                  }),
              _item(
                context: context,
                num: ' ',
                text: 'Suggested'.tr,
                onTab: () {
                  Get.to(FollowersPage(initialIndex: 2),
                      transition: Transition.downToUp);
                },
              ),
              IconButton(
                  onPressed: () {
                    Get.to(FavoritesPage());
                  },
                  icon: const Icon(Icons.bookmark_border_outlined)),
            ],
          ),
        ),
        Expanded(
          child: DefaultTabController(
              length: 3,
              child: Center(
                child: Column(children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TabBar(
                      tabs: [
                        Tab(
                          child: Text('Videos'.tr),
                        ),
                        Tab(
                          child: Text('Posts'.tr),
                        ),
                        const Tab(
                          child: Icon(Icons.download_rounded),
                        ),
                      ],
                      isScrollable: false,
                    ),
                  ),
                  Expanded(
                      child: TabBarView(
                    children: [
                      _videosTab(),
                      _postsTab(),
                      _downloadsTab(),
                    ],
                  )),
                ]),
              )),
        )
      ],
    );
  }

  Widget _item(
      {required BuildContext context,
      required String num,
      required String text,
      required Function() onTab}) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.25,
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        title:
            Center(child: FittedBox(fit: BoxFit.scaleDown, child: Text(num))),
        subtitle:
            Center(child: FittedBox(fit: BoxFit.scaleDown, child: Text(text))),
        onTap: onTab,
      ),
    );
  }

  Widget _videosTab() {
    return StreamBuilder<List<VideoModel>>(
        stream:
            VideoViewModel().getUserVideos(VideoViewModel().currentUser.id!),
        builder: (context, snapshot) {
          if (snapshot.hasError || !snapshot.hasData) {
            return Container();
          } else if (snapshot.data!.isEmpty) {
            return Column(
              children: [
                const SizedBox(
                  height: 50,
                ),
                Center(
                  child: OutlinedButton(
                    child:  Text('Upload your first Video'.tr),
                    onPressed: () {
                      Get.to(
                        const AddVideoPage(),
                      );
                    },
                  ),
                ),
              ],
            );
          } else {
            List<VideoModel> videosModels = snapshot.data!;
            return GridView.builder(
              // physics: ScrollPhysics ,
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 150,
                  mainAxisSpacing: 2,
                  crossAxisSpacing: 2),
              itemCount: videosModels.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  child: VideoThumbnailWidget(url: videosModels[index].url!),
                  onTap: () {
                    Get.to(
                        UserVideosPage(
                            initialIndex: index, videos: videosModels),
                        transition: Transition.zoom);
                  },
                  onLongPress: () {
                    showVideoEditBottomSheet();
                  },
                );
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
        if (snapshot.hasError || !snapshot.hasData) {
          return NewPostWidget(
            showProfile: true,
          );
        } else {
          List<PostModel> posts = snapshot.data!;
          return ListView.builder(
            itemCount: posts.length + 1,
            itemBuilder: (context, index) {
              if (index == 0) {
                return NewPostWidget(
                  showProfile: true,
                );
              } else {
                return PostWidget(postId: posts[index - 1].postId!);
              }
            },
          );
        }
      },
    );

  }

  _downloadsTab() {
    return FutureBuilder<Directory>(
      future: getApplicationDocumentsDirectory(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Container();
        } else if (!snapshot.hasData) {
          return Center(
            child: Text('Loading...'.tr),
          );
        }
        Directory appDocDir = snapshot.data!;
        Directory(appDocDir.path + '/$collectionVideos').createSync();
        List<FileSystemEntity> savedVideos =
            Directory(appDocDir.path + '/$collectionVideos').listSync();
        savedVideos.forEach((element) {
          if (!element.isAbsolute) {
            savedVideos.remove(element);
          }
        });
        return GridView.builder(
          // physics: ScrollPhysics ,
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 150, crossAxisSpacing: 5, mainAxisSpacing: 5),
          itemCount: savedVideos.length,
          itemBuilder: (context, index) {
            return GestureDetector(
                onTap: () {
                  Get.to(
                      DownloadVideosPage(
                        initialIndex: index,
                        videosPaths: [...savedVideos.map((e) => e.path)],
                      ),
                      transition: Transition.zoom);
                },
                child: VideoThumbnailWidget(url: savedVideos[index].path));
          },
        );
      },
    );
    //Directory appDocDir = await getApplicationDocumentsDirectory();
    // Stream<FileSystemEntity> savedVideos = Directory(appDocDir.path).list();
  }
  showVideoEditBottomSheet() {
    Get.bottomSheet(BottomSheet(
      onClosing: () {},
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit_rounded),
              title: Text('Edit'.tr),
              onTap: () {
                // FireStorageService().downloadVideo(widget.video);
                Get.back();
              },
            ),
            // StreamBuilder<bool>(
            //     stream: VideoViewModel().isFavorite(videoId: widget.video.id!),
            //     builder: (context, snapshot) {
            //       if (snapshot.hasError || !snapshot.hasData) {
            //         return Text('');
            //       }
            //       bool isFavorite = snapshot.data!;
            //       return ListTile(
            //         leading: isFavorite
            //             ? const Icon(Icons.bookmark_remove_outlined)
            //             : const Icon(Icons.bookmark_border_outlined),
            //         title: isFavorite
            //             ? Text('Remove from Favorites'.tr)
            //             : Text('Add to Favorites'.tr),
            //         onTap: () {
            //           setState(() {
            //             isFavorite
            //                 ? VideoViewModel()
            //                 .unFavoriteVideo(widget.video.id!)
            //                 : VideoViewModel()
            //                 .favoriteVideo(widget.video.id!);
            //             isFavorite = !isFavorite;
            //           });
            //         },
            //       );
            //     }),
            ListTile(
              leading: const Icon(Icons.delete),
              title: Text('Delete'),
              onTap: () {
                Get.dialog(Dialog(
                  elevation: 0,
                  child: SizedBox(
                    height: 200,
                    child: ListView(children: [
                      Text('Delete This Video'.tr),
                      Row(
                        children: [
                          OutlinedButton(onPressed: (){}, child: Text('Yes'.tr)),
                          OutlinedButton(onPressed: (){}, child: Text('No'.tr)),
                        ],
                      ),
                    ],),
                  ),

                ));
              },
            ),
            // ListTile(
            //   leading: const Icon(Icons.do_disturb_alt_rounded),
            //   title: Text('Not Interested'.tr),
            //   onTap: () {},
            // ),
          ],
        );
      },
    ));
  }
}

class MyDrawer extends StatelessWidget {
  const MyDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.secondary,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Settings'.tr,
        ),
      ),
      body: ListView(
        children: [
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  MenuItem(
                    icon: const Icon(
                      Icons.person_outlined,
                    ),
                    text: 'My Account'.tr,
                    onTap: () {
                      Get.back();
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: (authViewModel.currentUser == null ||
                            authViewModel.currentUser!.isAnonymous!)
                        ? ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).push(DirecteRoute(
                                  SignUPDialog(), routeDirection.up));
                            },
                            child: Text('Sing Up'.tr),
                            style: ButtonStyle(
                                padding: MaterialStateProperty.all(
                                    EdgeInsets.all(8.0))),
                          )
                        : Container(),
                  )
                ],
              ),
              MenuItem(
                icon: const Icon(Icons.lock_outlined),
                text: 'Privacy'.tr,
                onTap: () {},
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  MenuItem(
                      icon: const Icon(Icons.language),
                      text: 'Language'.tr,
                      onTap: () {}),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GetBuilder<SettingsViewModel>(builder: (settings) {
                      return Obx(() => DropdownButton<String>(
                              iconSize: 0,
                              elevation: 0,
                              value: settings.language.value,
                              onChanged: (value) {
                                settings.changeLanguage(value!);
                              },
                              items: const [
                                DropdownMenuItem(
                                  child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text('English'),
                                  ),
                                  value: 'en',
                                ),
                                DropdownMenuItem(
                                  child: Text('العربية'),
                                  value: 'ar',
                                ),
                              ]));
                    }),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  MenuItem(
                      icon: const Icon(Icons.dark_mode_outlined),
                      text: 'Dark Mode'.tr,
                      onTap: () {}),
                  GetBuilder<SettingsViewModel>(builder: (themeViewModel) {
                    return Obx(() => Switch(
                          value: themeViewModel.isDark.value,
                          onChanged: (newValue) {
                            if(newValue) {
                              Get.changeThemeMode(ThemeMode.dark);

                            }
                            else {
                              Get.changeThemeMode(ThemeMode.light);
                            }
                            themeViewModel.changeTheme(newValue);
                          },
                        ));
                  }),
                ],
              ),
              MenuItem(
                  icon: const Icon(Icons.logout),
                  text: 'Sign Out'.tr,
                  onTap: () {
                    authViewModel.signOut();
                  })
            ],
          )
        ],
      ),
    );
  }
}

class MenuItem extends StatelessWidget {
  const MenuItem(
      {Key? key, required this.icon, required this.text, required this.onTap})
      : super(key: key);
  final Icon icon;
  final String text;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: onTap,
        child: Row(
          children: [
            icon,
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(text),
            ),
          ],
        ),
      ),
    );
  }
}

class SignUPDialog extends StatelessWidget {
  const SignUPDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'.tr + ' / ' + 'Sign In'.tr),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Text('ddd'),
            SignInButton(
              onPressed: () {
                authViewModel.signInByGoogle();
              },
              text: 'Sign In by google'.tr,
              imageUrl: 'assets/images/google.png',
            ),
            const SizedBox(
              height: 16,
            ),
            SignInButton(
              onPressed: () {
                authViewModel.signInByFacebook();
              },
              text: 'Sign In by Facebook'.tr,
              imageUrl: 'assets/images/facebook.png',
            ),
          ],
        ),
      ),
    );
  }

}
