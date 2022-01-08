import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smile/model/user_model.dart';
import 'package:smile/services/firebase/firebase_service.dart';
import 'package:smile/services/firebase/user_firestore.dart';
import 'package:smile/services/shared_preferences/shared_preferences_service.dart';
import 'package:smile/view/pages/complete_social_sign_up.dart';
import 'package:smile/view/pages/main_view.dart';
import 'package:smile/view/pages/sign_in_page.dart';
import 'package:smile/view/pages/verify_email_page.dart';

class AuthViewModel extends GetxController {
  UserModel? currentUser;

  final FireBaseService _fireBase = FireBaseService();
  final SharedPreferencesService _sharedPreferences =
      SharedPreferencesService();
  final UserFireStore _userFireStore = UserFireStore();

  signInAnonymously() {
    _showSnackBar();
    _fireBase.anonymousSignIn().then((user) {
      signIn(user);
    });
  }

  createUser({required String email, required String password}) {
    _showSnackBar();
    _fireBase.createUser(email: email, password: password).then((user) {
      if (user != null) {
        Get.closeAllSnackbars();
        Get.to(VerifyEmailPage(
          user: user,
        ));
      }
    });
  }

  signInByEmailOrUsername(
      {required String emailOrUsername, required String password}) {
    _showSnackBar();
    if (RegExp(r'^@').hasMatch(emailOrUsername)) {
      _userFireStore.getUserByUsername(username: emailOrUsername).then((user) =>
          _signInByEmailAndPassword(email: user.email!, password: password));
    } else {
      _signInByEmailAndPassword(email: emailOrUsername, password: password);
    }
  }

  _signInByEmailAndPassword({required String email, required String password}) {
    _fireBase
        .emailAndPasswordSignIn(email: email, password: password)
        .then((result) {
          if(result.runtimeType == String){
            Get.closeAllSnackbars();
            Get.rawSnackbar(
              message: result,
              snackPosition: SnackPosition.TOP,
              duration: Duration(seconds: 10),
            );
          }else{
            signIn(result);
          }

    });
  }

  signInByGoogle() {
    _showSnackBar();
    _fireBase.googleSignIn().then((user) {
      signIn(user);
    });
  }

  signInByFacebook() {
    _showSnackBar();
    if (_fireBase.facebookSignIn() != null)
      _fireBase.facebookSignIn().then((user) {
        //signIn(user);
      });
  }

  signIn(UserModel? user) async {
    if (user == null) {
    } else {
      Get.closeAllSnackbars();
      currentUser = user;
      if (user.isAnonymous!) {
        _sharedPreferences.addUser(user);
        Get.to(MainView(), transition: Transition.leftToRightWithFade);
      } else {
        _userFireStore.userIsExist(user.id!).then((isExist) {
          if (isExist) {
            _sharedPreferences.addUser(user);
            Get.offAll(MainView());
          } else {
            Get.to(CompleteSocialSignUp(user: user));
          }
        });
      }
    }
  }

  signUp(UserModel user) async {
    await _userFireStore.setUser(user);
    await _sharedPreferences.addUser(user);
    currentUser = user;
    Get.offAll(MainView());
  }

  signOut() {
    _sharedPreferences.deleteUser().then((done) {
      if (done) {
        Get.offAll(SignInPage());
      }
    });
  }
  Future<bool> isSigned() async {
    UserModel? user = await _sharedPreferences.getUser();
    if (user == null) {
      return false;
    } else {
      currentUser = user;
      return true;
    }
  }

  Future<bool> emailIsExist({required String email}) {
    return UserFireStore().emailIsExist(email: email);
  }

  Future<bool> usernameIsExist({required String username}) {
    return UserFireStore().usernameIsExist(username: username);
  }
}

_showSnackBar(){
  Get.rawSnackbar(
    snackPosition: SnackPosition.TOP,
    duration: Duration(minutes: 3),
    messageText: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Signing In'),
          CircularProgressIndicator(),
        ],
      ),
    ),
  );
}