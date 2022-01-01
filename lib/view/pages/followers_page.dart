import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smile/model/user_model.dart';
import 'package:smile/view/pages/user_page.dart';
import 'package:smile/view/widgets/profile_circle_avatar.dart';
import 'package:smile/view_model/auth_view_model.dart';
import 'package:smile/view_model/user_view_model.dart';

class FollowersPage extends StatelessWidget {
  FollowersPage({Key? key, required this.initialIndex}) : super(key: key);
  final UserViewModel userViewModel = Get.find<UserViewModel>();
  final int initialIndex;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      initialIndex: initialIndex,
      child: Scaffold(
        appBar: AppBar(
          title: Text(userViewModel.currentUser.name ?? ''),
          bottom: TabBar(
            tabs: [
              StreamBuilder<int>(
                  stream: userViewModel.getFollowingsNum(
                      Get.find<AuthViewModel>().currentUser!.id!),
                  builder: (context, snapshot) {
                    if (snapshot.hasError || !snapshot.hasData) {
                      return Tab(
                        text: '0 ' + 'Followings'.tr,
                      );
                    }
                    return Tab(
                      text: '${snapshot.data} ' + 'Followings'.tr,
                    );
                  }),
              StreamBuilder<int>(
                  stream: userViewModel.getFollowersNum(
                      Get.find<AuthViewModel>().currentUser!.id!),
                  builder: (context, snapshot) {
                    if (snapshot.hasError || !snapshot.hasData) {
                      return Tab(
                        text: '${snapshot.data} ' 'Followers'.tr,
                      );
                    }
                    return Tab(
                      text: '${snapshot.data} ' 'Followers'.tr,
                    );
                  }),
              Tab(
                text: 'Suggested'.tr,
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Tab(
              child: StreamBuilder<List<Future<UserModel?>>>(
                stream: userViewModel.getUserFollowings(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Text(snapshot.error.toString()),
                    );
                  } else if (!snapshot.hasData) {
                    return Text('Loading...'.tr);
                  } else {
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        return FollowingWidget(
                            futureUser: snapshot.data![index]);
                      },
                    );
                  }
                },
              ),
            ),
            Tab(
              child: StreamBuilder<List<Future<UserModel?>>>(
                stream: userViewModel.getUserFollowers(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Text(snapshot.error.toString()),
                    );
                  } else if (!snapshot.hasData) {
                    return Text('Loading...'.tr);
                  } else {
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        return FollowerWidget(
                            futureUser: snapshot.data![index]);
                      },
                    );
                  }
                },
              ),
            ),
            suggestedTab(),
          ],
        ),
      ),
    );
  }

  Widget suggestedTab() {
    return Tab(
      child: StreamBuilder<Stream<List<UserModel>>>(
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

class FollowerWidget extends StatelessWidget {
  const FollowerWidget({Key? key, required this.futureUser}) : super(key: key);
  final Future<UserModel?> futureUser;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserModel?>(
        future: futureUser,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Container();
          } else if (!snapshot.hasData) {
            return const ListTile(
              leading: ProfileCircleAvatar(
                imageUrl: '',
                radius: 50,
              ),
            );
          } else {
            UserModel user = snapshot.data!;
            return ListTile(
              leading: ProfileCircleAvatar(
                imageUrl: user.profileUrl,
                radius: 30,
              ),
              title: Text(user.name ?? ''),
              subtitle: Text(user.username ?? ''),
              trailing: PopupMenuButton(
                child: const Icon(Icons.more_vert),
                itemBuilder: (context) {
                  return [
                    PopupMenuItem(
                        child: ListTile(
                      leading: const Icon(Icons.remove_circle_outline),
                      title: Text('Remove this Follower'.tr),
                      onTap: () {
                        Get.back();
                      },
                    )),
                    PopupMenuItem(
                        child: ListTile(
                      leading: const Icon(Icons.add_circle_outline),
                      title: Text('Follow back'.tr),
                      onTap: () {
                        UserViewModel().follow(userId: user.id!);
                        Get.back();
                      },
                    )),
                  ];
                },
              ),
              onTap: () {
                Get.to(UserPage(
                  userId: user.id!,
                ));
              },
            );
          }
        });
  }
}

class FollowingWidget extends StatelessWidget {
  const FollowingWidget({Key? key, required this.futureUser}) : super(key: key);
  final Future<UserModel?> futureUser;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserModel?>(
        future: futureUser,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Container();
          } else if (!snapshot.hasData) {
            return const ListTile(
              leading: ProfileCircleAvatar(
                imageUrl: '',
                radius: 50,
              ),
            );
          } else {
            UserModel user = snapshot.data!;
            return ListTile(
              dense: true,
              leading: ProfileCircleAvatar(
                imageUrl: user.profileUrl,
                radius: 30,
              ),
              title: Text(user.name ?? ''),
              subtitle: Text(user.username ?? ''),
              trailing: PopupMenuButton(
                child: const Icon(Icons.more_vert),
                itemBuilder: (context) {
                  return [
                    PopupMenuItem(
                        child: ListTile(
                      leading: const Icon(Icons.remove_circle_outline),
                      title: Text('UnFollow'.tr),
                      onTap: () {
                        UserViewModel().unFollow(userId: user.id!);
                        Get.back();
                      },
                    )),
                  ];
                },
              ),
              onTap: () {
                Get.to(UserPage(
                  userId: user.id!,
                ));
              },
            );
          }
        });
  }
}

class SuggestedWidget extends StatelessWidget {
  const SuggestedWidget({Key? key, required this.user}) : super(key: key);
  final UserModel user;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: ProfileCircleAvatar(
        imageUrl: user.profileUrl,
        radius: 20,
      ),
      title: Text(user.name ?? ' '),
      subtitle: Text(user.username ?? ' '),
      trailing: OutlinedButton(
        onPressed: () {
          UserViewModel().follow(userId: user.id!);
        },
        child: Text('Follow'.tr),
      ),
    );
  }
}
