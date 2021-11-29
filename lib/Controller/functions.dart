import 'package:musicplayer/colors.dart' as app_colors;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../main.dart';

class FunctionsController extends GetxController {
  void showToast(String msg) =>
      Fluttertoast.showToast(
          msg: '$msg',
          fontSize: 18,
          backgroundColor: app_colors.back);


  ///SearchPage

}