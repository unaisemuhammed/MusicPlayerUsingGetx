import 'package:musicplayer/Controller/database_controller.dart';
import 'package:musicplayer/Model/db/Playlist/db_helper_pla.dart';
import 'package:musicplayer/View/Playlist/open_playlist_screen.dart';
import 'package:musicplayer/View/Playlist/select_song_through_dialogue_box.dart';
import 'package:musicplayer/colors.dart' as app_colors;
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class Playlist extends StatelessWidget {
  Playlist({Key? key}) : super(key: key);

  DbController dbController = Get.put(DbController());

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    // final double width = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        backgroundColor: app_colors.shade,
        body: GetBuilder<DbController>(builder: (controller) {
          return Container(
            padding: const EdgeInsets.only(bottom: 0, top: 10),
            child: Stack(
              children: [
                Positioned(
                  child: FutureBuilder(
                    future: dbController.playlistHandler.retrievePlaylist(),
                    builder: (BuildContext context,
                        AsyncSnapshot<List<PlaylistModel>> snapshot) {
                      if (snapshot.hasData) {
                        return GridView.builder(
                            itemCount: snapshot.data?.length,
                            gridDelegate:
                                const SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: 180,
                              mainAxisSpacing: 10,
                              crossAxisSpacing: 0,
                            ),
                            itemBuilder: (context, index) {
                              dbController.playlistFolderId =
                                  snapshot.data![index].id!;
                              return Container(
                                padding: const EdgeInsets.all(6),
                                child: Stack(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        Get.to(
                                          OpenPlaylist(
                                              snapshot.data![index].id!),
                                        );
                                      },
                                      onLongPress: () {
                                        final dataId =
                                            snapshot.data![index].id!;
                                        final dataIndex = snapshot.data![index];
                                        final data = snapshot.data;
                                        deleteBox(
                                            dataId, data, dataIndex, context);
                                        controller.update();
                                      },
                                      child: Column(
                                        children: [
                                          Container(
                                            width: double.infinity,
                                            padding: const EdgeInsets.all(5),
                                            child: const Icon(
                                              Icons.music_note_outlined,
                                              size: 70,
                                              color: Colors.grey,
                                            ),
                                            decoration: BoxDecoration(
                                              color: app_colors.back,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                          ),
                                          Text(
                                            '${snapshot.data![index].playListName}',
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 20,
                                                fontFamily: 'Title'),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            });
                      } else {
                        return const Center(child: CircularProgressIndicator());
                      }
                    },
                  ),
                ),
                Positioned(
                  bottom: height / 35,
                  right: 30,
                  child: Ink(
                    child: IconButton(
                      icon: const Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 50,
                      ),
                      onPressed: () {
                        showCreateBox(dbController.playlistFolderId, context);
                        controller.update();
                      },
                    ),
                    decoration: const ShapeDecoration(
                        color: app_colors.back, shape: CircleBorder()),
                    height: 65,
                    width: 65,
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  Future<void> showCreateBox(playlistFolderId, context) async {
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
                controller: dbController.folderController,
                autofocus: true,
                decoration: const InputDecoration(
                    hintText: 'Enter folder name',
                    hintStyle: TextStyle(color: Colors.grey)),
                onChanged: (val) {
                  setState(() {
                    dbController.playlistName =
                        dbController.folderController.text;
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
                      Get.back();
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
                GetBuilder<DbController>(builder: (controller) {
                  return Container(
                    alignment: Alignment.bottomRight,
                    child: TextButton(
                      onPressed: () {
                        dbController.folderName = dbController.playlistName;
                        dbController.addPlaylist(dbController.folderName);

                        dbController.folderController.clear();
                        dbController.playlistName = '';
                        controller.update();
                        Get.off(SelectTrack(playlistId: playlistFolderId));
                      },
                      child: const Text(
                        'Create',
                        style: TextStyle(fontSize: 20, fontFamily: 'Title', color: Colors.white),),),);
                },),
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

  Future<void> deleteBox(var dataId, var data, var dataIndex, context) async {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      // user must tap button!
      builder: (BuildContext context) {
        return GetBuilder<DbController>(builder: (controller) {
          return AlertDialog(
            backgroundColor: app_colors.back,
            title: const Text(
              'Are you sure to delete this '
              'folder?',
              style: TextStyle(color: Colors.white, fontFamily: 'Title'),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Yes',
                    style: TextStyle(fontSize: 18, fontFamily: 'Title')),
                onPressed: () async {
                  await dbController.playlistHandler.deletePlaylist(dataId);
                  data.remove(dataIndex);
                  Get.back();
                  controller.update();
                },
              ),
              TextButton(
                child: const Text(
                  'No',
                  style: TextStyle(fontSize: 18, fontFamily: 'Title'),
                ),
                onPressed: () {
                  Get.back();
                },
              ),
            ],
          );
        });
      },
    );
  }
}
