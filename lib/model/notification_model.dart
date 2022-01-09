import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smile/utils/constants.dart';

class NotificationModel {
  String? id;
  String? action;
  String? userId;
  Timestamp? time;
  String? videoId;
  String? postId;
  String? videoCommentId;
  String? postCommentId;
  String? postReplayId;
  String? videoReplayId;
  bool? isSeem;
  bool? isNew;

  NotificationModel(
      {this.id,
      this.action,
      this.userId,
      this.time,
      this.videoId,
      this.postId,
      this.postCommentId,
      this.postReplayId,
      this.videoCommentId,
      this.videoReplayId,
      this.isNew,
      this.isSeem});

  NotificationModel.fromJson(Map<String, dynamic> json)
      : this.id = json[fieldNotificationId],
        this.action = json[fieldNotificationAction],
        this.userId = json[fieldNotificationUserId],
        this.time = json[fieldNotificationTime],
        this.videoId = json[fieldNotificationVideoId],
        this.postId = json[fieldNotificationPostId],
        this.videoCommentId = json[fieldNotificationVideoCommentId],
        this.postCommentId = json[fieldNotificationPostCommentId],
        this.postReplayId = json[fieldNotificationPostReplyId],
        this.videoReplayId = json[fieldNotificationVideoReplyId],
        this.isSeem = json[fieldNotificationIsSeen],
        this.isNew = json[fieldNotificationIsNew];

  toJson() => {
        fieldNotificationId: this.id,
        fieldNotificationAction: this.action,
        fieldNotificationUserId: this.userId,
        fieldNotificationTime: this.time,
        fieldNotificationVideoId: this.videoId,
        fieldNotificationPostId: this.postId,
        fieldNotificationVideoCommentId: this.videoCommentId,
        fieldNotificationPostCommentId: this.postCommentId,
        fieldNotificationPostReplyId: this.postReplayId,
        fieldNotificationVideoReplyId: this.videoReplayId,
        fieldNotificationIsSeen: this.isSeem,
        fieldNotificationIsNew: this.isNew
      };
}
