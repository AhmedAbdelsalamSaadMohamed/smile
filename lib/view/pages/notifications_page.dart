import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:smile/model/notification_model.dart';
import 'package:smile/view/widgets/notification_widget.dart';
import 'package:smile/view_model/notification_view_model.dart';

class NotificationsPage extends StatelessWidget {
   NotificationsPage({Key? key}) : super(key: key);
final NotificationViewModel notificationViewModel = NotificationViewModel();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'.tr),
      ),
      body: StreamBuilder<List<NotificationModel>>(
        stream: notificationViewModel.getUserNotifications(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Container(
              child: Text(snapshot.error.toString()),
            );
          }
          if (!snapshot.hasData) {
            return Center(
              child: Text('Loading...'.tr),
            );
          }
          if (snapshot.data!.length == 0) {
            return Center(
              child: Text('No Notifications'),
            );
          }
          snapshot.data!.forEach((element) {
            notificationViewModel.viewNotification(notification: element);
          });
          return ListView.builder(
            itemCount: snapshot.data!.length ,
            itemBuilder: (context, index) {
              return NotificationWidget(notification: snapshot.data![index],);
            },
          );
        },
      ),
    );
  }
}
