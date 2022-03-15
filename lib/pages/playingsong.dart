import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:music_player/controller/controller.dart';
import 'package:music_player/database/box.dart';
import 'package:music_player/database/songmodel_adapter.dart';
import 'package:music_player/widgets/buildsheet.dart';
import 'package:on_audio_query/on_audio_query.dart';

class playingsong extends StatelessWidget {
  int index;
  List<Audio> audiosongs = [];
  List<Audio> a = [];

  playingsong({
    Key? key,
    required this.index,
    required this.audiosongs,
  }) : super(key: key);

  final AssetsAudioPlayer assetAudioPlayer = AssetsAudioPlayer.withId("0");

  Audio find(List<Audio> source, String fromPath) {
    return source.firstWhere((element) => element.path == fromPath);
  }

  // late TextEditingController controller;
  final box = Boxes.getInstance();

  List playlists = [];
  List<dynamic>? playlistSongs = [];
  String? playlistName = '';
  List<Songs> dbSongs = [];
  List<dynamic>? likedSongs = [];

  @override
  Widget build(BuildContext context) {
    dbSongs = box.get("musics") as List<Songs>;
    return Scaffold(
        //backgroundColor: const Color(0xFF091B46),
        backgroundColor: Colors.blueGrey,
        appBar: AppBar(
          // backgroundColor: const Color(0xFF091B46),
          backgroundColor: Colors.blueGrey,
          elevation: 0,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_drop_down,
              size: 40,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: const Text(
            "Now Playing",
            style: TextStyle(fontSize: 30),
          ),
        ),
        body: assetAudioPlayer.builderCurrent(
          builder: (context, Playing? playing) {
            final myAudio = find(audiosongs, playing!.audio.assetAudioPath);

            final currentSong = dbSongs.firstWhere((element) =>
                element.id.toString() == myAudio.metas.id.toString());

            likedSongs = box.get("favorites");

            return Stack(children: [
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    height: 300,
                    width: 300,
                    child: QueryArtworkWidget(
                      id: int.parse(myAudio.metas.id!),
                      type: ArtworkType.AUDIO,
                      nullArtworkWidget: Image.asset(
                        "assets/images/default.jpeg",
                        height: 300,
                        width: 300,
                      ),
                    ),
                  ),
                ),
              ),
              ListView(
                children: [
                  const SizedBox(
                    height: 350,
                  ),
                  GetBuilder<Controller>(builder: (_controller) {
                    return ListTile(
                      leading: IconButton(
                        icon: const Icon(
                          Icons.library_add,
                          size: 30,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          showModalBottomSheet(
                              backgroundColor: Colors.grey,
                              shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(20))),
                              context: context,
                              builder: (context) => BuildSheet(song: myAudio)
                              // buildSheet(song: dbSongs[index]),
                              );
                          _controller.update();
                        },
                      ),
                      title: Text(
                        myAudio.metas.title!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                      subtitle: Text(
                        myAudio.metas.artist!,
                        style: const TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                        ),
                      ),
                      trailing: likedSongs!
                              .where((element) =>
                                  element.id.toString() ==
                                  currentSong.id.toString())
                              .isEmpty
                          ? IconButton(
                              icon: const Icon(
                                Icons.favorite_outline,
                                size: 30,
                                color: Colors.white,
                              ),
                              onPressed: () async {
                                Fluttertoast.showToast(
                                    msg: "Song added to Favourites");
                                likedSongs?.add(currentSong);
                                box.put("favorites", likedSongs!);
                                likedSongs = box.get("favorites");
                                // setState(() {});
                                _controller.update();
                              },
                            )
                          : IconButton(
                              icon: const Icon(
                                Icons.favorite,
                                size: 30,
                                color: Colors.white,
                              ),
                              onPressed: () async {
                                Fluttertoast.showToast(
                                    msg: "Song removed from Favourites");
                                likedSongs?.removeWhere((elemet) =>
                                    elemet.id.toString() ==
                                    currentSong.id.toString());
                                box.put("favorites", likedSongs!);
                                _controller.update();
                              },
                            ),
                    );
                  }),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 40),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.skip_previous,
                            size: 50,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            assetAudioPlayer.previous();
                          },
                        ),
                        SizedBox(
                          width: 30,
                        ),
                        PlayerBuilder.isPlaying(
                          player: assetAudioPlayer,
                          builder: (context, isPlaying) {
                            return IconButton(
                              onPressed: () async {
                                await assetAudioPlayer.playOrPause();
                              },
                              icon: Icon(
                                isPlaying
                                    ? Icons.pause_rounded
                                    : Icons.play_arrow_rounded,
                                size: 50,
                                color: Colors.white,
                              ),
                            );
                          },
                        ),
                        SizedBox(
                          width: 30,
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.skip_next,
                            size: 50,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            assetAudioPlayer.next();
                          },
                        ),
                        SizedBox(
                          width: 40,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  StreamBuilder<Duration>(
                      stream: assetAudioPlayer.currentPosition,
                      builder: (context, snapshot) {
                        return Slider(
                          activeColor: Colors.white,
                          inactiveColor: Colors.grey,
                          max: playing.audio.duration.inMilliseconds.toDouble(),
                          value: snapshot.data == null
                              ? 0
                              : snapshot.data!.inMilliseconds.toDouble(),
                          onChanged: (value) {
                            assetAudioPlayer
                                .seek(Duration(milliseconds: value.floor()));
                          },
                        );
                      })
                ],
              ),
            ]);
          },
        ));
  }
}
