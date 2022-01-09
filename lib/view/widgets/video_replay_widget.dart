import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:smile/model/reply_model.dart';
import 'package:smile/model/user_model.dart';
import 'package:smile/view/pages/sign_in_page.dart';
import 'package:smile/view/widgets/profile_circle_avatar.dart';
import 'package:smile/view_model/auth_view_model.dart';
import 'package:smile/view_model/user_view_model.dart';
import 'package:smile/view_model/video_replay_view_model.dart';

import 'custom_image_network.dart';

class VideoReplyWidget extends StatelessWidget {
  VideoReplyWidget({Key? key, required this.reply, required this.videoId})
      : super(key: key);
  Rx<File> image = File('null').obs, video = File('null').obs;
  RxBool wait = false.obs;
  final ReplyModel reply;
  RxInt lovesCount = 0.obs;
  RxBool isLove = false.obs;
  String videoId;

  @override
  Widget build(BuildContext context) {
    lovesCount.value = reply.loves == null ? 0 : reply.loves!.length;
    isLove.value = reply.loves == null
        ? false
        : reply.loves!.contains(Get.find<AuthViewModel>().currentUser!.id);
    UserModel? commentOwner;
    return Card(
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        elevation: 0,
        child: FutureBuilder(
            future: UserViewModel().getUser(userId: reply.owner!),
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data != null) {
                commentOwner = snapshot.data as UserModel?;
              }
              return ListTile(
                contentPadding: EdgeInsets.zero,
                leading: ProfileCircleAvatar(
                  imageUrl:
                      commentOwner != null ? commentOwner!.profileUrl! : '',
                  radius: 17,
                ),
                title: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            (snapshot.hasData)
                                ? (snapshot.data as UserModel).name!
                                : 'User',
                            // size: 13,
                            // weight: FontWeight.bold,
                          ),
                          Text(
                            DateFormat('MMM-dd – kk:mm').format(
                                DateTime.fromMicrosecondsSinceEpoch(
                                    reply.time!.microsecondsSinceEpoch)),
                            // size: 11,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            reply.text ?? '  ',
                            overflow: TextOverflow.clip,
                            maxLines: null,
                            // size: 12,
                          ),
                          reply.image == null
                              ? Container()
                              : SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.6,
                                  child: CustomImageNetwork(src: reply.image!)),
                        ],
                      ),
                    ),
                    Expanded(child: Container()),
                  ],
                ),
                subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 170,
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
                                    } else {
                                      if (isLove.value) {
                                        isLove.value = false;
                                        lovesCount--;
                                      } else {
                                        isLove.value = true;
                                        lovesCount++;
                                      }

                                      VideoReplyViewModel().loveOrNotReply(
                                          videoId: videoId,
                                          commentId: reply.commentId!,
                                          love: isLove.value,
                                          replyId: reply.id!);
                                    }
                                  },
                                  icon: isLove.value
                                      ? const Icon(
                                          Icons.favorite,
                                          color: Colors.red,
                                          size: 20,
                                        )
                                      : const Icon(
                                          Icons.favorite_border,
                                          size: 20,
                                        ))),
                              const SizedBox(width: 25),
                              // GestureDetector(
                              //     onTap: () {
                              //       // _reply(context);
                              //     },
                              //     child:
                              //            Text(
                              //
                              //             'Replay'.tr,
                              //             // size: 14,
                              //           )
                              //         ),
                            ]),
                      ),
                    ]),
              );
            }));
  }
}
