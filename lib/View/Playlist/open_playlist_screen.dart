import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:musicplayer/Controller/database_controller.dart';
import 'package:musicplayer/Controller/functions.dart';
import 'package:musicplayer/Controller/track_controller.dart';
import 'package:musicplayer/View/Playlist/select_song_to_playlists_through_inside_folder.dart';
import 'package:musicplayer/colors.dart' as app_colors;
import 'package:on_audio_query/on_audio_query.dart';

import '../../Model/db/Playlist/db_helper_pla.dart';
import '../controller_playlist_fav.dart';

class OpenPlaylist extends StatelessWidget {
  final int id;

  OpenPlaylist(this.id, {Key? key}) : super(key: key);

  TrackPageController trackPageController = Get.put(TrackPageController());
  DbController dbController = Get.put(DbController());
  FunctionsController functionsController = Get.put(FunctionsController());

  @override
  Widget build(BuildContext context) {
    final double heights = MediaQuery.of(context).size.height;
    final double weights = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        backgroundColor: app_colors.back,
        appBar: AppBar(
          actions: [
            IconButton(
              padding: const EdgeInsets.only(right: 20, top: 10),
              icon: const Icon(
                Icons.add,
                size: 30,
              ),
              onPressed: () {
                Get.off(
                  SelectInside(
                    playlistId: id,
                  ),
                );
              },
            ),
          ],
          leadingWidth: 50,
          leading: IconButton(
            padding: const EdgeInsets.only(
              left: 25,
              top: 16,
            ),
            color: Colors.white,
            alignment: Alignment.topLeft,
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_ios),
          ),
          title: const Text(
            'Add Songs',
            style: TextStyle(
                color: Colors.white, fontSize: 25, fontFamily: 'Titil'),
          ),
          backgroundColor: app_colors.back,
          elevation: 0,
        ),
        body: Stack(
          children: [
            Positioned(
                top: 20,
                child: Container(
                  width: weights,
                  child: const Center(
                    child: Icon(
                      Icons.music_note_outlined,
                      color: Colors.white,
                      size: 90,
                    ),
                  ),
                  color: app_colors.back,
                )),
            Positioned(
              child: DraggableScrollableSheet(
                initialChildSize: 0.7,
                minChildSize: 0.7,
                maxChildSize: 1.0,
                builder: (BuildContext context, myScrollController) {
                  return Container(
                    padding: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(25),
                          topRight: Radius.circular(25)),
                      color: app_colors.shade,
                    ),
                    child: GetBuilder<DbController>(
                      builder: (controller) {
                        return FutureBuilder(
                          future: dbController.playlistHandler
                              .retrieveSingleSong(id),
                          builder: (BuildContext context,
                              AsyncSnapshot<List<PlayListSong>> snapshot) {
                            if (snapshot.hasData) {
                              return ListView.builder(
                                itemCount: snapshot.data?.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Column(
                                    children: [
                                      ListTile(
                                        leading: QueryArtworkWidget(
                                          artworkBorder:
                                              BorderRadius.circular(8),
                                          nullArtworkWidget: Container(
                                            width: weights / 8,
                                            height: heights / 14,
                                            decoration: BoxDecoration(
                                                color: app_colors.back,
                                                borderRadius:
                                                    BorderRadius.circular(8)),
                                            child: const Icon(
                                              Icons.music_note_outlined,
                                              color: Colors.grey,
                                              size: 45,
                                            ),
                                          ),
                                          id: snapshot.data![index].songID,
                                          type: ArtworkType.AUDIO,
                                          artworkFit: BoxFit.contain,
                                        ),
                                        trailing: IconButton(
                                          icon: const Icon(
                                            Icons.delete,
                                            color: Colors.grey,
                                          ),
                                          onPressed: () async {
                                            await dbController.playlistHandler
                                                .deleteSongs(
                                                    snapshot.data![index].id!);

                                            snapshot.data!
                                                .remove(snapshot.data![index]);
                                            controller.update();
                                          },
                                        ),
                                        // onTap: () {
                                        //   for (int i = 0;
                                        //   i <=
                                        //       trackPageController
                                        //           .tracks.length;
                                        //   i++) {
                                        //     if (trackPageController
                                        //         .tracks[i].id ==
                                        //         snapshot.data![index].songID) {
                                        //       trackPageController.currentIndex =
                                        //           i;
                                        //       break;
                                        //     }
                                        //   }
                                        //   Get.to(MusicControllerPlayAndFav(
                                        //     trackPageController.tracks[
                                        //     trackPageController.currentIndex],
                                        //     trackPageController.changeTrack,
                                        //     trackPageController.key2,
                                        //   ));
                                        // },
                                        title: Text(
                                          snapshot.data![index].songName,
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 17),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        ),
                                        subtitle: Text(
                                          snapshot.data![index].songName,
                                          style: const TextStyle(
                                              color: Colors.grey),
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
                              return const Center(
                                  child: Text(
                                'No song added',
                                style:
                                    TextStyle(color: Colors.grey, fontSize: 16),
                              ));
                            }
                          },
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void changeTrack(bool isNext) {
    if (isNext) {
      if (trackPageController.currentIndex !=
          trackPageController.tracks.length - 1) {
        trackPageController.currentIndex++;
      }
    } else {
      if (trackPageController.currentIndex != 0) {
        trackPageController.currentIndex--;
      }
    }
    trackPageController.key.currentState!
        .setSong(trackPageController.tracks[trackPageController.currentIndex]);
  }
}
