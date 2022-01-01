import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smile/model/comment_model.dart';
import 'package:smile/model/video_model.dart';
import 'package:smile/services/firebase/video_firestore.dart';
import 'package:smile/view/pages/replies_screen.dart';
import 'package:smile/view/widgets/comment_widget.dart';
import 'package:smile/view/widgets/profile_circle_avatar.dart';
import 'package:smile/view_model/reply_view_model.dart';
import 'package:smile/view_model/video_view_model.dart';

class VideoCommentsPage extends StatelessWidget {
  VideoCommentsPage({Key? key, required this.videoId}) : super(key: key);
  final String videoId;
  late VideoModel video;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? commentText;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text('Comments'.tr),
      ),
      body: Padding(
          padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Column(
          children: [
            Expanded(
                child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                    stream: VideoFireStore().getCommentsStream(videoId: videoId),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Center(
                          child: Text('Error'.tr),
                        );
                      } else if (!snapshot.hasData) {
                        return Container();
                      } else {
                        return ListView.builder(
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            CommentModel comment = CommentModel.formFire(
                                map: snapshot.data!.docs[index].data(),
                                id: snapshot.data!.docs[index].id);
                            return Column(
                              children: [
                                CommentWidget(comment: comment),
                                Row(
                                  children: [
                                    const SizedBox(
                                      width: 82,
                                    ),

                                    /// show replies
                                    FutureBuilder(
                                      future: ReplyViewModel().getRepliesCount(
                                          comment.postId!, comment.id!),
                                      builder: (context, snapshot) {
                                        if (snapshot.hasError ||
                                            !snapshot.hasData) {
                                          return Container();
                                        } else if (snapshot.hasData &&
                                            snapshot.data! == 0) {
                                          return Container();
                                        }
                                        return GestureDetector(
                                            onTap: () => Get.bottomSheet(SizedBox(
                                                  height: Get.height * 0.5,
                                                  child: RepliesScreen(
                                                    comment: comment,
                                                  ),
                                                )),
                                            child: Text(
                                              'Show'.tr +
                                                  ' ${snapshot.data!} '
                                                          'Replies'
                                                      .tr,
                                              textAlign: TextAlign.start,
                                            ));
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            );
                          },
                        );
                      }
                    })),

            /// new comment form
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
                              return 'Can\'t Publish Empty Comment'.tr;
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

                              suffixIcon: IconButton(
                                  onPressed: () async {
                                    _formKey.currentState!.save();
                                    _publish(context,
                                            imageUrl: null, videoUrl: null)
                                        .then((value) => commentText = '');
                                  },
                                  icon: const Icon(Icons.send, color: Colors.grey,)),
                              hintText: 'Write a comment'.tr),
                        ),
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.background,
                        border: Border.all(
                            color: Theme.of(context).colorScheme.secondary),
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future _publish(context, {String? videoUrl, String? imageUrl}) {
    FocusScope.of(context).requestFocus(FocusNode());

    return VideoViewModel().publishComment(
      videoId: videoId,
      text: commentText,
      imageUrl: imageUrl,
      videoUrl: videoUrl,
    );
  }
}
