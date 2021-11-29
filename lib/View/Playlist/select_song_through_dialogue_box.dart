import 'package:get/get.dart';
import 'package:musicplayer/Controller/database_controller.dart';
import 'package:musicplayer/Controller/functions.dart';
import 'package:musicplayer/Controller/track_controller.dart';
import 'package:musicplayer/colors.dart' as app_colors;
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'open_playlist_screen.dart';

class SelectTrack extends StatelessWidget {
  final int playlistId;

  SelectTrack({Key? key, required this.playlistId}) : super(key: key);

  TrackPageController trackPageController = Get.put(TrackPageController());
  DbController dbController = Get.put(DbController());
  FunctionsController functionsController = Get.put(FunctionsController());

  int select = 0;

  @override
  Widget build(BuildContext context) {
    final double heights = MediaQuery.of(context).size.height;
    final double widths = MediaQuery.of(context).size.width;
    return GetBuilder<DbController>(builder: (controller) {
      return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          backgroundColor: app_colors.back,
          title: const Text(
            'Add song to playlist',
            style: TextStyle(fontSize: 18),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.save_outlined),
              onPressed: () {
                if (select == 1) {
                  Get.off(OpenPlaylist(playlistId + 1));

                  functionsController.showToast('Playlist created');
                  select = 0;
                  controller.update();
                } else {
                  functionsController.showToast('Select song');
                }
              },
            ),
          ],
        ),
        backgroundColor: app_colors.shade,
        body: Container(
          padding: const EdgeInsets.only(bottom: 0, top: 10),
          color: Colors.transparent,
          child: ListView.builder(
              itemCount: trackPageController.tracks.length,
              itemBuilder: (BuildContext context, int index) {
                if (trackPageController.tracks[index].data.contains('mp3'))
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        leading: QueryArtworkWidget(
                          artworkBorder: BorderRadius.circular(8),
                          nullArtworkWidget: Container(
                              width: widths / 8,
                              height: heights / 14,
                              decoration: BoxDecoration(
                                  color: app_colors.back,
                                  borderRadius: BorderRadius.circular(8)),
                              child: const Icon(
                                Icons.music_note_outlined,
                                color: Colors.grey,
                                size: 45,
                              )),
                          id: trackPageController.tracks[index].id,
                          type: ArtworkType.AUDIO,
                          artworkFit: BoxFit.contain,
                        ),
                        trailing: IconButton(
                          icon: const Icon(
                            Icons.add,
                          ),
                          color: Colors.white,
                          onPressed: () {
                            if (select == 0) {
                              select = 1;
                              controller.update();
                            }
                            final songID = trackPageController.tracks[index].id;
                            final playlistID = playlistId + 1;
                            final songName =
                                trackPageController.tracks[index].title;
                            final path = trackPageController.tracks[index].data;
                            dbController.addSongsToPlaylist(
                                songID, playlistID, songName, path);
                          },
                        ),
                        title: Text(
                          trackPageController.tracks[index].title,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 17),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                        subtitle: Text(
                          trackPageController.tracks[index].displayNameWOExt,
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
                return Container(
                  height: 0,
                );
              }),
        ),
      );
    });
  }
}
