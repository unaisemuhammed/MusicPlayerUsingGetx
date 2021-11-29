import 'package:get/get.dart';
import 'package:musicplayer/Controller/database_controller.dart';
import 'package:musicplayer/Controller/functions.dart';
import 'package:musicplayer/Controller/track_controller.dart';
import 'package:musicplayer/View/music_controll_page.dart';
import 'package:musicplayer/colors.dart' as app_colors;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:on_audio_query/on_audio_query.dart';

///Done

class Track extends StatelessWidget {
   Track({Key? key}) : super(key: key);

  TrackPageController trackPageController = Get.put(TrackPageController());
  DbController dbController = Get.put(DbController());
  FunctionsController functionsController = Get.put(FunctionsController());
  var songTitle;
  var songId;
  var songLocation;



  @override
  Widget build(BuildContext context) {
    final double heights = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return Scaffold(backgroundColor: app_colors.shade,
      body: Stack(
        children: [
          Positioned(child: Container(padding: const EdgeInsets.only(bottom: 0, top: 10),
              child: GetBuilder<TrackPageController>(builder: (controller) {
                  return ListView.builder(itemCount: trackPageController.tracks.length, itemBuilder: (BuildContext context, int index) {
                    if (trackPageController.tracks[index].data.contains('mp3'))
                          return Column(mainAxisSize: MainAxisSize.min,
                            children: [
                              GestureDetector(onTap: () {trackPageController.currentIndex = index;
                                  Get.to(MusicController(trackPageController.tracks[trackPageController.currentIndex],
                                    trackPageController.changeTrack, trackPageController.key,
                                  ),);},
                                child: ListTile(
                                  leading: QueryArtworkWidget(artworkBorder: BorderRadius.circular(8), nullArtworkWidget: Container(
                                      width: width / 8, height: heights / 14,
                                        decoration: BoxDecoration(color: app_colors.back, borderRadius: BorderRadius.circular(8)),
                                        child: const Icon(Icons.music_note_outlined, color: Colors.grey, size: 45,),),
                                    id: trackPageController.tracks[index].id, type: ArtworkType.AUDIO, artworkFit: BoxFit.contain,),
                                  title: Text(trackPageController.tracks[index].title,
                                    style: const TextStyle(color: Colors.white, fontSize: 17), overflow: TextOverflow.ellipsis, maxLines: 1,),
                                  subtitle: Text(trackPageController.tracks[index].displayNameWOExt,
                                    style: const TextStyle(color: Colors.grey), overflow: TextOverflow.ellipsis,),
                                  trailing: PopupMenuButton(
                                      icon: const Icon(Icons.more_vert, color: Colors.grey,),
                                      color: app_colors.back,
                                      itemBuilder: (context) => [
                                        PopupMenuItem(
                                          child: const Text('Add to Favourite', style: TextStyle(color: Colors.white),),
                                          onTap: () {
                                            songTitle = trackPageController.tracks[index].title;
                                            songId = trackPageController.tracks[index].id;
                                            songLocation = trackPageController.tracks[index].data;
                                            dbController.addToFav(songTitle, songId, songLocation);
                                            functionsController.showToast('Added to Favourite');},
                                          value: 2,
                                        ),],),),),
                              const Divider(height: 0, indent: 85, color: Colors.grey,)
                              ,],);
                        return Container(height: 0,);});
                  },),),),],),);
  }
}

