import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:musicplayer/Model/db/Favourite/db_helper.dart';
import 'package:musicplayer/Model/db/Favourite/helper.dart';
import 'package:musicplayer/Model/db/Playlist/db_helper_pla.dart';
import 'package:musicplayer/Model/db/Playlist/helper_play.dart';

class DbController extends GetxController {
  final folderController = TextEditingController();
  late PlaylistDatabaseHandler playlistHandler;
  DatabaseHandler? handler;
  late PlaylistDatabaseHandler songAddHandler;
  late String playlistName;
  var folderName;
  int playlistFolderId = 0;



  Future<int> addToFav(
      String songTitle, int songId, String songLocation) async {
    final Songs firstUser =
        Songs(name: songTitle, num: songId, location: songLocation);
    final List<Songs> listOfUsers = [firstUser];
    debugPrint('addSongsToFavourite:$songTitle');
    debugPrint('addSongsToFavourite: $songId');
    debugPrint('addSongsToFavourite: $songLocation');
    return await handler!.insertFavSongs(listOfUsers);
  }

  Future<int> addPlaylist(String folderName) async {
    final PlaylistModel firstUser = PlaylistModel(playListName: folderName);
    final List<PlaylistModel> listOfUsers = [firstUser];
    debugPrint('addPlaylistName:$folderName');
    return await playlistHandler.insertPlaylist(listOfUsers);
  }

  Future<int> addSongsToPlaylist(
      var songID, var playlistID, var songName, var path) async {
    final PlayListSong firstUser = PlayListSong(
        songID: songID, playlistID: playlistID, songName: songName, path: path);
    final List<PlayListSong> listOfUsers = [firstUser];
    return await songAddHandler.insertSongs(listOfUsers);
  }

  @override
  void onInit() {
    // TODO: implement onInit
    handler = DatabaseHandler();
    playlistHandler = PlaylistDatabaseHandler();
    songAddHandler = PlaylistDatabaseHandler();
    super.onInit();
  }
  @override
  void onClose() {
    // TODO: implement onClose
    folderController.dispose();
    super.onClose();
  }
}
