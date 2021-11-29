import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:musicplayer/Controller/database_controller.dart';
import 'package:musicplayer/Controller/functions.dart';
import 'package:musicplayer/Controller/track_controller.dart';
import 'package:musicplayer/colors.dart' as app_colors;

import 'open_playlist_screen.dart';
import '../../Model/db/Playlist/db_helper_pla.dart';

class CreateOrSelect extends StatelessWidget {
  final String songData;
  final int songId;
  final String songTitle;

   CreateOrSelect(this.songData,this.songId,this.songTitle,{Key? key}) : super(key: key);
  TrackPageController trackPageController = Get.put(TrackPageController());
  DbController dbController = Get.put(DbController());
  FunctionsController functionsController = Get.put(FunctionsController());
  final folderController = TextEditingController();
  late String playlistName;
  var folderName;
  int playlistFolderId = 0;
  int playlistFolderId1 = 0;

  @override
  Widget build(BuildContext context) {
    final double heights = MediaQuery.of(context).size.height;
    final double widths = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        backgroundColor: app_colors.shade,
        appBar: AppBar(
          leadingWidth: 30,
          leading: IconButton(
            padding: const EdgeInsets.only(left: 20, top: 16),
            color: Colors.white,
            alignment: Alignment.topLeft,
            onPressed: () {
              Get.back();
            },
            icon: const Icon(Icons.arrow_back_ios),
          ),
          title: const Text(
            'Add to',
            style: TextStyle(
                color: Colors.white, fontSize: 25, fontFamily: 'Title'),
          ),
          backgroundColor: app_colors.back,
          elevation: 0,
        ),
        body: Stack(
          children: [
            Container(
              padding: const EdgeInsets.only(top: 50),
              child: GetBuilder<DbController>(
                builder: (controller) {
                  return FutureBuilder(
                    future: dbController.playlistHandler.retrievePlaylist(),
                    builder: (BuildContext context,
                        AsyncSnapshot<List<PlaylistModel>> snapshot) {
                      if (snapshot.hasData) {
                        return ListView.builder(
                          itemCount: snapshot.data?.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Column(
                              children: [
                                ListTile(
                                  onTap: () {
                                    functionsController.showToast('Songs Added');
                                      playlistFolderId1 = snapshot.data![index].id!;
                                 controller.update();
                                    dbController.addSongsToPlaylist(
                                       songId,
                                        playlistFolderId1,
                                       songTitle,
                                        songData);
                                    Get.off(
                                      OpenPlaylist(snapshot.data![index].id!),
                                    );
                                  },
                                  leading: const Icon(
                                    Icons.folder_open,
                                    size: 55,
                                    color: Colors.grey,
                                  ),
                                  title: Text(
                                    snapshot.data![index].playListName,
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 17),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                  subtitle: Text(
                                    snapshot.data![index].playListName,
                                    style: const TextStyle(color: Colors.grey),
                                  ),
                                ),
                                const Divider(
                                  height: 0,
                                  indent: 85,
                                  color: Colors.grey,
                                ),
                              ],
                            );
                          },
                        );
                      } else {
                        return const Center(child: CircularProgressIndicator());
                      }
                    },
                  );
                }
              ),
              width: widths,
              decoration: const BoxDecoration(color: app_colors.shade),
            ),

            /// shadedHolllow///
            Positioned(
              top: heights / 2000,
              right: 0,
              left: 0,
              height: heights / 12,
              child: Container(
                child: ColorFiltered(
                  colorFilter:
                      const ColorFilter.mode(app_colors.back, BlendMode.srcOut),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                            color: app_colors.shade,
                            backgroundBlendMode: BlendMode
                                .dstOut), // This one will handle background +
                        // difference out
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 40),
                        height: heights,
                        width: widths,
                        decoration: const BoxDecoration(
                          color: app_colors.shade,
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(30),
                            topLeft: Radius.circular(30),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: heights / 35,
              right: 25,
              child: CircleAvatar(
                backgroundColor: app_colors.back,
                radius: 30,
                child: IconButton(
                  icon: const Icon(
                    Icons.add,
                    color: Colors.white,
                    size: 35,
                  ),
                  onPressed: () {
                    _showMyDialog(
                        songData,songTitle,songId,context);
                  },
                ),
                // decoration: ShapeDecoration(
                //     color: AppColors.back, shape: CircleBorder()),
                // height: 65,
                // width: 65,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showMyDialog(var songData, var songTitle, var songId,context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Create a playlist',
            textAlign: TextAlign.left,
            style: TextStyle(color: Colors.white, fontFamily: 'Title'),
          ),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return TextField(
                maxLength: 12,
                style: const TextStyle(color: Colors.white),
                controller: folderController,
                autofocus: true,
                decoration: const InputDecoration(
                    hintText: 'Enter folder name',
                    hintStyle: TextStyle(color: Colors.grey)),
                onChanged: (val) {
                  setState(() {
                    playlistName = folderController.text;
                  });
                },
              );
            },
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  alignment: Alignment.bottomLeft,
                  child: TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'Cancel',
                      style: TextStyle(
                          fontSize: 20,
                          fontFamily: 'Title',
                          color: Colors.white),
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.bottomRight,
                  child: TextButton(
                    onPressed: () {
                      ///
                      ///
                      /// //
                      ///
                        folderName = playlistName;
                        dbController.addPlaylist(folderName);
                        dbController.addSongsToPlaylist(
                            songId,
                            playlistFolderId,
                           songTitle,
                            songData);

                      Navigator.pop(context);
                    },
                    child: const Text(
                      'Create',
                      style: TextStyle(
                          fontSize: 20,
                          fontFamily: 'Title',
                          color: Colors.white),
                    ),
                  ),
                )
              ],
            ),
          ],
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          backgroundColor: app_colors.back,
        );
      },
    );
  }
}
