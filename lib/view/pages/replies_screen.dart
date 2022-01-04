import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smile/model/comment_model.dart';
import 'package:smile/model/reply_model.dart';
import 'package:smile/services/firebase/firestorage_service.dart';
import 'package:smile/services/firebase/reply_firestore.dart';
import 'package:smile/view/pages/sign_in_page.dart';
import 'package:smile/view/widgets/comment_widget.dart';
import 'package:smile/view/widgets/profile_circle_avatar.dart';
import 'package:smile/view/widgets/replay_widget.dart';
import 'package:smile/view_model/auth_view_model.dart';
import 'package:smile/view_model/reply_view_model.dart';

class RepliesScreen extends StatelessWidget {
  RepliesScreen({Key? key, required this.comment}) : super(key: key);
  Rx<File> image = File('null').obs,
      video = File('null').obs;
  RxBool wait = false.obs;

  // late PostModel post;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? commentText;
  final CommentModel comment;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Replies'.tr),
        ),
        body: Column(
          children: [
            Expanded(child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: ReplyFirestore(
                    postId: comment.postId!, commentId: comment.id!)
                    .getRepliesStream(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Container();
                  }
                  List<ReplyModel> replies = [
                    ...snapshot.data!.docs
                        .map((e) => ReplyModel.fromFire(e.data(), e.id))
                  ];
                  return ListView.builder(
                    itemCount: replies.length + 1,
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return CommentWidget(
                          comment: comment,
                        );
                      }
                      return ReplyWidget(
                        reply: replies[index - 1],
                        postId: comment.postId!,
                      );
                    },);
                })),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                      padding: EdgeInsets.all(10),
                      child: ProfileCircleAvatar(imageUrl: '', radius: 20)),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(2.0),
                      child: Form(
                        key: _formKey,
                        child: TextFormField(
                          keyboardType: TextInputType.name,
                          maxLines: null,
                          validator: (value) {
                            if (value == null || value == '') {
                              return 'Can\'t Publish Empty Reply'.tr;
                            }
                          },
                          onSaved: (newValue) {
                            commentText = newValue;
                          },
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              errorBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              focusedErrorBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              prefixIcon: _addReplyImage(),
                              suffixIcon: IconButton(
                                  onPressed: () async {
                                    if (Get.find<AuthViewModel>()
                                        .currentUser!
                                        .isAnonymous!) {
                                      _formKey.currentState!.reset();
                                      Get.to(SignInPage(),
                                          transition: Transition.downToUp);
                                    } else{
                                    _formKey.currentState!.save();
                                    if (_formKey.currentState!.validate()) {
                                      _formKey.currentState!.reset();
                                      if (image.value.path != 'null') {
                                        wait.value = true;
                                        File file = image.value;
                                        image.value = File('null');
                                        FireStorageService()
                                            .uploadFile(filePath: file.path)
                                            .then((value) {
                                          _publish(
                                            context,
                                            videoUrl: null,
                                            imageUrl: value,
                                          );
                                          wait.value = false;
                                        });
                                      } else if (video.value.path != 'null') {
                                        wait.value = true;
                                        File file = video.value;
                                        video.value = File('null');
                                        FireStorageService()
                                            .uploadFile(filePath: file.path)
                                            .then((value) {
                                          _publish(context,
                                              videoUrl: value,
                                              imageUrl: null);
                                          wait.value = false;
                                        });
                                      } else {
                                        _publish(context,
                                            imageUrl: null, videoUrl: null);
                                      }
                                    }}
                                  },
                                  icon: const Icon(Icons.send,color: Colors.grey,)),
                              hintText: ' Write a Reply...'.tr),
                        ),
                      ),
                      decoration: BoxDecoration(
                        color: Theme
                            .of(context)
                            .colorScheme
                            .background,
                        border: Border.all(
                            color: Theme
                                .of(context)
                                .colorScheme
                                .secondary),
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Obx(() =>
            image.value.path == 'null'
                ? Container()
                : SizedBox(
                height: MediaQuery
                    .of(context)
                    .size
                    .height * 0.4,
                child: Image.file(
                  image.value,
                  fit: BoxFit.fill,
                ))),
          ],
        ));


    // SingleChildScrollView(
    //   child: SizedBox(
    //     height: MediaQuery
    //         .of(context)
    //         .size
    //         .height -
    //         MediaQuery
    //             .of(context)
    //             .padding
    //             .vertical
    //     // - CustomAppBarWidget.appBarHeight
    //     ,
    //     child: Column(
    //       children: [
    //         Expanded(
    //             child: ListView(
    //               children: [
    //                 CommentWidget(
    //                   comment: comment,
    //                 ),
    //                 Divider(),
    //                 StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
    //                     stream: ReplyFirestore(
    //                         postId: comment.postId!, commentId: comment.id!)
    //                         .getRepliesStream(),
    //                     builder: (context, snapshot) {
    //                       if (!snapshot.hasData) {
    //                         return Container();
    //                       }
    //                       List<ReplyModel> replies = [
    //                         ...snapshot.data!.docs
    //                             .map((e) => ReplyModel.fromFire(e.data(), e.id))
    //                       ];
    //                       return Column(
    //                         children: [
    //                           ...replies.map((e) =>
    //                               ReplyWidget(
    //                                 reply: e,
    //                                 postId: comment.postId!,
    //                               )),
    //                         ],
    //                       );
    //                     }),
    //                 Obx(() =>
    //                 wait.value
    //                     ? SizedBox(
    //                     height: 50,
    //                     child: Center(child: Text('Uploading Reply...'.tr)))
    //                     : Container()),
    //               ],
    //             )),
    //         Padding(
    //           padding: const EdgeInsets.all(8.0),
    //           child: Row(
    //             crossAxisAlignment: CrossAxisAlignment.start,
    //             children: [
    //               const Padding(
    //                   padding: EdgeInsets.all(10),
    //                   child: ProfileCircleAvatar(imageUrl: '', radius: 20)),
    //               Expanded(
    //                 child: Container(
    //                   padding: const EdgeInsets.all(2.0),
    //                   child: Form(
    //                     key: _formKey,
    //                     child: TextFormField(
    //                       keyboardType: TextInputType.multiline,
    //                       maxLines: null,
    //                       validator: (value) {
    //                         if (value == null || value == '') {
    //                           return 'Can\'t Publish Empty Reply'.tr;
    //                         }
    //                       },
    //                       onSaved: (newValue) {
    //                         commentText = newValue;
    //                       },
    //                       decoration: InputDecoration(
    //                           border: InputBorder.none,
    //                           prefixIcon: _addReplyImage(),
    //                           suffixIcon: IconButton(
    //                               onPressed: () async {
    //                                 _formKey.currentState!.save();
    //                                 if (_formKey.currentState!.validate()) {
    //                                   _formKey.currentState!.reset();
    //                                   if (image.value.path != 'null') {
    //                                     wait.value = true;
    //                                     File file = image.value;
    //                                     image.value = File('null');
    //                                     FireStorageService()
    //                                         .uploadFile(file.path)
    //                                         .then((value) {
    //                                       _publish(
    //                                         context,
    //                                         videoUrl: null,
    //                                         imageUrl: value,
    //                                       );
    //                                       wait.value = false;
    //                                     });
    //                                   } else if (video.value.path != 'null') {
    //                                     wait.value = true;
    //                                     File file = video.value;
    //                                     video.value = File('null');
    //                                     FireStorageService()
    //                                         .uploadFile(file.path)
    //                                         .then((value) {
    //                                       _publish(context,
    //                                           videoUrl: value,
    //                                           imageUrl: null);
    //                                       wait.value = false;
    //                                     });
    //                                   } else {
    //                                     _publish(context,
    //                                         imageUrl: null, videoUrl: null);
    //                                   }
    //                                 }
    //                               },
    //                               icon: const Icon(Icons.send)),
    //                           hintText: ' Write a Reply...'.tr),
    //                     ),
    //                   ),
    //                   decoration: BoxDecoration(
    //                     color: Theme
    //                         .of(context)
    //                         .colorScheme
    //                         .background,
    //                     border: Border.all(
    //                         color: Theme
    //                             .of(context)
    //                             .colorScheme
    //                             .secondary),
    //                     borderRadius: BorderRadius.circular(30),
    //                   ),
    //                 ),
    //               ),
    //             ],
    //           ),
    //         ),
    //         Obx(() =>
    //         image.value.path == 'null'
    //             ? Container()
    //             : SizedBox(
    //             height: MediaQuery
    //                 .of(context)
    //                 .size
    //                 .height * 0.4,
    //             child: Image.file(
    //               image.value,
    //               fit: BoxFit.fill,
    //             ))),
    //       ],
    //     ),
    //   ),
    // )
    // ,
    // );
  }

  Widget _addReplyImage() {
    return PopupMenuButton(
        itemBuilder: (context) =>
        [
          PopupMenuItem(
              child: const Icon(
                Icons.image,
                size: 30,
                color: Colors.grey,
              ),
              onTap: () {
                Future<XFile?> xFile =
                ImagePicker().pickImage(source: ImageSource.gallery);
                xFile.then((value) {
                  if (value != null) {
                    image.value = File(value.path);
                    video.value = File('null');
                  }
                });
              }),
          PopupMenuItem(
              child: const Icon(
                Icons.camera_alt,
                size: 30,
                color: Colors.grey,
              ),
              onTap: () {
                Future<XFile?> xFile =
                ImagePicker().pickImage(source: ImageSource.camera);
                xFile.then((value) {
                  if (value != null) {
                    image.value = File(value.path);
                    video.value = File('null');
                  }
                });
              }),
          PopupMenuItem(
              child: const Icon(
                Icons.video_camera_back,
                size: 30,
                color: Colors.grey,
              ),
              onTap: () {
                Future<XFile?> xFile =
                ImagePicker().pickVideo(source: ImageSource.camera);
                xFile.then((value) {
                  if (value != null) {
                    video.value = File(value.path);
                    image.value = File('null');
                  }
                });
              }),
          PopupMenuItem(
              child: const Icon(
                Icons.video_collection,
                size: 30,
                color: Colors.grey,
              ),
              onTap: () {
                Future<XFile?> xFile =
                ImagePicker().pickVideo(source: ImageSource.gallery);
                xFile.then((value) {
                  if (value != null) {
                    video.value = File(value.path);
                    image.value = File('null');
                  }
                });
              })
        ],
        icon: Obx(
              () =>
          video.value.path != 'null'
              ? const Icon(
            Icons.video_collection,
            size: 30,
            //color: primaryColor,
          )
              : image.value.path != 'null'
              ? const Icon(
            Icons.image,
            size: 30,
            // color: primaryColor,
          )
              : const Icon(
            Icons.camera_alt_outlined,
            color: Colors.grey,
            size: 30,
          ),
        ));
  }

  _publish(context, {String? videoUrl, String? imageUrl}) {
    FocusScope.of(context).requestFocus(FocusNode());

    ReplyViewModel().publishReply(
      postId: comment.postId!,
      text: commentText,
      imageUrl: imageUrl,
      videoUrl: videoUrl,
      commentId: comment.id!,
    );
  }
}
