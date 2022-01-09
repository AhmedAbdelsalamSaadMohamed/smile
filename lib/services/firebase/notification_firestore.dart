import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:smile/model/notification_model.dart';
import 'package:smile/utils/constants.dart';
import 'package:smile/view_model/auth_view_model.dart';

class NotificationFireStore {
  String currentUserId = Get.find<AuthViewModel>().currentUser!.id!;

  Stream<List<NotificationModel>> getUserNotifications() {
    return FirebaseFirestore.instance
        .collection(collectionUsers)
        .doc(currentUserId)
        .collection(collectionNotifications).orderBy(fieldNotificationTime, descending: true)
        .snapshots()
        .map((event) {
      return [
        ...event.docs.map((e) {
          NotificationModel notification = NotificationModel.fromJson(e.data());
          notification.id = e.id;
          return notification;
        })
      ];
    });
  }

  seeNotification({required NotificationModel notification}) {
    notification.isSeem = true;
    FirebaseFirestore.instance
        .collection(collectionUsers)
        .doc(currentUserId)
        .collection(collectionNotifications)
        .doc(notification.id)
        .update(notification.toJson());
  }
  viewNotification({required NotificationModel notification}) {
    notification.isNew = false;
    FirebaseFirestore.instance
        .collection(collectionUsers)
        .doc(currentUserId)
        .collection(collectionNotifications)
        .doc(notification.id)
        .update(notification.toJson());
  }
  Stream<int> newNotificationsCount() {
    return FirebaseFirestore.instance
        .collection(collectionUsers)
        .doc(currentUserId)
        .collection(collectionNotifications)
        .where(fieldNotificationIsNew, isEqualTo: true)
        .snapshots()
        .map((event) => event.docs.length);
  }
}
