import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:smile/model/user_model.dart';
import 'package:smile/utils/constants.dart';
import 'package:smile/view_model/auth_view_model.dart';

class FireBaseService {
  Future<UserModel?> anonymousSignIn() async {
    return await FirebaseAuth.instance
        .signInAnonymously()
        .then((userCredential) {
      if (userCredential.user == null) {
        return null;
      } else {
        return UserModel(
          id: userCredential.user!.uid,
          name: userCredential.user!.displayName,
          email: userCredential.user!.email,
          isAnonymous: userCredential.user!.isAnonymous,
          profileUrl: userCredential.user!.photoURL,
        );
      }
    });
  }

  Future<UserModel?> createUser(
      {required String email, required String password}) async {
    try {
      return FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((userCredential) {
        if (userCredential.user != null) {
          userCredential.user!.sendEmailVerification();
          return UserModel(
            id: userCredential.user!.uid,
            email: userCredential.user!.email,
            name: userCredential.user!.displayName,
            profileUrl: userCredential.user!.photoURL,
            phone: userCredential.user!.phoneNumber,
            isAnonymous: false,
          );
        }
      });
    }
    // on FirebaseAuthException catch (e) {
    //   if (e.code == 'weak-password') {
    //     Get.showSnackbar(
    //       GetSnackBar(
    //         message: 'The password provided is too weak.',
    //         snackPosition: SnackPosition.TOP,
    //       ),
    //     );
    //     print('The password provided is too weak.');
    //   } else if (e.code == 'email-already-in-use') {
    //     //Get.showSnackbar(`````
    //     Get.rawSnackbar(
    //       message: 'The account already exists for that email.',
    //       snackPosition: SnackPosition.TOP,
    //
    //       // ),
    //     );
    //     print('The account already exists for that email.');
    //   }
    // }
    catch (e) {
      Get.showSnackbar(
        GetSnackBar(
          message: e.toString(),
          snackPosition: SnackPosition.TOP,
        ),
      );
      print(e);
    }
  }

  Future<dynamic> emailAndPasswordSignIn(
      {required String email, required String password}) async {
    String errorMessage;
    try {
      return FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password)
          .then((userCredential) {
        if (userCredential.user != null) {
          return UserModel(
            id: userCredential.user!.uid,
            email: userCredential.user!.email,
            name: userCredential.user!.displayName,
            profileUrl: userCredential.user!.photoURL,
            phone: userCredential.user!.phoneNumber,
            isAnonymous: false,
          );
        }
      }, onError: (error) {
        return error.toString().split(']').toList().last;
      });
    } on FirebaseAuthException catch (error) {
      switch (error.code) {
        case "ERROR_INVALID_EMAIL":
          errorMessage = "Your email address appears to be malformed.";
          break;
        case "ERROR_WRONG_PASSWORD":
          errorMessage = "Your password is wrong.";
          break;
        case "ERROR_USER_NOT_FOUND":
          errorMessage = "User with this email doesn't exist.";
          break;
        case "ERROR_USER_DISABLED":
          errorMessage = "User with this email has been disabled.";
          break;
        case "ERROR_TOO_MANY_REQUESTS":
          errorMessage = "Too many requests. Try again later.";
          break;
        case "ERROR_OPERATION_NOT_ALLOWED":
          errorMessage = "Signing in with Email and Password is not enabled.";
          break;
        default:
          errorMessage = "An undefined Error happened.";
      }
      return errorMessage;
    } catch (e) {
      return 'Error';
    }
  }

  Future<UserModel?> googleSignIn() async {
    return await GoogleSignIn().signIn().then((googleUser) async {
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      return await FirebaseAuth.instance
          .signInWithCredential(credential)
          .then((value) {
        if (googleUser == null) {
          return null;
        } else {
          return UserModel(
            id: googleUser.id,
            name: googleUser.displayName,
            profileUrl: googleUser.photoUrl,
            email: googleUser.email,
            isAnonymous: false,
          );
        }
      });
    });
  }

  Future<StreamSubscription<LoginResult>> facebookSignIn() async {
    return FacebookAuth.instance.login().asStream().listen(((loginResult) {
      print(
          '///////////////done////////////////////////////////////////////////////////////////');
      print(
          '///////////////${loginResult.message}////////////////////////////////////////////////////////////////');
      print(
          '///////////////${loginResult.status}////////////////////////////////////////////////////////////////');

      print(
          '///////////////${loginResult.accessToken?.token.toString()}////////////////////////////////////////////////////////////////');
      if (loginResult.accessToken != null) {
        final OAuthCredential facebookAuthCredential =
            FacebookAuthProvider.credential(loginResult.accessToken!.token);
        FirebaseAuth.instance
            .signInWithCredential(facebookAuthCredential)
            .then((userCredential) {
          Get.find<AuthViewModel>().signIn(UserModel(
            id: userCredential.user!.uid,
            email: userCredential.user!.email,
            isAnonymous: userCredential.user!.isAnonymous,
            profileUrl: userCredential.user!.photoURL,
            name: userCredential.user!.displayName,
            phone: userCredential.user!.phoneNumber,
          ));
        });
      }
    }));
    //     .then((loginResult) {
    // //  if (loginResult.accessToken != null)
    //   {
    //     final OAuthCredential facebookAuthCredential =
    //         FacebookAuthProvider.credential(loginResult.accessToken!.token);
    //     return FirebaseAuth.instance
    //         .signInWithCredential(facebookAuthCredential)
    //         .then((userCredential) {
    //       if (userCredential.user == null) {
    //         return null;
    //       } else {
    //         return UserModel(
    //           id: userCredential.user!.uid,
    //           email: userCredential.user!.email,
    //           isAnonymous: userCredential.user!.isAnonymous,
    //           profileUrl: userCredential.user!.photoURL,
    //           name: userCredential.user!.displayName,
    //           phone: userCredential.user!.phoneNumber,
    //         );
    //       }
    //     });
    //   }
    // });

    // FacebookAuth.instance.login().asStream().where((event) => event.accessToken !=null).first.then((value) => null);
    // Create a credential from the access token
    // final OAuthCredential facebookAuthCredential =
    //     FacebookAuthProvider.credential(loginResult.accessToken!.token);
  }


}
