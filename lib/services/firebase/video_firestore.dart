import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:smile/model/comment_model.dart';
import 'package:smile/model/video_model.dart';
import 'package:smile/services/firebase/firestorage_service.dart';
import 'package:smile/utils/constants.dart';
import 'package:smile/view_model/auth_view_model.dart';

class VideoFireStore {
  CollectionReference videosCollection =
      FirebaseFirestore.instance.collection(collectionVideos);
  FireStorageService fireStorageService = FireStorageService();

  Future<String> addVideo(VideoModel video) async {
    return await videosCollection.add(video.toJson()).then((value) {
      video.id = value.id;
      return value.update(video.toJson()).then((_) => value.id);
    });
  }
  deleteVideo({required String videoId}){
    videosCollection.doc(videoId).delete();
  }
  Future<VideoModel> getVideo({required String videoId}) {
    return videosCollection.where(fieldVideoId, isEqualTo: videoId).get().then(
        (value) => VideoModel.fromJson(
            value.docs.first.data() as Map<String, dynamic>));
  }

  getForYouVideos() {}

   //Future<List<Stream<List<VideoModel>>>>
  //  getFollowingVideos() {
  //   List<VideoModel> videos = [];
  //  videosCollection.where(fieldVideoOwnerId,).get();
  // }

  Stream<List<VideoModel>> getUserVideos(String userId) {
    return videosCollection
        .where(fieldVideoOwnerId, isEqualTo: userId)
        .snapshots()
        .map((value) => [
              ...value.docs.map(
                  (e) => VideoModel.fromJson(e.data() as Map<String, dynamic>))
            ]);
  }

  Future<List<VideoModel>> getAllVideos() {
    return videosCollection.orderBy(fieldVideoTime).get().then((value) {
      return [
        ...value.docs
            .map((e) => VideoModel.fromJson(e.data() as Map<String, dynamic>))
      ];
    });
  }

  /// ////////////////////////comments
  ///
  //final CollectionReference commentsReference;

  Future<String> addComment(
      {required CommentModel newComment, required String videoId}) async {
    return await FirebaseFirestore.instance
        .collection(collectionVideos)
        .doc(videoId)
        .collection(tableComments)
        .add(newComment.toJson())
        .then((value) => value.id);
  }

  Future<List<CommentModel>?> getComments({required String videoId}) async {
    return [
      ...await FirebaseFirestore.instance
          .collection(collectionVideos)
          .doc(videoId)
          .collection(tableComments)
          .get()
          .then((value) => value.docs
              .map((e) => CommentModel.formFire(map: e.data(), id: e.id)))
    ];
  }

  Future<CommentModel> getComment(
      {required String commentId, required String videoId}) async {
    return await FirebaseFirestore.instance
        .collection(collectionVideos)
        .doc(videoId)
        .collection(tableComments)
        .doc(commentId)
        .get()
        .then((value) => CommentModel.formFire(
            map: value.data() as Map<String, dynamic>, id: value.id));
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getCommentsStream(
      {required String videoId}) {
    return FirebaseFirestore.instance
        .collection(collectionVideos)
        .doc(videoId)
        .collection(tableComments)
        .orderBy(fieldCommentTime)
        .snapshots();
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

  /// reactions  //////////////////////////////////////////////////////////////////////////////

  reactVideo({required String videoId, required String react}) {
    videosCollection
        .doc(videoId)
        .collection(collectionReactions)
        .doc(Get.find<AuthViewModel>().currentUser!.id!)
        .set({fieldReaction: react});
  }

  Stream<String> getVideoReact({required String videoId}) {
    return videosCollection
        .doc(videoId)
        .collection(collectionReactions)
        .doc(Get.find<AuthViewModel>().currentUser!.id!)
        .snapshots()
        .map((event) =>
            event.data() == null ? 'non' : event.data()![fieldReaction]);
  }

  Stream<List<String>> getVideoReacts({required String videoId}) {
    return videosCollection
        .doc(videoId)
        .collection(collectionReactions)
        .snapshots()
        .map((event) => [...event.docs.map((e) => e.data()[fieldReaction])]);
  }
}
