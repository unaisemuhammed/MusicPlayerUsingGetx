import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:musicplayer/View/splash_screen.dart';
import 'package:musicplayer/colors.dart' as app_colors;
import 'Controller/database_controller.dart';
import 'Controller/functions.dart';
import 'Controller/track_controller.dart';

TrackPageController trackPageController = Get.put(TrackPageController());
DbController dbController = Get.put(DbController());
FunctionsController functionsController = Get.put(FunctionsController());
Future<void> main() async {
  await JustAudioBackground.init(androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
    androidNotificationChannelName: 'Audio playback', androidNotificationOngoing: true, notificationColor:app_colors.back,);
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);runApp(const MyApp());
}

class MyApp extends StatelessWidget {const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(debugShowCheckedModeBanner: false, home: Scaffold(backgroundColor: app_colors.back, body: SplashScreen (),),);
  }
}
