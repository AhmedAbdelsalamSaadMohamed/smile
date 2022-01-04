import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:smile/view_model/video_view_model.dart';

class ReportPage extends StatelessWidget {
  const ReportPage({Key? key, required this.videoId}) : super(key: key);
  final String videoId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Report'.tr),
      ),
      body: ListView(
        children: [
          _reason('Dangerous organizations and individuals'.tr),
          _reason('Illegal activity and regulated goods'.tr),
          _reason('Frauds and scams'.tr),
          _reason('Violent and graphic content'.tr),
          _reason('Animal cruelty'.tr),
          _reason('Suicide, self-harm, and dangerous acts'.tr),
          _reason('Hate speech'.tr),
          _reason('Harassment or bullying'.tr),
          _reason('Pornography and nudity'.tr),
          _reason('Minor safety'.tr),
          _reason('Spam'.tr),
          _reason('Intellectual Property infringement'.tr),
        ],
      ),
    );
  }
  _reason(String reason) {
   return ListTile(
      title: Text(reason),
      onTap: () {
        VideoViewModel().reportVideo(videoId: videoId, reason: reason);
        Get.back();
      },
    );
  }
}

