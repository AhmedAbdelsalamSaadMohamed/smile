import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:smile/model/video_comment_model.dart';
import 'package:smile/utils/constants.dart';
import 'package:smile/view_model/auth_view_model.dart';

class VideoCommentFireStore {
  Future<String> addComment(
      {required VideoCommentModel newComment, required String videoId}) async {
    return await FirebaseFirestore.instance
        .collection(collectionVideos)
        .doc(videoId)
        .collection(tableComments)
        .add(newComment.toJson())
        .then((value) => value.id);
  }

  Future<List<VideoCommentModel>?> getComments(
      {required String videoId}) async {
    return [
      ...await FirebaseFirestore.instance
          .collection(collectionVideos)
          .doc(videoId)
          .collection(tableComments)
          .get()
          .then((value) => value.docs
              .map((e) => VideoCommentModel.formFire(map: e.data(), id: e.id)))
    ];
  }

  Future<VideoCommentModel> getComment(
      {required String commentId, required String videoId}) async {
    return await FirebaseFirestore.instance
        .collection(collectionVideos)
        .doc(videoId)
        .collection(tableComments)
        .doc(commentId)
        .get()
        .then((value) => VideoCommentModel.formFire(
            map: value.data() as Map<String, dynamic>, id: value.id));
  }

  Stream<List<VideoCommentModel>> getCommentsStream({required String videoId}) {
    return FirebaseFirestore.instance
        .collection(collectionVideos)
        .doc(videoId)
        .collection(tableComments)
        .orderBy(fieldCommentTime)
        .snapshots()
        .map((event) => [
              ...event.docs.map(
                  (e) => VideoCommentModel.formFire(map: e.data(), id: e.id))
            ]);
  }

  Future<List<dynamic>> getCommentLovers(
      {required String commentId, required String videoId}) async {
    return await FirebaseFirestore.instance
        .collection(collectionVideos)
        .doc(videoId)
        .collection(tableComments)
        .doc(commentId)
        .get()
        .then((value) {
      return (value.data() as Map<String, dynamic>)[fieldCommentLoves]
          as List<dynamic>;
    });
  }

  Future loveComment(
      {required String commentId, required String videoId}) async {
    await FirebaseFirestore.instance
        .collection(collectionVideos)
        .doc(videoId)
        .collection(tableComments)
        .doc(commentId)
        .update({
      fieldCommentLoves:
          FieldValue.arrayUnion([Get.find<AuthViewModel>().currentUser!.id])
    });
  }

  Future notLoveComment(
      {required String commentId, required String videoId}) async {
    await FirebaseFirestore.instance
        .collection(collectionVideos)
        .doc(videoId)
        .collection(tableComments)
        .doc(commentId)
        .update({
      fieldCommentLoves:
          FieldValue.arrayRemove([Get.find<AuthViewModel>().currentUser!.id])
    });
  }
}
