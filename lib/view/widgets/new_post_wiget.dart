import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smile/view/pages/create_post_page.dart';
import 'package:smile/view/pages/sign_in_page.dart';
import 'package:smile/view/widgets/profile_circle_avatar.dart';
import 'package:smile/view_model/auth_view_model.dart';

class NewPostWidget extends StatelessWidget {
  NewPostWidget({Key? key, this.showProfile = false}) : super(key: key);

  bool showProfile;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          showProfile
              ? Padding(
                  padding: const EdgeInsets.all(8),
                  child: ProfileCircleAvatar(
                    radius: 20,
                    imageUrl: Get.find<AuthViewModel>().currentUser!.profileUrl,
                  ))
              : Container(),
          Expanded(
            child: GestureDetector(
              onTap: () {
                if (Get.find<AuthViewModel>()
                    .currentUser!
                    .isAnonymous!) {

                  Get.to(SignInPage(),
                      transition: Transition.downToUp);
                } else
                Get.to(CreatePostPage());
              },
              child: Container(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  'ًWrite Your Post'.tr,
                ),
                decoration: BoxDecoration(
                    border: Border.all(
                        width: 1,
                        color: Theme.of(context).colorScheme.secondary),
                    borderRadius: BorderRadius.circular(30)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
