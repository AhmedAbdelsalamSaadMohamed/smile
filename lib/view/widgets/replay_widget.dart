import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:smile/model/reply_model.dart';
import 'package:smile/model/user_model.dart';
import 'package:smile/view/pages/sign_in_page.dart';
import 'package:smile/view/widgets/profile_circle_avatar.dart';
import 'package:smile/view_model/auth_view_model.dart';
import 'package:smile/view_model/reply_view_model.dart';
import 'package:smile/view_model/user_view_model.dart';

import 'custom_image_network.dart';

class ReplyWidget extends StatelessWidget {
  ReplyWidget({Key? key, required this.reply, required this.postId})
      : super(key: key);
  Rx<File> image = File('null').obs, video = File('null').obs;
  RxBool wait = false.obs;
  final ReplyModel reply;
  RxInt lovesCount = 0.obs;
  RxBool isLove = false.obs;
  String postId;

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
                                    } else{
                                    if (isLove.value) {
                                      isLove.value = false;
                                      lovesCount--;
                                    } else {
                                      isLove.value = true;
                                      lovesCount++;
                                    }

                                    ReplyViewModel().loveOrNotReply(
                                        postId: postId,
                                        commentId: reply.commentId!,
                                        love: isLove.value,
                                        replyId: reply.id!);}
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
                              GestureDetector(
                                  onTap: () {
                                    // _reply(context);
                                  },
                                  child: Text(
                                    'Replay'.tr,
                                    // size: 14,
                                  )),
                            ]),
                      ),
                    ]),
              );
            }));
  }

// void _reply(context) {
//   GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//   String? replyText;
//   showDialog(
//     context: context,
//     builder: (context) {
//       return Dialog(
//         insetPadding: const EdgeInsets.symmetric(horizontal: 1),
//         backgroundColor: Colors.transparent,
//         child: Row(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Padding(
//                 padding: EdgeInsets.all(8),
//                 child: ProfileCircleAvatar(
//                     imageUrl: '', radius: 20, gender: 'male')),
//             Expanded(
//               child: Container(
//                 padding: const EdgeInsets.all(2.0),
//                 child: Form(
//                   key: _formKey,
//                   child: TextFormField(
//                     keyboardType: TextInputType.multiline,
//                     maxLines: null,
//                     validator: (value) {
//                       if (value == null) {
//                         return 'Can\'t Publish Empty Comment'.tr;
//                       }
//                     },
//                     onSaved: (newValue) {
//                       replyText == newValue;
//                     },
//                     decoration: InputDecoration(
//                         border: InputBorder.none,
//                         prefixIcon: _addReplyImage(),
//                         suffixIcon: IconButton(
//                             onPressed: () {
//                               _formKey.currentState!.save();
//
//                               if (_formKey.currentState!.validate()) {
//                                 // CommentViewModel()
//                                 //     .publishComment(
//                                 //     postId: post.postId!, text: replyText)
//                                 //     .then((value) =>
//                                 //     Get.off(CommentsScreen(post: post)));
//
//                               }
//                             },
//                             icon: const Icon(Icons.send)),
//                         hintText: ' Write a comment...'),
//                   ),
//                 ),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   border: Border.all(color: primaryColor),
//                   borderRadius: BorderRadius.circular(30),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       );
//     },
//   );
// }

// Widget _addReplyImage() {
//   return PopupMenuButton(
//       itemBuilder: (context) => [
//         PopupMenuItem(
//             child: const Icon(
//               Icons.image,
//               size: 30,
//               color: Colors.grey,
//             ),
//             onTap: () {
//               Future<XFile?> xFile =
//               ImagePicker().pickImage(source: ImageSource.gallery);
//               xFile.then((value) {
//                 if (value != null) {
//                   image.value = File(value.path);
//                   video.value = File('null');
//                 }
//               });
//             }),
//         PopupMenuItem(
//             child: const Icon(
//               Icons.camera_alt,
//               size: 30,
//               color: Colors.grey,
//             ),
//             onTap: () {
//               Future<XFile?> xFile =
//               ImagePicker().pickImage(source: ImageSource.camera);
//               xFile.then((value) {
//                 if (value != null) {
//                   image.value = File(value.path);
//                   video.value = File('null');
//                 }
//               });
//             }),
//         PopupMenuItem(
//             child: const Icon(
//               Icons.video_camera_back,
//               size: 30,
//               color: Colors.grey,
//             ),
//             onTap: () {
//               Future<XFile?> xFile =
//               ImagePicker().pickVideo(source: ImageSource.camera);
//               xFile.then((value) {
//                 if (value != null) {
//                   video.value = File(value.path);
//                   image.value = File('null');
//                 }
//               });
//             }),
//         PopupMenuItem(
//             child: const Icon(
//               Icons.video_collection,
//               size: 30,
//               color: Colors.grey,
//             ),
//             onTap: () {
//               Future<XFile?> xFile =
//               ImagePicker().pickVideo(source: ImageSource.gallery);
//               xFile.then((value) {
//                 if (value != null) {
//                   video.value = File(value.path);
//                   image.value = File('null');
//                 }
//               });
//             })
//       ],
//       icon: Obx(
//             () => video.value.path != 'null'
//             ? const Icon(
//           Icons.video_collection,
//           size: 30,
//           color: primaryColor,
//         )
//             : image.value.path != 'null'
//             ? const Icon(
//           Icons.image,
//           size: 30,
//           color: primaryColor,
//         )
//             : const Icon(
//           Icons.camera_alt_outlined,
//           color: Colors.grey,
//           size: 30,
//         ),
//       ));
// }
}
