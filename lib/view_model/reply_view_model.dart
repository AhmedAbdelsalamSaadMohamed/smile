import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:smile/model/reply_model.dart';
import 'package:smile/services/firebase/reply_firestore.dart';
import 'package:smile/view_model/auth_view_model.dart';

class ReplyViewModel extends GetxController {
  Future publishReply({
    required String postId,
    required String commentId,
    text = '',
    imageUrl,
    videoUrl,
  }) async {
    ReplyModel newReply = ReplyModel(
      owner: Get.find<AuthViewModel>().currentUser!.id,
      time: Timestamp.now(),
      text: text,
      commentId: commentId,
      image: imageUrl,
      video: videoUrl,
    );
    await ReplyFirestore(postId: postId, commentId: commentId)
            .addReply(newReply)
        // .then((value) => NotificationViewModel().addNotification(
        //     action: NotificationModel.reply,
        //     postId: postId,
        //     commentId: commentId,
        //     replyId: value,
        //     time: newReply.time!))
        ;
  }

  Future<List<ReplyModel>?> getCommentReplies(
      String postId, String commentId) async {
    return await ReplyFirestore(postId: postId, commentId: commentId)
        .getReplies();
  }

  loveOrNotReply(
      {required String postId,
      required String commentId,
      required String replyId,
      required bool love}) {
    if (love) {
      ReplyFirestore(commentId: commentId, postId: postId).loveReply(replyId);
    } else {
      ReplyFirestore(commentId: commentId, postId: postId)
          .notLoveReply(replyId);
    }
  }

  Future<int> getRepliesCount(String postId, String commentId) async {
    return await getCommentReplies(postId, commentId)
        .then((value) => value == null ? 0 : value.length);
  }
}
