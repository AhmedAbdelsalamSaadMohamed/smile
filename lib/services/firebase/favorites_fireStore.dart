import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:smile/utils/constants.dart';
import 'package:smile/view_model/auth_view_model.dart';

class FavoritesFireStore {
  addVideo({required String userId, required String videoId}) {
    FirebaseFirestore.instance
        .collection(collectionUsers)
        .doc(userId)
        .collection(collectionFavorites)
        .doc(videoId)
        .set({fieldVideoId: videoId});
  }

  removeVideo({required String userId, required String videoId}) {
    FirebaseFirestore.instance
        .collection(collectionUsers)
        .doc(userId)
        .collection(collectionFavorites)
        .doc(videoId)
        .delete();
  }

  Stream<bool> videoIsFavorite({required String videoId}) {
    return FirebaseFirestore.instance
        .collection(collectionUsers)
        .doc(Get.find<AuthViewModel>().currentUser!.id)
        .collection(collectionFavorites)
        .snapshots()
        .map((event) => [...event.docs.map((e) => e.id)].contains(videoId));
  }

  Stream<List<String>> getAllFavorites() {
    return FirebaseFirestore.instance
        .collection(collectionUsers)
        .doc(Get.find<AuthViewModel>().currentUser!.id)
        .collection(collectionFavorites)
        .snapshots()
        .map((event) =>
            [...event.docs.map((e) => e.id)]);

    //   .then((value) => [...value.docs.map((e) => e.id)]);
  }
}
