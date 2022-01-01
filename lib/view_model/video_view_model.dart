import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:hashtager/functions.dart';
import 'package:smile/model/comment_model.dart';
import 'package:smile/model/tag_model.dart';
import 'package:smile/model/user_model.dart';
import 'package:smile/model/video_model.dart';
import 'package:smile/services/firebase/favorites_fireStore.dart';
import 'package:smile/services/firebase/firestorage_service.dart';
import 'package:smile/services/firebase/follow_fireStore.dart';
import 'package:smile/services/firebase/tag_firestore.dart';
import 'package:smile/services/firebase/video_firestore.dart';
import 'package:smile/view/pages/main_view.dart';
import 'package:smile/view/pages/profile_page.dart';
import 'package:smile/view/widgets/react_button.dart';
import 'package:smile/view_model/main_navigator_view_model.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

import 'auth_view_model.dart';

class VideoViewModel extends GetxController {
  VideoFireStore videoFireStore = VideoFireStore();
  FireStorageService storage = FireStorageService();
  UserModel currentUser = Get.find<AuthViewModel>().currentUser!;

  publishVideo({String? description, required String filePath}) {
    storage.uploadFile(filePath).then((url) {
      if (url != null) {
        VideoThumbnail.thumbnailData(
          video: url,
          imageFormat: ImageFormat.JPEG,
          maxWidth: 128,
          quality: 360,
        ).then((imageUint8List) async {
          if (imageUint8List != null) {
            final Directory systemTempDir = Directory.systemTemp;
            final File file =
                await new File('${systemTempDir.path}/foo.png').create();
            file.writeAsBytes(imageUint8List);
            storage.uploadFile(file.path).then((imageUrl) {
              VideoModel video = VideoModel(
                  name: filePath.split('/').last,
                  url: url,
                  imageUrl: imageUrl,
                  time: Timestamp.now(),
                  ownerId: currentUser.id,
                  description: description);
              videoFireStore.addVideo(video).then((videoId) {
                extractHashTags(description ?? '').forEach((tag) {
                  TagFireStore().addVideoTag(TagModel(tag: tag, videoId: videoId));
                });
              });
            });
          }
        });


      }
    });
    Get.find<MainNavigatorViewModel>().change(ProfilePage());
    Get.offAll(MainView());
  }

  Future<VideoModel> getVideo({required String videoId}) {
    return videoFireStore.getVideo(videoId: videoId);
  }

  Future<List<VideoModel>> getForYouVideos() {
    return videoFireStore.getAllVideos();
  }

  Future<List<VideoModel>> getFollowingVideos() {
    return FollowFireStore()
        .getUserFollowings(currentUser.id!)
        .first
        .then((followings) {
      bool inFollowings(String ownerId) {
        for (var element in followings) {
          if (element == ownerId) {
            return true;
          }
        }
        return false;
      }

      return videoFireStore.getAllVideos().then((allVideos) {
        allVideos.removeWhere((video) => !inFollowings(video.ownerId!));
        return allVideos;
      });
    });
  }

  Stream<List<VideoModel>> getUserVideos(String userId) {
    return videoFireStore.getUserVideos(userId);
  }

  /// favorite
  Stream<List<Future<VideoModel>>> getFavoriteVideos() {
    return FavoritesFireStore()
        .getAllFavorites()
        .map((event) => [...event.map((e) => getVideo(videoId: e))]);
  }

  Stream<bool> isFavorite({required String videoId}) {
    return FavoritesFireStore().videoIsFavorite(videoId: videoId);
  }

  favoriteVideo(videoId) {
    FavoritesFireStore().addVideo(userId: currentUser.id!, videoId: videoId);
  }

  unFavoriteVideo(videoId) {
    FavoritesFireStore().removeVideo(userId: currentUser.id!, videoId: videoId);
  }

  ///            comments
  ///
  Future publishComment(
      {required String videoId, required text, imageUrl, videoUrl}) async {
    print(text);
    CommentModel newComment = CommentModel(
        owner: Get.find<AuthViewModel>().currentUser!.id,
        time: Timestamp.now(),
        postId: videoId,
        text: text,
        image: imageUrl,
        video: videoUrl);
    await VideoFireStore().addComment(newComment: newComment, videoId: videoId)
        // .then(
        // (value) => NotificationViewModel().addNotification(
        //     action: NotificationModel.comment,
        //     postId: newComment.postId!,
        //     time: newComment.time!,
        //     commentId: value))
        ;
  }

  ///            reactions

  reactVideo({required String videoId, required reactions reaction}) {
    String react = reaction.name;
    videoFireStore.reactVideo(videoId: videoId, react: react);
  }

  Stream<reactions> getVideoReact({required String videoId}) {
    return videoFireStore.getVideoReact(videoId: videoId).map((react) =>
        reactions.values.firstWhere((element) => element.name == react));
  }

  Stream<List<reactions>> getVideoReacts({required String videoId}) {
    return videoFireStore.getVideoReacts(videoId: videoId).map((event) => [
          ...[
            ...event.map((reactStr) => reactions.values
                .firstWhere((element) => element.name == reactStr))
          ].where(
              (element) => element != reactions.non) // remove non from reacts
        ]);
  }

  Stream<int> getAllReactsCount({required String videoId}) {
    return getVideoReacts(videoId: videoId).map((event) => event.length);
  }
}
