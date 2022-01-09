import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:smile/utils/langs/translation.dart';
import 'package:smile/utils/themes/dark_theme.dart';
import 'package:smile/utils/themes/light_theme.dart';
import 'package:smile/view/pages/comments_screen.dart';
import 'package:smile/view/pages/intro.dart';
import 'package:smile/view/pages/main_view.dart';
import 'package:smile/view_model/auth_view_model.dart';
import 'package:smile/view_model/home_view_model.dart';
import 'package:smile/view_model/main_navigator_view_model.dart';
import 'package:smile/view_model/settings_view_model.dart';

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  RequestConfiguration addConfig = RequestConfiguration(
      testDeviceIds: <String>['5b06a7b3-2669-4c5f-b582-1d733d04727b']);
  MobileAds.instance.updateRequestConfiguration(addConfig);
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  await Firebase.initializeApp();
  Get.put(HomeViewModel(), permanent: true);
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print(
        'Got a...................................................................... message whilst in the foreground!');
    print('Message data: ${message.data}');

    if (message.notification != null) {
      print('Message also contained a notification: ${message.notification}');
    }
  });
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
    print("onMessageOpenedApp: $message");

    if (message.data["navigation"] == "/your_route") {
      int _yourId = int.tryParse(message.data["id"]) ?? 0;
      // Navigator.push(
      //     navigatorKey.currentState!.context,
      //     MaterialPageRoute(
      //         builder: (context) => YourScreen(
      //           yourId:_yourId,
      //         )
      //     ));
    }
  });

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
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
              navigatorKey: navigatorKey,
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

  @override
  void initState() {
    FirebaseMessaging.onMessage.forEach((remoteMessage) {
      print(
          '****************************************************************${remoteMessage.notification?.title}');
      ;
    });
    FirebaseMessaging.onMessageOpenedApp.forEach((remoteMessage) {
      String id = remoteMessage.data["id"];
      String action = remoteMessage.data["action"];
      if(action == "comment_post_commenter"){
        Get.to(CommentsScreen(postId: id));
      }
    });
    FirebaseMessaging.onBackgroundMessage((remoteMessage)async {
      String id = remoteMessage.data["id"];
      String action = remoteMessage.data["action"];
      if(action == "comment_post_commenter"){
        Get.to(CommentsScreen(postId: id));
      }
    });
  }
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();

  print("Handling a background message: ${message.messageId}");
}
