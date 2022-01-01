import 'package:get/get.dart';
import 'package:smile/model/user_model.dart';
import 'package:smile/services/firebase/follow_fireStore.dart';
import 'package:smile/services/firebase/user_firestore.dart';
import 'package:smile/view_model/auth_view_model.dart';
class UserViewModel extends GetxController {
  UserModel currentUser = Get.find<AuthViewModel>().currentUser!;
  final UserFireStore _userFireStore = UserFireStore();

  Future<UserModel> getUser({required String userId}) {
    return _userFireStore.getUser(userId);
  }
  Future<UserModel> getUserByUsername({required String username}) {
    return _userFireStore.getUserByUsername(username: username);
  }
  Stream<Stream<List<UserModel>>> getAllSuggestedUsers(){
    return FollowFireStore().getUserFollowings(currentUser.id!).map((followings){
      bool inFollowings(String ownerId) {
        for (var element in followings) {
          if (element == ownerId) {
            return true;
          }
        }
        return false;
      }
      return _userFireStore.getAllUsersExpectMe().map((event) {
         event.removeWhere((element) => inFollowings(element.id!));
         return event;
       });
      // then((allUsers) {
      //   allUsers.removeWhere((element) => inFollowings(element.id!));
      //   return allUsers;
      // });
    });

  }

  /// follow
  Future<void> follow({required String userId}) async {
    FollowFireStore().follow(userId: userId).then((_) {
      //getFollowingsNum();
    });
  }

  Future<void> unFollow({required String userId}) async {
    FollowFireStore().unFollow(userId: userId).then((_) {
    });
  }

  Stream<List<Future<UserModel?>>> getUserFollowers() {
    return FollowFireStore().getUserFollowers(currentUser.id!).map((event) => [
          ...event.map((id) {
            return _userFireStore.getUser(id);
          })
        ]);
  }

  Stream<List<Future<UserModel?>>> getUserFollowings() {
    return FollowFireStore().getUserFollowings(currentUser.id!).map((event) => [
          ...event.map((id) {
            return _userFireStore.getUser(id);
          })
        ]);
  }

  Stream<int> getFollowersNum(String userId)  {
   return FollowFireStore()
        .getFollowersNum(userId);
  }

  Stream<int> getFollowingsNum(String userId)  {
  return  FollowFireStore()
        .getFollowingsNum(userId);
  }

  Stream<bool> isFollowing(String userId) {
    return FollowFireStore()
        .getUserFollowings(currentUser.id!)
        .map((event) => event.contains(userId));
  }

  Stream<bool> isFollower(String userId) {
    return FollowFireStore()
        .getUserFollowers(currentUser.id!)
        .map((event) => event.contains(userId));
  }
}
