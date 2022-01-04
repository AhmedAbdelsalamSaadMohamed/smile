import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smile/utils/constants.dart';

class ReportModel {
  String? id;
  String? reason;
  String? videoId;
  String? userId;
  Timestamp? time;

  ReportModel({this.id, this.reason, this.videoId, this.userId, this.time});

  ReportModel.fromJson(Map<String, dynamic> json)
      : id = json[fieldReportId],
        reason = json[fieldReportReason],
        videoId = json[fieldReportVideoId],
        userId = json[fieldReportUserId],
        time = json[fieldReportTime];

  Map<String, dynamic> toJson() => {
        fieldReportId: id,
        fieldReportReason: reason,
        fieldReportVideoId: videoId,
        fieldReportUserId: userId,
        fieldReportTime: time
      };
}
