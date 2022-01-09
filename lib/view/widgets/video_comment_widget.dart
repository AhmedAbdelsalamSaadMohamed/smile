import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:smile/model/user_model.dart';
import 'package:smile/model/video_comment_model.dart';
import 'package:smile/view/pages/sign_in_page.dart';
import 'package:smile/view/pages/video_replaies_page.dart';
import 'package:smile/view/widgets/profile_circle_avatar.dart';
import 'package:smile/view_model/auth_view_model.dart';
import 'package:smile/view_model/comment_view_model.dart';
import 'package:smile/view_model/user_view_model.dart';
import 'package:smile/view_model/video_comment_view_model.dart';
import 'package:smile/view_model/video_replay_view_model.dart';

import 'custom_image_network.dart';

class VideoCommentWidget extends StatelessWidget {
  VideoCommentWidget({Key? key, required this.comment}) : super(key: key);
  Rx<File> image = File('null').obs, video = File('null').obs;
  RxBool wait = false.obs;
  final VideoCommentModel comment;
  RxInt lovesCount = 0.obs;
  RxBool isLove = false.obs;

  @override
  Widget build(BuildContext context) {
    lovesCount.value = comment.loves == null ? 0 : comment.loves!.length;
    isLove.value = comment.loves == null
        ? false
        : comment.loves!.contains(Get.find<AuthViewModel>().currentUser!.id);
    UserModel? commentOwner;
    return Card(
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        elevation: 0,
        child: FutureBuilder(
            future: UserViewModel().getUser(userId: comment.owner!),
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data != null) {
                commentOwner = snapshot.data as UserModel?;
              }
              return ListTile(
                leading: ProfileCircleAvatar(
                  imageUrl:
                  commentOwner != null ? commentOwner!.profileUrl! : '',
                  radius: 20,
                ),
                title: SizedBox(
                  width: double.infinity,
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          // width: MediaQuery.of(context).size.width-170,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            // color: Colors.grey.shade300,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                (snapshot.hasData)
                                    ? (snapshot.data as UserModel).name!
                                    : 'User',
                                // size: 15,
                                // weight: FontWeight.bold,
                              ),
                              Text(
                                DateFormat('MMM-dd – kk:mm').format(
                                    DateTime.fromMicrosecondsSinceEpoch(
                                        comment.time!.microsecondsSinceEpoch)),
                                // size: 11,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                comment.text ?? '  ',
                                overflow: TextOverflow.clip,
                                maxLines: null,
                                // size: 14,
                              ),
                              comment.image == null
                                  ? Container()
                                  : SizedBox(
                                  width: MediaQuery.of(context).size.width *
                                      0.6,
                                  child: CustomImageNetwork(
                                      src: comment.image!)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 200,
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Obx(
                                    () => Text('$lovesCount'),
                              ),
                              Obx(() => IconButton(
                                  padding: const EdgeInsets.all(0),
                                  onPressed: () {
                                    if (Get.find<AuthViewModel>()
                                        .currentUser!
                                        .isAnonymous!) {

                                      Get.to(SignInPage(),
                                          transition: Transition.downToUp);
                                    } else{
                                      if (isLove.value) {
                                        isLove.value = false;
                                        lovesCount--;
                                      } else {
                                        isLove.value = true;
                                        lovesCount++;
                                      }
                                      VideoCommentViewModel().loveOrNotComment(
                                          videoId: comment.videoId!,
                                          commentId: comment.id!,
                                          love: isLove.value);}
                                  },
                                  icon: isLove.value
                                      ? const Icon(
                                    Icons.favorite,
                                    color: Colors.red,
                                  )
                                      : const Icon(Icons.favorite_border))),
                              const SizedBox(width: 30),
                              GestureDetector(
                                  onTap: () {
                                    Get.to(
                                            () => VideoRepliesScreen(comment: comment));
                                  },
                                  child:
                                  StreamBuilder<int>(
                                      stream: VideoReplyViewModel()
                                          .getRepliesCount(
                                          videoId: comment.videoId!,
                                          commentId: comment.id!),
                                      builder: (context, snapshot) {
                                        if(snapshot.hasError || !snapshot.hasData){
                                          return Text(
                                            'Replay'.tr,
                                            // size: 14,
                                          );
                                        }
                                  return Text(
                                    '${snapshot.data!} '
                                    'Replay'.tr,
                                  );})),
                            ]),
                      ),
                    ]),
              );
            }));
  }

}
