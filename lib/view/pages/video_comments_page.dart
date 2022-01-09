import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smile/model/video_comment_model.dart';
import 'package:smile/model/video_model.dart';
import 'package:smile/view/pages/video_replaies_page.dart';
import 'package:smile/view/widgets/profile_circle_avatar.dart';
import 'package:smile/view/widgets/video_comment_widget.dart';
import 'package:smile/view_model/video_comment_view_model.dart';
import 'package:smile/view_model/video_replay_view_model.dart';

class VideoCommentsPage extends StatefulWidget {
  VideoCommentsPage({Key? key, required this.videoId}) : super(key: key);
  final String videoId;

  @override
  State<VideoCommentsPage> createState() => _VideoCommentsPageState();
}

class _VideoCommentsPageState extends State<VideoCommentsPage> {
  late VideoModel video;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String? commentText;
  final VideoCommentViewModel _videoCommentViewModel = VideoCommentViewModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text('Comments'.tr),
      ),
      body: Column(
        children: [
          Expanded(
              child: StreamBuilder<List<VideoCommentModel>>(
                  stream: _videoCommentViewModel.getCommentsStream(
                      videoId: widget.videoId),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Center(
                        child: Text('Error'.tr),
                      );
                    } else if (!snapshot.hasData) {
                      return Container();
                    } else {
                      return ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          VideoCommentModel comment = snapshot.data![index];
                          return Column(
                            children: [
                              VideoCommentWidget(comment: comment),
                              Row(
                                children: [
                                  const SizedBox(
                                    width: 82,
                                  ),

                                  /// show replies
                                  StreamBuilder(
                                    stream: VideoReplyViewModel()
                                        .getRepliesCount(
                                            videoId: comment.videoId!,
                                            commentId: comment.id!),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasError ||
                                          !snapshot.hasData) {
                                        return Container();
                                      } else if (snapshot.hasData &&
                                          snapshot.data! == 0) {
                                        return Container();
                                      }
                                      return GestureDetector(
                                          onTap: () => Get.to(VideoRepliesScreen(
                                            comment: comment,
                                          ),),
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
                                      .then((value) => setState(() {
                                            commentText = '';
                                            _formKey.currentState!.reset();
                                          }));
                                },
                                icon: const Icon(
                                  Icons.send,
                                  color: Colors.grey,
                                )),
                            hintText: 'Write a comment'.tr),
                      ),
                    ),
                    decoration: BoxDecoration(
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
    );
  }

  Future _publish(context, {String? videoUrl, String? imageUrl}) {
    FocusScope.of(context).requestFocus(FocusNode());

    return _videoCommentViewModel.publishComment(
      videoId: widget.videoId,
      text: commentText,
      imageUrl: imageUrl,
      videoUrl: videoUrl,
    );
  }
}
