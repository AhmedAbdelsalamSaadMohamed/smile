import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smile/utils/constants.dart';

class VideoModel {
  String? id;
  String? name;
  String? url;
  String? ownerId;
  String? description;
  Timestamp? time;
  String? imageUrl;

  VideoModel(
      {this.id,
      this.name,
      this.url,
      this.ownerId,
      this.description,
      this.time,
      this.imageUrl});

  VideoModel.fromJson(Map<String, dynamic> json)
      : id = json[fieldVideoId],
        name = json[fieldVideoName],
        url = json[fieldVideoUrl],
        description = json[fieldVideoDescription],
        ownerId = json[fieldVideoOwnerId],
        time = json[fieldVideoTime],
        imageUrl = json[fieldVideoImageUrl];

  Map<String, dynamic> toJson() => {
        fieldVideoId: id,
        fieldVideoName: name,
        fieldVideoOwnerId: ownerId,
        fieldVideoDescription: description,
        fieldVideoUrl: url,
        fieldVideoTime: time,
        fieldVideoImageUrl: imageUrl
      };
}
