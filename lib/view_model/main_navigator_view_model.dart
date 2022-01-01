import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:smile/view/pages/home.dart';
import 'package:smile/view_model/settings_view_model.dart';

class MainNavigatorViewModel extends GetxController{
  
  Widget currentPage = Homepage();
  final SettingsViewModel __themeViewModel = Get.put(SettingsViewModel());
  change(Widget newPage){
    //Get.find<VideoPlayerViewModel>().videoPlayerController.pause();
    currentPage = newPage;
    //_themeViewModel.onNavigate(newPage.runtimeType == Homepage().runtimeType);
    update();
  }

}
