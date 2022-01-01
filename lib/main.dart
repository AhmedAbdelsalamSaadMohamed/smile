import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:smile/utils/langs/translation.dart';
import 'package:smile/utils/themes/dark_theme.dart';
import 'package:smile/utils/themes/light_theme.dart';
import 'package:smile/view/pages/intro.dart';
import 'package:smile/view/pages/main_view.dart';
import 'package:smile/view_model/auth_view_model.dart';
import 'package:smile/view_model/home_view_model.dart';
import 'package:smile/view_model/main_navigator_view_model.dart';
import 'package:smile/view_model/settings_view_model.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  RequestConfiguration addConfig = RequestConfiguration(
      testDeviceIds: <String>['5b06a7b3-2669-4c5f-b582-1d733d04727b']);
  MobileAds.instance.updateRequestConfiguration(addConfig);
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  await Firebase.initializeApp();
  Get.put(HomeViewModel(), permanent: true);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SettingsViewModel settingsViewModel = Get.put(SettingsViewModel());
    Get.put(MainNavigatorViewModel());
    AuthViewModel authViewModel = Get.put(AuthViewModel());

    return FutureBuilder<String>(
        future: settingsViewModel.getLanguage(),
        builder: (context, snapshot) {
          String languageStr;
          if (snapshot.hasError || !snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            languageStr = snapshot.data!;
            return GetMaterialApp(
              smartManagement: SmartManagement.keepFactory,
              debugShowCheckedModeBanner: false,
              theme: lightTheme,
              darkTheme: darkTheme,
              themeMode: Get.find<SettingsViewModel>().isDark.value
                  ? ThemeMode.dark
                  : ThemeMode.light,
              translations: Translation(),
              locale: Locale(languageStr),
              title: 'Smile',
              home: FutureBuilder<bool>(
                  future: authViewModel.isSigned(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return const Intro();
                    } else if (!snapshot.hasData) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      return snapshot.data! ? MainView() : Intro();
                    }
                  }),
            );
          }
        });
  }
}
