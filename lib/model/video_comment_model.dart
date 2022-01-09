import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smile/utils/constants.dart';

class VideoCommentModel {
  String? id;
  String? videoId;
  String? owner;
  String? text;
  String? image;
  String? video;
  Timestamp? time;
  List<dynamic>? loves;

  VideoCommentModel(
      {this.id,
        this.videoId,
        this.text,
        this.video,
        this.image,
        this.owner,
        this.time,
        this.loves});

  VideoCommentModel.formFire({required Map<String, dynamic> map, required this.id})
      : text = map[fieldCommentText],
        owner = map[fieldCommentOwner],
        videoId = map[fieldCommentVideoId],
        image = map[fieldCommentImage],
        video = map[fieldCommentVideo],
        time = map[fieldCommentTime],
        loves = map[fieldCommentLoves];

  Map<String, dynamic> toFire() {
    return {
      fieldCommentText: text,
      fieldCommentOwner: owner,
      fieldCommentVideoId: videoId,
      fieldCommentImage: image,
      fieldCommentVideo: video,
      fieldCommentTime: time,
      fieldCommentLoves: loves
    };
  }

  VideoCommentModel.formJson({required Map<String, dynamic> json})
      : id = json[fieldCommentId],
        text = json[fieldCommentText],
        owner = json[fieldCommentOwner],
        videoId = json[fieldCommentVideoId],
        image = json[fieldCommentImage],
        video = json[fieldCommentVideo],
        time = json[fieldCommentTime],
        loves = json[fieldCommentLoves];

  Map<String, dynamic> toJson() {
    return {
      fieldCommentId: id,
      fieldCommentText: text,
      fieldCommentOwner: owner,
      fieldCommentVideoId: videoId,
      fieldCommentImage: image,
      fieldCommentVideo: video,
      fieldCommentTime: time,
      fieldCommentLoves: loves
    };
  }
}
