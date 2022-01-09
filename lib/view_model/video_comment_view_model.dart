import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:smile/model/video_comment_model.dart';
import 'package:smile/services/firebase/video_comment_firestore.dart';

import 'auth_view_model.dart';

class VideoCommentViewModel {
  VideoCommentFireStore _videoCommentFireStore = VideoCommentFireStore();
  Future publishComment(
      {required String videoId, required text, imageUrl, videoUrl}) async {
    print(text);
    VideoCommentModel newComment = VideoCommentModel(
        owner: Get.find<AuthViewModel>().currentUser!.id,
        time: Timestamp.now(),
        videoId: videoId,
        text: text,
        image: imageUrl,
        video: videoUrl);
    await _videoCommentFireStore
        .addComment(newComment: newComment, videoId: videoId);
  }

  Stream<List<VideoCommentModel>> getCommentsStream({required String videoId}){
    return _videoCommentFireStore.getCommentsStream(videoId: videoId);
  }
  loveOrNotComment(
      {required String videoId, required String commentId, required bool love}) {
    if (love) {
      _videoCommentFireStore.loveComment(videoId: videoId,commentId:commentId )

          ;
    } else {
      _videoCommentFireStore.notLoveComment(commentId: commentId, videoId: videoId);
    }
  }
}
