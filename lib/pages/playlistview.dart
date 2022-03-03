import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:music_player/database/box.dart';
import 'package:music_player/database/songmodel_adapter.dart';
import 'package:music_player/openassetaudio/openassetaudio.dart';
import 'package:music_player/pages/playingsong.dart';
import 'package:music_player/widgets/bottomsheet.dart';
import 'package:on_audio_query/on_audio_query.dart';

class PlaylistScreen extends StatefulWidget {
  String playlistName;

  PlaylistScreen({Key? key, required this.playlistName}) : super(key: key);

  @override
  _PlaylistScreenState createState() => _PlaylistScreenState();
}

class _PlaylistScreenState extends State<PlaylistScreen> {
  // List<Songs>? dbSongs = [];

  List<Songs>? playlistSongs = [];
  List<Audio> playPlaylist = [];

  final box = Boxes.getInstance();

  @override
  void initState() {
    super.initState();
    // getSongs();
  }

  // getSongs() {
  //   dbSongs = box.get("musics") as List<Songs>;
  //   playlistSongs = box.get(widget.playlistName);
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF091B46),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF091B46),
        title: Text(
          widget.playlistName,
          style: TextStyle(fontSize: 25),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: ElevatedButton(
              onPressed: () {
                showModalBottomSheet(
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),
                    ),
                    context: context,
                    builder: (context) {
                      return buildSheet(
                        playlistName: widget.playlistName,
                      );
                    });
              },
              child: const Text(
                '+',
                style: TextStyle(fontSize: 30, color: Colors.black),
              ),
              style: ElevatedButton.styleFrom(
                primary: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: ValueListenableBuilder(
              valueListenable: box.listenable(),
              builder: (context, boxes, _) {
                final playlistSongs = box.get(widget.playlistName)!;
                // print(widget.playlistName);
                return playlistSongs.isEmpty
                    ? SizedBox(
                        child: Center(
                          child: Text(
                            "No songs here!",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                        ),
                      )
                    : ListView.builder(
                        itemCount: playlistSongs.length,
                        itemBuilder: (context, index) => GestureDetector(
                          onTap: () {
                            for (var element in playlistSongs) {
                              playPlaylist.add(
                                Audio.file(
                                  element.uri!,
                                  metas: Metas(
                                    title: element.title,
                                    id: element.id.toString(),
                                    artist: element.artist,
                                  ),
                                ),
                              );
                            }
                            OpenAssetAudio(allsong: playPlaylist, index: index)
                                .openAsset(index: index, audios: playPlaylist);

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => playingsong(
                                  audiosongs: playPlaylist,
                                  index: index,
                                ),
                              ),
                            );
                          },
                          child: ListTile(
                            leading: SizedBox(
                              height: 50,
                              width: 50,
                              child: QueryArtworkWidget(
                                id: playlistSongs[index].id!,
                                type: ArtworkType.AUDIO,
                                artworkBorder: BorderRadius.circular(15),
                                artworkFit: BoxFit.cover,
                                nullArtworkWidget: Container(
                                  height: 50,
                                  width: 50,
                                  decoration: const BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15)),
                                    image: DecorationImage(
                                      image: AssetImage(
                                          "assets/images/default.jpeg"),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            title: Text(
                              playlistSongs[index].title!,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white),
                            ),
                            subtitle: Text(
                              playlistSongs[index].artist!,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white),
                            ),
                            trailing: IconButton(
                              onPressed: () {
                                Fluttertoast.showToast(
                                    msg: "Deleted Successfully");
                                setState(() {
                                  playlistSongs.removeAt(index);
                                  box.put(widget.playlistName, playlistSongs);
                                });
                              },
                              icon: Icon(Icons.delete, color: Colors.white),
                            ),
                          ),
                        ),
                      );
              },
            ),
          )
        ],
      ),
    );
  }
}
