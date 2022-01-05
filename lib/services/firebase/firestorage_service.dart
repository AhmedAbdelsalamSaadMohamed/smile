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

  Future<String?> uploadFile({String? filePath, File? file}) async {
    File myFile;
    if (filePath != null)
      myFile = File(filePath);
    else
      myFile = file!;
    try {
      Task task = firebase_storage.FirebaseStorage.instance
          .ref(
              'uploads/${Get.find<AuthViewModel>().currentUser!.id}/${myFile.path.split('/').last}')
          .putFile(myFile);
      _videoSnackBar(task);
      return task.then((taskSnapshot) =>
          task.then((taskSnapshot) => taskSnapshot.ref.getDownloadURL()));
    } on firebase_core.FirebaseException catch (e) {
      print(e);
    }
  }

  Future<String> downloadVideo(VideoModel videoModel) async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    Directory(appDocDir.path + '/$collectionVideos').createSync();
    File downloadToFile = File(
        '${appDocDir.path}/$collectionVideos/${Timestamp.now().seconds}${videoModel.name}');

    // try {
    DownloadTask task = firebase_storage.FirebaseStorage.instance
        .ref('uploads/${videoModel.ownerId}/${videoModel.name}')
        .writeToFile(downloadToFile);

    _videoSnackBar(task);
    return task.then((_) => downloadToFile.uri.path);
  }

  _videoSnackBar(Task task) {
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
        if (Get.isSnackbarOpen) {
          Get.closeCurrentSnackbar().then((value) => Get.rawSnackbar(
                snackPosition: SnackPosition.TOP,
                message: 'Success',
              ));
        } else {
          Get.rawSnackbar(
            snackPosition: SnackPosition.TOP,
            message: 'Success',
          );
        }
      }
    });
  }
}
