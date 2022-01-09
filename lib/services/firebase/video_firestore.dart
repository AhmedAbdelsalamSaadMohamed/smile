import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:smile/model/comment_model.dart';
import 'package:smile/model/reply_model.dart';
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

  deleteVideo({required String videoId}) {
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
        .orderBy(fieldVideoTime, descending: true)
        .where(fieldVideoOwnerId, isEqualTo: userId)
        .snapshots()
        .map((value) => [
              ...value.docs.map(
                  (e) => VideoModel.fromJson(e.data() as Map<String, dynamic>))
            ]);
  }

  Future<List<VideoModel>> getAllVideos() {
    return videosCollection
        .orderBy(fieldVideoTime, descending: true)
        .get()
        .then((value) {
      return [
        ...value.docs
            .map((e) => VideoModel.fromJson(e.data() as Map<String, dynamic>))
      ];
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
