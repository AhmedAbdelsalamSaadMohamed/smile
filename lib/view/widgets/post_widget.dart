import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:smile/model/post_model.dart';
import 'package:smile/model/user_model.dart';
import 'package:smile/view/pages/comments_screen.dart';
import 'package:smile/view/pages/sign_in_page.dart';
import 'package:smile/view/pages/user_page.dart';
import 'package:smile/view/widgets/profile_circle_avatar.dart';
import 'package:smile/view_model/auth_view_model.dart';
import 'package:smile/view_model/post_view_model.dart';
import 'package:smile/view_model/user_view_model.dart';

import 'custom_image_network.dart';
import 'image_galery_widget.dart';

class PostWidget extends StatelessWidget {
  PostWidget({Key? key, required this.postId}) : super(key: key) {
    postController = Get.put(PostViewModel.byTag(postId), tag: postId);
  }

  final String postId;
  int count = 0;
  UserModel currentUser = Get.find<AuthViewModel>().currentUser!;
  late PostViewModel postController;

  @override
  Widget build(BuildContext context) {
    return Obx(() => Card(
          margin: const EdgeInsets.symmetric(vertical: 10),
          child: Column(
            children: [
              /// header
              FutureBuilder<UserModel>(
                  future: UserViewModel()
                      .getUser(userId: postController.post.value.ownerId!),
                  builder: (context, snapshot) {
                    // if (snapshot.hasError) {
                    //   return Text(snapshot.error!.toString()+'Error'.tr);
                    // }
                    if (snapshot.hasError || !snapshot.hasData) {
                      /// loading widget
                      return Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: GestureDetector(
                              child: const ProfileCircleAvatar(
                                imageUrl: '',
                                radius: 20,
                              ),
                            ),
                          ),
                          Container(
                            width: 100,
                            height: 20,
                            decoration: BoxDecoration(
                                color: Colors.grey,
                                borderRadius: BorderRadius.circular(20)),
                          ),
                        ],
                      );
                    }
                    {
                      UserModel postOwner = snapshot.data!;
                      return Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: GestureDetector(
                              child: ProfileCircleAvatar(
                                imageUrl: postOwner.profileUrl,
                                radius: 20,
                              ),
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => ImageGalleryWidget(
                                      images: [postOwner.profileUrl!]),
                                );
                              },
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              GestureDetector(
                                child: Row(
                                  children: [
                                    Text(
                                      postOwner.name ?? ' ',
                                      // size: 16,
                                    ),
                                  ],
                                ),
                                onTap: () => Get.to(UserPage(
                                  userId: postOwner.id!,
                                )),
                              ),
                              Text(
                                postOwner.username ?? '@',
                                style: TextStyle(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .secondary
                                      .withOpacity(0.4),
                                  fontSize: 12,
                                ),
                              ),
                              Text(
                                postController.post.value.postTime == null
                                    ? '00:00'
                                    : DateFormat('MMM-dd – kk:mm').format(
                                        DateTime.fromMicrosecondsSinceEpoch(
                                            postController.post.value.postTime!
                                                .microsecondsSinceEpoch)),
                                textAlign: TextAlign.start,
                                style: const TextStyle(fontSize: 12),
                              )
                            ],
                          ),
                        ],
                      );
                    }
                  }),

              /// body text
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      postController.post.value.postText ?? ' ',
                    ),
                  ),
                ],
              ),

              /// images
              Container(
                  child: (postController.post.value.imagesUrls == null ||
                          postController.post.value.imagesUrls!.isEmpty)
                      ? null
                      : GestureDetector(
                          onTap: () {
                            showGallery(postController.post.value, context);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Wrap(
                              direction: Axis.horizontal,
                              alignment: WrapAlignment.start,
                              crossAxisAlignment: WrapCrossAlignment.start,
                              children: [
                                ...postController.post.value.imagesUrls!
                                    .map((e) {
                                  return Container(
                                    height: postController
                                                .post.value.imagesUrls![0] ==
                                            e
                                        ? MediaQuery.of(context).size.width - 8
                                        : 100,
                                    width: postController
                                                .post.value.imagesUrls![0] ==
                                            e
                                        ? 900
                                        : 100,
                                    padding: const EdgeInsets.all(8),
                                    child: CustomImageNetwork(src: e),
                                  );
                                })
                              ],
                            ),
                          ),
                        )),

              ///
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  GestureDetector(
                      onTap: () {},
                      child: Obx(() => Text(
                            postController.lovesCount.toString() +
                                (postController.lovesCount.value > 1
                                    ? 'Reactions'.tr
                                    : 'Reaction'.tr),
                            //color: Colors.grey,
                          ))),
                  GestureDetector(
                    onTap: () {
                      Get.to(CommentsScreen(
                        postId: postController.post.value.postId!,
                      ));
                    },
                    child: Obx(
                      () => Text(
                        postController.commentsCount.value.toString() +
                            (postController.commentsCount.value > 1
                                ? 'Comments'.tr
                                : 'Comment'.tr),
                        //color: Colors.grey
                      ),
                    ),
                  ),
                  GestureDetector(
                      onTap: () {
                        if (Get.find<AuthViewModel>()
                            .currentUser!
                            .isAnonymous!) {
                          Get.to(SignInPage(), transition: Transition.downToUp);
                        }
                      },
                      child: Text(
                        'Shares'.tr,
                        //color: Colors.grey
                      )),
                ],
              ),

              /// Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Obx(() => IconButton(
                      onPressed: () {
                        if (Get.find<AuthViewModel>()
                            .currentUser!
                            .isAnonymous!) {
                          Get.to(SignInPage(), transition: Transition.downToUp);
                        } else {
                          if (postController.isLove.value) {
                            postController.isLove.value = false;
                            //lovesCount--;
                          } else {
                            postController.isLove.value = true;
                            //postController.lovesCount++;
                          }
                          PostViewModel().loveOrNotPost(
                              postController.post.value.postId!,
                              postController.isLove.value);
                        }
                      },
                      icon: postController.isLove.value
                          ? const Icon(
                              Icons.favorite,
                              color: Colors.red,
                            )
                          : const Icon(Icons.favorite_border))),
                  IconButton(
                      onPressed: () {
                        Get.to(CommentsScreen(
                          postId: postController.post.value.postId!,
                        ));
                      },
                      icon: const Icon(Icons.comment_outlined)),
                  IconButton(
                      onPressed: () {}, icon: const Icon(Icons.share_rounded)),
                ],
              ),
            ],
          ),
        ));
  }

  void showGallery(PostModel post, context) {
    showDialog(
      context: context,
      builder: (context) {
        return ImageGalleryWidget(images: [...post.imagesUrls!]);
      },
    );
  }
}
