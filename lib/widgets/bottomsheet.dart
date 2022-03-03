import 'package:flutter/material.dart';
import 'package:music_player/database/box.dart';
import 'package:music_player/database/songmodel_adapter.dart';
import 'package:on_audio_query/on_audio_query.dart';

// ignore: must_be_immutable
class buildSheet extends StatefulWidget {
  String playlistName;
  buildSheet({Key? key, required this.playlistName}) : super(key: key);

  @override
  _buildSheetState createState() => _buildSheetState();
}

class _buildSheetState extends State<buildSheet> {
  final box = Boxes.getInstance();

  List<Songs> dbSongs = [];
  List<Songs> playlistSongs = [];
  @override
  void initState() {
    super.initState();
    getSongs();
  }

  getSongs() {
    dbSongs = box.get("musics") as List<Songs>;
    playlistSongs = box.get(widget.playlistName)!.cast<Songs>();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.grey,
        padding: EdgeInsets.only(top: 20, left: 5, right: 5),
        child: ListView.builder(
          itemCount: dbSongs.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: Container(
                  height: 50,
                  width: 50,
                  child: QueryArtworkWidget(
                    id: dbSongs[index].id!,
                    type: ArtworkType.AUDIO,
                    artworkBorder: BorderRadius.circular(15),
                    artworkFit: BoxFit.cover,
                    nullArtworkWidget: Container(
                      height: 50,
                      width: 50,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        image: DecorationImage(
                          image: AssetImage("assets/images/default.jpeg"),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
                title: Text(
                  dbSongs[index].title!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                trailing: playlistSongs
                        .where((element) =>
                            element.id.toString() ==
                            dbSongs[index].id.toString())
                        .isEmpty
                    ? IconButton(
                        onPressed: () async {
                          playlistSongs.add(dbSongs[index]);
                          await box.put(widget.playlistName, playlistSongs);
                          //box.get(widget.playlistName);

                          setState(() {
                            // playlistSongs =
                            //     box.get(widget.playlistName)!.cast<Songs>();
                          });
                        },
                        icon: Icon(Icons.add))
                    : IconButton(
                        onPressed: () async {
                          // await box.put(widget.playlistName, playlistSongs);

                          playlistSongs.removeWhere((elemet) =>
                              elemet.id.toString() ==
                              dbSongs[index].id.toString());

                          await box.put(widget.playlistName, playlistSongs);
                          setState(() {});
                        },
                        icon: Icon(Icons.remove)),
              ),
            );
          },
        ));
  }
}
