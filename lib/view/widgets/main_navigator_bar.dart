import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smile/view/pages/add_video_page.dart';
import 'package:smile/view/pages/discover_page.dart';
import 'package:smile/view/pages/home.dart';
import 'package:smile/view/pages/notifications_page.dart';
import 'package:smile/view/pages/profile_page.dart';
import 'package:smile/view/widgets/up_route.dart';
import 'package:smile/view_model/auth_view_model.dart';
import 'package:smile/view_model/main_navigator_view_model.dart';

class MainNavigatorBar extends StatelessWidget {
  const MainNavigatorBar({Key? key}) : super(key: key);
  static double height = 50.0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: height,
      child: GetBuilder<MainNavigatorViewModel>(builder: (mainNavigator) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ///home
            IconButton(
                padding: EdgeInsets.zero,
                onPressed: () {
                  mainNavigator.change(Homepage());
                },
                icon: navigateIcon(
                    context,
                    mainNavigator.currentPage.runtimeType ==
                            Homepage().runtimeType
                        ? Icons.home
                        : Icons.home_outlined,
                    color: mainNavigator.currentPage.runtimeType ==
                            Homepage().runtimeType
                        ? Colors.white
                        : Colors.grey)),

            /// discover
            IconButton(
                padding: EdgeInsets.zero,
                onPressed: () {
                  mainNavigator.change(DiscoverPage());
                },
                icon: navigateIcon(context, Icons.tag,
                    color: mainNavigator.currentPage.runtimeType ==
                            DiscoverPage().runtimeType
                        ? Theme.of(context).colorScheme.secondary
                        : Colors.grey)),

            ///add
            IconButton(
                padding: EdgeInsets.zero,
                onPressed: () {
                  if (!Get.find<AuthViewModel>().currentUser!.isAnonymous!) {
                    Navigator.of(context).push(
                        DirecteRoute(const AddVideoPage(), routeDirection.up));
                  }
                  Get.find<MainNavigatorViewModel>().change(ProfilePage());
                },
                icon: navigateIcon(
                  context,
                  Icons.add_circle_outline,
                )),

            /// notifications
            IconButton(
                padding: EdgeInsets.zero,
                onPressed: () {
                  mainNavigator.change(const NotificationsPage());
                },
                icon: navigateIcon(
                  context,
                  mainNavigator.currentPage.runtimeType ==
                          const NotificationsPage().runtimeType
                      ? Icons.notifications
                      : Icons.notifications_outlined,
                )),
            IconButton(
                padding: EdgeInsets.zero,
                onPressed: () {
                  mainNavigator.change(ProfilePage());
                },
                icon: navigateIcon(
                  context,
                  mainNavigator.currentPage.runtimeType ==
                          ProfilePage().runtimeType
                      ? Icons.person
                      : Icons.person_outline,
                )),
          ],
        );
      }),
    );
  }

  Widget navigateIcon(BuildContext context, IconData icon, {Color? color}) {
    color = color ?? Theme.of(context).colorScheme.secondary;
    if (icon.codePoint == Icons.home_outlined.codePoint ||
        icon.codePoint == Icons.tag_outlined.codePoint ||
        icon.codePoint == Icons.add_circle_outline.codePoint ||
        icon.codePoint == Icons.notifications_outlined.codePoint ||
        icon.codePoint == Icons.person_outline.codePoint) {
      color = Colors.grey;
    }
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Icon(
        icon,
        size: height - 16,
        color: color,
      ),
    );
  }
}
