import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:smile/view/widgets/main_navigator_bar.dart';
import 'package:smile/view_model/main_navigator_view_model.dart';

import 'home.dart';

class MainView extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return SafeArea(
        child: GetBuilder<MainNavigatorViewModel>(
            builder: (mainNavigator) {
              return Scaffold(
                backgroundColor: mainNavigator.currentPage.runtimeType ==
                        Homepage().runtimeType
                    ? Colors.black
                    : Theme.of(context).colorScheme.background,
                body: Column(
                  children: [
                    Expanded(
                      child: mainNavigator.currentPage,
                    ),
                    MainNavigatorBar()
                  ],
                ),
              );
            }));
  }
}

class BodyWidget extends StatelessWidget {
  const BodyWidget({Key? key, required this.child}) : super(key: key);
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height -
          (MediaQuery.of(context).padding.top +
              MediaQuery.of(context).padding.bottom +
              MainNavigatorBar.height),
      child: child,
    );
  }
}
