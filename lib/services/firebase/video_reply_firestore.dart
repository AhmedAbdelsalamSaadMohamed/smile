import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:smile/model/reply_model.dart';
import 'package:smile/utils/constants.dart';
import 'package:smile/view_model/auth_view_model.dart';

class VideoReplyFireStore{

  ///     replays

  Future<String> addReplay(
      {required ReplyModel newReply,
        required String commentId,
        required String videoId}) async {
    return await FirebaseFirestore.instance
        .collection(collectionVideos)
        .doc(videoId)
        .collection(tableComments)
        .doc(commentId)
        .collection(tableReplies)
        .add(newReply.toJson())
        .then((value) => value.id);
  }

   Stream<List<ReplyModel>>getRepliesStream(
      {required String videoId, required String commentId}) {
    return FirebaseFirestore.instance
        .collection(collectionVideos)
        .doc(videoId)
        .collection(tableComments)
        .doc(commentId)
        .collection(tableReplies)
        .orderBy(fieldReplyTime)
        .snapshots().map((event) => [...event.docs.map((e) => ReplyModel.fromFire(e.data(), e.id))]);
  }

  Stream<int>getRepliesCount({required String videoId,required String commentId}){
    return FirebaseFirestore.instance
        .collection(collectionVideos)
        .doc(videoId)
        .collection(tableComments)
        .doc(commentId)
        .collection(tableReplies)
        .snapshots().map((event) => event.docs.length);
  }

  Future<List<dynamic>> getReplyLovers(
      {required String replyId,required String commentId, required String videoId}) async {
    return await FirebaseFirestore.instance
        .collection(collectionVideos)
        .doc(videoId)
        .collection(tableComments)
        .doc(commentId).collection(tableReplies).doc(replyId)
        .get()
        .then((value) {
      return (value.data() as Map<String, dynamic>)[fieldReplyLoves]
      as List<dynamic>;
    });
  }

  Future loveReply(
      {required String replyId ,required String commentId, required String videoId}) async {
    await FirebaseFirestore.instance
        .collection(collectionVideos)
        .doc(videoId)
        .collection(tableComments)
        .doc(commentId).collection(tableReplies).doc(replyId)
        .update({
      fieldReplyLoves:
      FieldValue.arrayUnion([Get.find<AuthViewModel>().currentUser!.id])
    });
  }

  Future notLoveComment(
      {required String replyId,required String commentId, required String videoId}) async {
    await FirebaseFirestore.instance
        .collection(collectionVideos)
        .doc(videoId)
        .collection(tableComments)
        .doc(commentId).collection(tableReplies).doc(replyId)
        .update({
      fieldReplyLoves:
      FieldValue.arrayRemove([Get.find<AuthViewModel>().currentUser!.id])
    });
  }
}
