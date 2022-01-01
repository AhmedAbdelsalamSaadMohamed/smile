import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:smile/utils/constants.dart';
import 'package:smile/view_model/auth_view_model.dart';

class FollowFireStore {
  String currentUserId = Get.find<AuthViewModel>().currentUser!.id!;

  Future follow({required String userId}) async {
    /// followers
    await FirebaseFirestore.instance
        .collection(collectionUsers)
        .doc(userId)
        .collection(collectionFollowers)
        .doc(currentUserId)
        .set({fieldUserId: currentUserId});

    ///followings
    await FirebaseFirestore.instance
        .collection(collectionUsers)
        .doc(currentUserId)
        .collection(collectionFollowings)
        .doc(userId)
        .set({fieldUserId: userId});
  }

  Future unFollow({required String userId}) async {
    /// followers
    await FirebaseFirestore.instance
        .collection(collectionUsers)
        .doc(userId)
        .collection(collectionFollowers)
        .doc(currentUserId)
        .delete();

    ///followings
    await FirebaseFirestore.instance
        .collection(collectionUsers)
        .doc(currentUserId)
        .collection(collectionFollowings)
        .doc(userId)
        .delete();
  }

  Stream<List<String>> getUserFollowers(String userId) {
    return FirebaseFirestore.instance
        .collection(collectionUsers)
        .doc(userId)
        .collection(collectionFollowers)
        .snapshots()
        .map((event) => [...event.docs.map((e) => e.id)]);
  }

  Stream<List<String>> getUserFollowings(String userId) {
    return FirebaseFirestore.instance
        .collection(collectionUsers)
        .doc(userId)
        .collection(collectionFollowings)
        .snapshots()
        .map((event) => [...event.docs.map((e) => e.id)]);
  }

  Stream<int> getFollowersNum(String userId) {
    return FirebaseFirestore.instance
        .collection(collectionUsers)
        .doc(userId)
        .collection(collectionFollowers)
        .snapshots()
        .map((event) => event.docs.length);
  }

  Stream<int> getFollowingsNum(String userId) {
    return FirebaseFirestore.instance
        .collection(collectionUsers)
        .doc(userId)
        .collection(collectionFollowings)
        .snapshots()
        .map((event) => event.docs.length);
  }
}
