import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:musicplayer/Controller/database_controller.dart';
import 'package:musicplayer/Controller/functions.dart';
import 'package:musicplayer/Controller/track_controller.dart';
import 'package:musicplayer/Model/db/Favourite/db_helper.dart';
import 'package:musicplayer/colors.dart' as app_colors;
import 'package:on_audio_query/on_audio_query.dart';

import 'controller_playlist_fav.dart';

class Favourite extends StatelessWidget {
  Favourite({Key? key}) : super(key: key);

  TrackPageController trackPageController = Get.put(TrackPageController());
  DbController dbController = Get.put(DbController());
  FunctionsController functionsController = Get.put(FunctionsController());

  @override
  Widget build(BuildContext context) {
    final double heights = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        backgroundColor: app_colors.shade,
        body: Container(
          padding: const EdgeInsets.only(bottom: 0, top: 10),
          child: GetBuilder<DbController>(builder: (controller) {
            return FutureBuilder(
              future: dbController.handler!.retrieveFavSongs(),
              builder:
                  (BuildContext context, AsyncSnapshot<List<Songs>> snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data?.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Column(
                        children: [
                          ListTile(
                            onTap: () {
                              for (int i = 0;
                                  i <= trackPageController.tracks.length;
                                  i++) {
                                if (trackPageController.tracks[i].id ==
                                    snapshot.data![index].num) {
                                  trackPageController.currentIndex = i;
                                  break;
                                }
                              }

                              Get.to(
                                MusicControllerPlayAndFav(
                                  trackPageController.tracks[trackPageController.currentIndex],
                                  changeTrack,
                                  trackPageController.key2,
                                ),
                              );
                            },
                            leading: QueryArtworkWidget(
                              artworkBorder: BorderRadius.circular(8),
                              nullArtworkWidget: Container(
                                width: width / 8,
                                height: heights / 14,
                                decoration: BoxDecoration(
                                    color: app_colors.back,
                                    borderRadius: BorderRadius.circular(8)),
                                child: const Icon(
                                  Icons.music_note_outlined,
                                  color: Colors.grey,
                                  size: 45,
                                ),
                              ),
                              id: snapshot.data![index].num,
                              type: ArtworkType.AUDIO,
                              artworkFit: BoxFit.contain,
                            ),
                            trailing: IconButton(
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.grey,
                              ),
                              onPressed: () async {
                                functionsController
                                    .showToast('Deleted From Favourite');
                                await dbController.handler!
                                    .deleteFavSongs(snapshot.data![index].num);

                                snapshot.data!
                                    .remove(snapshot.data![index].num);
                                controller.update();
                              },
                            ),
                            title: Text(
                              snapshot.data![index].name,
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 17),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                            subtitle: Text(
                              snapshot.data![index].name,
                              style: const TextStyle(color: Colors.grey),
                              overflow: TextOverflow.ellipsis,
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
          }),
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
    trackPageController.key2.currentState!
        .setSong(trackPageController.tracks[trackPageController.currentIndex]);
  }
}
