class NotificationModel {
  String? id;
  String? action;
  String? userId;
  String? time;
  String? videoId;
  String? commentId;
  String? postId;
  String? replayId;

  NotificationModel({this.id,
    this.action,
    this.userId,
    this.time,
    this.videoId,
    this.commentId,
    this.postId,
    this.replayId});

  NotificationModel.fromJson(Map<String, dynamic> json) :
        this.id =json['']
  ;
}
