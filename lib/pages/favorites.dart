import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:music_player/database/box.dart';
import 'package:music_player/database/songmodel_adapter.dart';
import 'package:music_player/openassetaudio/openassetaudio.dart';
import 'package:music_player/pages/playingsong.dart';
import 'package:on_audio_query/on_audio_query.dart';

class Favourites extends StatefulWidget {
  const Favourites({Key? key}) : super(key: key);

  @override
  _FavouritesState createState() => _FavouritesState();
}

class _FavouritesState extends State<Favourites> {
  List<Songs>? dbSongs = [];
  List<Audio> playLiked = [];
  List<Songs>? LikedSongs = [];
  final box = Boxes.getInstance();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFF091B46),
        appBar: AppBar(
          backgroundColor: const Color(0xFF091B46),
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: const Text(
            "Favourites",
            style: TextStyle(fontSize: 30),
          ),
        ),
        body: Column(
          children: [
            Expanded(
                child: ValueListenableBuilder(
                    valueListenable: box.listenable(),
                    builder: (context, boxes, _) {
                      final likedSongs = box.get("favorites");
                      return ListView.builder(
                          itemCount: likedSongs!.length,
                          itemBuilder: (context, index) => GestureDetector(
                                onTap: () {
                                  for (var element in likedSongs) {
                                    playLiked.add(
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
                                  OpenAssetAudio(
                                          allsong: playLiked, index: index)
                                      .openAsset(
                                          index: index, audios: playLiked);

                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => playingsong(
                                                audiosongs: playLiked,
                                                index: index,
                                              )));
                                },
                                child: ListTile(
                                  leading: SizedBox(
                                    height: 50,
                                    width: 50,
                                    child: QueryArtworkWidget(
                                      id: likedSongs[index].id!,
                                      type: ArtworkType.AUDIO,
                                      artworkBorder: BorderRadius.circular(15),
                                      artworkFit: BoxFit.cover,
                                      nullArtworkWidget: Container(
                                        height: 50,
                                        width: 50,
                                        decoration: const BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(15)),
                                          image: DecorationImage(
                                            image: AssetImage(
                                                "assets/images/default.jpeg"),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  trailing: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        likedSongs.removeAt(index);
                                        box.put("favorites", likedSongs);
                                      });
                                    },
                                    icon:
                                        Icon(Icons.delete, color: Colors.white),
                                  ),
                                  title: Text(
                                    likedSongs[index].title,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white),
                                  ),
                                  subtitle: Text(
                                    likedSongs[index].artist,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white),
                                  ),
                                ),
                              ));
                    })),
          ],
        ));
  }

//   Padding likedSongList(
//       {required title,
//       leadIcon = Icons.music_note_rounded,
//       double leadSize = 28,
//       leadClr = Colors.pink}) {
//     return Padding(
//       padding: const EdgeInsets.only(left: 5, right: 5, bottom: 15),
//       child: ListTile(
//         leading: Container(
//           height: 50,
//           width: 50,
//           decoration: BoxDecoration(
//             image: const DecorationImage(
//                 image: AssetImage("assets/images/default.jpeg"),
//                 fit: BoxFit.cover),
//             color: leadClr,
//             borderRadius: const BorderRadius.all(Radius.circular(17)),
//           ),
//           child: Center(
//               child: Icon(
//             leadIcon,
//             color: Colors.white,
//             size: leadSize,
//           )),
//         ),
//         title: Text(
//           title,
//           style: const TextStyle(
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         trailing: const Icon(
//           Icons.play_arrow_rounded,
//           size: 30,
//         ),
//       ),
//     );
//   }
}
