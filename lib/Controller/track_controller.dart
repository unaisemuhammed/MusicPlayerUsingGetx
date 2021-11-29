import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:musicplayer/Model/db/Favourite/helper.dart';
import 'package:musicplayer/View/controller_playlist_fav.dart';
import 'package:musicplayer/View/music_controll_page.dart';
import 'package:musicplayer/main.dart';
import 'package:on_audio_query/on_audio_query.dart';

class TrackPageController extends GetxController {
  final OnAudioQuery audioQuery = OnAudioQuery();
  final GlobalKey<MusicControllerState> key = GlobalKey<MusicControllerState>();
  final GlobalKey<MusicControllerPlayAndFavState> key2 =
      GlobalKey<MusicControllerPlayAndFavState>();
  final AudioPlayer player = AudioPlayer();
  List<SongModel> tracks = [];
  int currentIndex = 0;
  double minimumValue = 0.0, maximumValue = 0.0, currentValue = 0.0;
  String currentTime = '', endTime = '';
  bool isPlaying = false;
  dynamic songTitle;
  dynamic songId;
  dynamic songLocation;
  int fav = 0;

  void requestPermission() async {
    // Web platform don't support permissions methods.
    if (!kIsWeb) {
      final bool permissionStatus = await audioQuery.permissionsStatus();
      if (!permissionStatus) {
        await audioQuery.permissionsRequest();
      }
      update();
    }
  }

  void getTracks() async {
    tracks = await audioQuery.querySongs();
    tracks = tracks;
    update();
  }

  void changeTrack(bool isNext) {
    if (isNext) {
      if (currentIndex != tracks.length - 1) {
        currentIndex++;
      }
    } else {
      if (currentIndex != 0) {
        currentIndex--;
      }
    }
    key.currentState!.setSong(tracks[currentIndex]);
  }

  @override
  void onInit() {
    // TODO: implement onInit
    requestPermission();
    getTracks();
     player.play();
    super.onInit();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    player.dispose();
    super.onClose();
  }
}
