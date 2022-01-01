import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smile/utils/constants.dart';

class PostModel {
  String? postId;
  String? ownerId;
  String? postText;
  Timestamp? postTime;
  List<dynamic>? imagesUrls;
  List<dynamic>? comments;
  List<dynamic>? loves;
  List<dynamic>? shares;

  PostModel(
      {this.postId,
      this.ownerId,
      this.postText,
      this.imagesUrls,
      this.comments,
      this.loves,
      this.shares,
      this.postTime});

  PostModel.fromFire(Map<String, dynamic> json, this.postId) {
    ownerId = json[fieldPostOwnerId];
    postText = json[fieldPostText];
    imagesUrls = json[fieldPostImagesUrls];
    comments = json[tableComments];
    loves = json[fieldPostLovesIds];
    postTime = json[fieldPostTime];
    shares = json[fieldPostSharesIds];
  }

  Map<String, dynamic> toFire() {
    return {
      fieldPostOwnerId: ownerId,
      fieldPostText: postText,
      fieldPostImagesUrls: FieldValue.arrayUnion(imagesUrls!),
      fieldPostTime: postTime
    };
  }

// PostModel.fromJson(Map<dynamic, dynamic> json) {
//   postId = json[fieldPostId];
//   ownerId = json[fieldPostOwnerId];
//   postText = json[fieldPostText];
//   imagesUrls = json[fieldPostImagesUrls];
//   videoUrl = json[fieldPostVideoUrl];
//   comments = json[fieldPostCommentsIsd];
//   loves = json[fieldPostLovesIds];
//   postTime = json[fieldPostTime];
// }
}
