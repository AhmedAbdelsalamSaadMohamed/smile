import 'package:smile/utils/constants.dart';

class TagModel {
  String? id;
  String? tag;
  String? videoId;

  TagModel({this.id, this.tag, this.videoId});

  TagModel.fromJson(Map<String, dynamic> json)
      : id = json[fieldTagId],
        tag = json[fieldTag],
        videoId = json[fieldVideoId];

  toJson() => {fieldTagId: id, fieldTag: tag, fieldVideoId: videoId};
}
