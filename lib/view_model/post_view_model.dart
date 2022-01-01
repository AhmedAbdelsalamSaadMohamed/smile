import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:smile/model/post_model.dart';
import 'package:smile/services/firebase/comment_sirestore.dart';
import 'package:smile/services/firebase/firestorage_service.dart';
import 'package:smile/services/firebase/post_firestore.dart';
import 'package:smile/view_model/auth_view_model.dart';

class PostViewModel extends GetxController {
  RxBool wait = false.obs;

  PostViewModel();

  PostViewModel.byTag(this.postId) {
    initByTag();
  }

  String? postId;
  RxInt commentsCount = 0.obs, lovesCount = 0.obs;
  RxBool isLove = false.obs;
 Rx< PostModel> post = PostModel(ownerId: ' ').obs;

  initByTag() {
    PostFireStore().getPostSteam(postId!).listen((event) {
      post.value = PostModel.fromFire(event.data() as Map<String, dynamic>, postId);
      lovesCount.value = post.value.loves == null ? 0 : post.value.loves!.length;
      isLove.value = post.value.loves == null
          ? false
          : post.value.loves!.contains(Get.find<AuthViewModel>().currentUser!.id);
    });
    // CommentViewModel()
    //     .getCommentsCount(postId!)
    //     .then((value) => commentsCount.value = value);
    CommentFirestore(postId: postId!).getCommentsStream().listen((event) {
      commentsCount.value = event.docs.length;
    });
  }

  uploadPost({String text = ' ', List<File>? images, File? video}) {
    List<String> imagesUrls = [];

    if (images != null && images.isNotEmpty) {
      wait.value = true;

      for (int i = 0; i < images.length; i++) {
        FireStorageService().uploadFile(images[i].path).then((value) {
          imagesUrls.add(value!);
          if (i == images.length - 1) {
            wait.value = false;
          }
        });
      }
    }
    if (!wait.value) {
      PostModel post = PostModel(
          ownerId: Get.find<AuthViewModel>().currentUser!.id,
          postText: text,
          imagesUrls: imagesUrls,
          postTime: Timestamp.now());
      PostFireStore().addPost(post);

    }
    wait.listen((val) {
      print('kkkk11111111111111111111kkkkkkkkkk $val kkk');
      if (!val) {
        PostModel post = PostModel(
            ownerId: Get.find<AuthViewModel>().currentUser!.id,
            postText: text,
            imagesUrls: imagesUrls,
            postTime: Timestamp.now());
        PostFireStore().addPost(post).then((value) => Get.back());
      }
    });
    Get.back();
  }

  loveOrNotPost(String postId, bool love) {
    if (love) {
      PostFireStore().lovePost(postId);
    } else {
      PostFireStore().notLovePost(postId);
    }
  }

  Future<PostModel> getPost(String postId) async {
    return await PostFireStore().getPost(postId).then((value) => value);
  }
 Future<List<PostModel>> getAllPosts(){
   return PostFireStore().getAllPosts();
  }
  Stream<List<PostModel>>getUserPosts({required String userId}){
    return PostFireStore().getUserPosts(userId: userId);
  }
}
