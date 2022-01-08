import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:smile/model/user_model.dart';
import 'package:smile/utils/constants.dart';
import 'package:smile/view_model/auth_view_model.dart';

class UserFireStore {
  CollectionReference usersCollection =
      FirebaseFirestore.instance.collection(collectionUsers);

  setUser(UserModel user) {
    if (user.id != null) {
      userIsExist(user.id!).then((isExist) {
        if (isExist) {
        } else {
          usersCollection.doc(user.id).set(
                user.toJson(),
              ).then((_) => _setToken(userId: user.id!));
        }
      });
    }
  }

  Future<bool> userIsExist(String userId) async {
    return await usersCollection.doc(userId).get().then((value) {
      if (value.exists) {
        _setToken(userId: userId);
        return true;
      } else {
        return false;
      }
    });
  }
  _setToken({required String userId}) {
    FirebaseMessaging.instance.getToken().then((token) {
      FirebaseFirestore.instance
          .collection(collectionUsers)
          .doc(userId)
          .collection('tokens')
          .doc(token)
          .set({'token': token});
    });
  }
  Future<bool> emailIsExist({required String email}) {
    return usersCollection
        .where(fieldUserEmail, isEqualTo: email)
        .get()
        .then((value) {
      if (value.docs.length == 0) {
        return false;
      } else {
        return true;
      }
    });
  }

  Future<bool> usernameIsExist({required String username}) {
    return usersCollection
        .where(fieldUserUsername, isEqualTo: username)
        .get()
        .then((value) {
      if (value.docs.length == 0) {
        return false;
      } else {
        return true;
      }
    });
  }

  Future<UserModel> getUser(String userId) {
    return usersCollection.doc(userId).get().then((documentSnapshot) {
      // if(documentSnapshot.exists){
      return UserModel.fromJson(
          documentSnapshot.data() as Map<String, dynamic>);
      // }
      // else{
      //   return null;
      // }
    });
  }
  Future<UserModel> getUserByUsername({required String username}) {
    return usersCollection.where(fieldUserUsername , isEqualTo: username).get().then((value) => UserModel.fromJson(
        value.docs.first.data() as Map<String,dynamic>));
  }

  Stream<List<UserModel>> getAllUsersExpectMe() {
    return usersCollection
        .where(fieldUserId,
            isNotEqualTo: Get.find<AuthViewModel>().currentUser!.id)
        .snapshots()
        .map((event) {
      return [
        ...event.docs
            .map((e) => UserModel.fromJson(e.data() as Map<String, dynamic>))
      ];
    });
    //     .get()
    //     .then((value) {
    //   return [
    //     ...value.docs
    //         .map((e) => UserModel.fromJson(e.data() as Map<String, dynamic>))
    //   ];
    // });
  }

  getSuggested(String userId) {}
}
