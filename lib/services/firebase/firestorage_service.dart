import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:smile/model/video_model.dart';
import 'package:smile/utils/constants.dart';
import 'package:smile/view_model/auth_view_model.dart';

class FireStorageService {
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  Future<String?> uploadFile(String filePath) async {
    File file = File(filePath);

    try {
      Task task = firebase_storage.FirebaseStorage.instance
          .ref(
              'uploads/${Get.find<AuthViewModel>().currentUser!.id}/${filePath.split('/').last}')
          .putFile(file);
      _videoSnakBar(task);
      return task.then((taskSnapshot) =>
          task.then((taskSnapshot) => taskSnapshot.ref.getDownloadURL()));
    } on firebase_core.FirebaseException catch (e) {
      print(e);

    }
  }

  Future<void> downloadVideo(VideoModel videoModel) async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    Directory(appDocDir.path + '/$collectionVideos').createSync();
    File downloadToFile = File(
        '${appDocDir.path}/$collectionVideos/${videoModel.name}${Timestamp.now()}');

    // try {
      DownloadTask task = firebase_storage.FirebaseStorage.instance
          .ref(
              'uploads/${videoModel.ownerId}/${videoModel.name}')
          .writeToFile(downloadToFile);

      _videoSnakBar(task);

    // } on firebase_core.FirebaseException catch (e) {
    //   // e.g, e.code == 'canceled'
    // }
  }

  _videoSnakBar(Task task) {
    task.snapshotEvents.listen((firebase_storage.TaskSnapshot snapshot) {
      print('Task state: ${snapshot.state}');
      // RxString message = 'Progress: ${(snapshot.bytesTransferred / snapshot.totalBytes) * 100} %'.obs;
      print(
          'Progress: ${(snapshot.bytesTransferred / snapshot.totalBytes) * 100} %');
      if (Get.isSnackbarOpen) {
        Get.closeCurrentSnackbar();
      }

      Get.rawSnackbar(
        message:
        'Progress: ${((snapshot.bytesTransferred / snapshot.totalBytes) * 100).round()} %',
        snackPosition: SnackPosition.TOP,
        duration: (snapshot.bytesTransferred / snapshot.totalBytes) == 1
            ? const Duration(seconds: 1)
            : const Duration(seconds: 20),
        animationDuration: Duration.zero,
        //backgroundColor: Colors.black,
        //borderColor: Colors.white,
       // showProgressIndicator: true,
      // borderRadius: 20,
       overlayColor: Colors.black,
       // progressIndicatorValueColor: Color.fromRGBO(250, 51, 1, 1),
      );
      if (snapshot.state == firebase_storage.TaskState.success) {
        Get.closeAllSnackbars();
        Get.rawSnackbar(
          snackPosition: SnackPosition.TOP,
          message: 'Success',
        );
      }
    });
  }
}


