import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:smile/model/notification_model.dart';
import 'package:smile/services/firebase/notification_firestore.dart';

class NotificationViewModel extends GetxController {
  Stream<List<NotificationModel>> getUserNotifications() {
    return NotificationFireStore().getUserNotifications();

    // .map((event) => [
    //   ...event.map((e) {
    //     return NotificationToView();
    //   })
    // ]);
  }

  seeNotification({required NotificationModel notification}) {
    NotificationFireStore().seeNotification(notification: notification);
  }

  viewNotification({required NotificationModel notification}) {
    NotificationFireStore().viewNotification(notification: notification);
  }

  Stream<int> newNotificationsCount() {
    return NotificationFireStore().newNotificationsCount();
  }
  String getText(String action) {
    if (action == 'comment_post_commenter') {
      return 'Comment on the same post your are comments';
    }
    if (action == 'comment_video_commenter') {
      return 'Comment on the same video your are comments';
    }
    if(action == "upload_video"){
      return 'Upload a new Video';
    }
    return action;
  }
}

class NotificationToView {
  Timestamp? time;
  String? text;
  String? profileUrl;
}
