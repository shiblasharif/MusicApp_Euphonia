import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music_player/controller/controller.dart';
import 'package:music_player/database/box.dart';
import 'package:music_player/database/songmodel_adapter.dart';
import 'package:music_player/openassetaudio/openassetaudio.dart';
import 'package:music_player/pages/playingsong.dart';
import 'package:on_audio_query/on_audio_query.dart';

class SearchScreen extends StatelessWidget {
  List<Audio> audiosongs = [];
  SearchScreen({Key? key, required this.audiosongs}) : super(key: key);

  List<Songs> dbSongs = [];
  List<Audio> allSongs = [];

  String search = "";

  final box = Boxes.getInstance();

  final searchController = TextEditingController();
  // @override
  // void initState() {
  //   super.initState();
  //   getSongs();
  // }

  Future<String> debounce() async {
    //  await Future.delayed(const Duration(seconds: 0));
    return "Waited 0";
  }

  getSongs() {
    dbSongs = box.get("musics") as List<Songs>;

    for (var element in dbSongs) {
      allSongs.add(
        Audio.file(
          element.uri.toString(),
          metas: Metas(
              title: element.title,
              id: element.id.toString(),
              artist: element.artist),
        ),
      );
    }
  }

  final statecontroller = Get.find<Controller>();

  @override
  Widget build(BuildContext context) {
    // List<Audio> searchResult = allSongs
    //     .where((element) => element.metas.title!.toLowerCase().startsWith(
    //           search.toLowerCase(),
    //         ))
    //     .toList();
    allSongs.clear();

    getSongs();
    return Container(
      color: Color(0xFF091B46),
      child: Column(
        children: [
          AppBar(
            backgroundColor: const Color(0xFF091B46),
            elevation: 0,
            toolbarHeight: 65,
            title: const Text(
              "Search",
              style: TextStyle(fontSize: 25),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: const [BoxShadow(color: Colors.black26)]),
            height: 55,
            width: 340,
            child: TextField(
                controller: searchController,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.only(top: 14),
                    prefixIcon: Icon(Icons.search, color: Colors.black),
                    hintText: 'search a song',
                    filled: true,
                    hintStyle: TextStyle(color: Colors.grey)),
                onChanged: (value) {
                  search = value;
                  statecontroller.update(["search"]);
                }),
          ),
          GetBuilder<Controller>(
              id: "search",
              builder: (_controller) {
                List<Audio> searchResult = allSongs
                    .where((element) =>
                        element.metas.title!.toLowerCase().startsWith(
                              searchController.text.toLowerCase(),
                            ))
                    .toList();

                return search.isNotEmpty
                    ? searchResult.isNotEmpty
                        ? Expanded(
                            child: ListView.builder(
                                physics: const BouncingScrollPhysics(),
                                itemCount: searchResult.length,
                                itemBuilder: (context, index) {
                                  return FutureBuilder(
                                      future: debounce(),
                                      
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.done) {
                                          return GestureDetector(
                                            onTap: () {
                                              OpenAssetAudio(
                                                      allsong: searchResult,
                                                      index: index)
                                                  .openAsset(
                                                      index: index,
                                                      audios: searchResult);
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          playingsong(
                                                            index: index,
                                                            audiosongs:
                                                                audiosongs,
                                                          )));
                                            },
                                            child: ListTile(
                                              leading: SizedBox(
                                                height: 50,
                                                width: 50,
                                                child: QueryArtworkWidget(
                                                  id: int.parse(
                                                      searchResult[index]
                                                          .metas
                                                          .id!),
                                                  type: ArtworkType.AUDIO,
                                                  artworkBorder:
                                                      BorderRadius.circular(15),
                                                  artworkFit: BoxFit.cover,
                                                  nullArtworkWidget: Container(
                                                    height: 50,
                                                    width: 50,
                                                    decoration:
                                                        const BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  15)),
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
                                                searchResult[index]
                                                    .metas
                                                    .title!,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                    color: Colors.white),
                                              ),
                                              subtitle: Text(
                                                searchResult[index]
                                                    .metas
                                                    .artist!,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ),
                                          );
                                        }
                                        return Container();
                                      });
                                }),
                          )
                        : const Padding(
                            padding: EdgeInsets.all(30),
                            child: Text(
                              "No result found",
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                              ),
                            ),
                          )
                    : const SizedBox();
              })
        ],
      ),
    );
  }
}
