import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:smile/model/reply_model.dart';
import 'package:smile/model/user_model.dart';
import 'package:smile/services/firebase/video_reply_firestore.dart';
import 'package:smile/view_model/auth_view_model.dart';

class VideoReplyViewModel {
  VideoReplyFireStore _videoReplyFireStore = VideoReplyFireStore();
  UserModel currentUser = Get.find<AuthViewModel>().currentUser!;

  publishReply(
      {required String commentId,
      required String videoId,
      String? text,
      String? imageUrl,
      String? videoUrl}) {
    ReplyModel newReply = ReplyModel(
      commentId: commentId,
      video: videoUrl,
      image: imageUrl,
      text: text,
      owner: currentUser.id!,
      time: Timestamp.now(),
    );
    _videoReplyFireStore.addReplay(
        newReply: newReply, commentId: commentId, videoId: videoId);
  }

  Stream<List<ReplyModel>> getRepliesStream(
      {required String videoId, required String commentId}) {
    return _videoReplyFireStore.getRepliesStream(
        videoId: videoId, commentId: commentId);
  }

  Stream<int> getRepliesCount({required String videoId, required String commentId}) {
    return _videoReplyFireStore.getRepliesCount(
        videoId: videoId, commentId: commentId);
  }

  loveOrNotReply(
      {required String replyId,
      required String videoId,
      required String commentId,
      required bool love}) {
    if (love) {
      _videoReplyFireStore.loveReply(
          replyId: replyId, videoId: videoId, commentId: commentId);
    } else {
      _videoReplyFireStore.notLoveComment(
          replyId: replyId, commentId: commentId, videoId: videoId);
    }
  }


}
