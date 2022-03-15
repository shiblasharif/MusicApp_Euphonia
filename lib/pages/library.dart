import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:music_player/controller/controller.dart';
import 'package:music_player/database/box.dart';
import 'package:music_player/database/songmodel_adapter.dart';
import 'package:music_player/pages/favorites.dart';
import 'package:music_player/pages/playlistview.dart';

class Library extends StatelessWidget {
  Library({Key? key}) : super(key: key);

  TextEditingController controller = TextEditingController();

  final excistingPlaylist = SnackBar(
    content: const Text(
      'This playlist name already exists',
      style: TextStyle(color: Colors.white),
    ),
    backgroundColor: Colors.grey[900],
  );

  final box = Boxes.getInstance();
  List playlists = [];
  //List<Songs> library = [];
  String? playlistName = '';

  // @override
  // void initState() {
  //   super.initState();
  //   controller = TextEditingController();
  // }

  // @override
  // void dispose() {
  //   // Clean up the controller when the widget is disposed.
  //   controller.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF091B46),
      appBar: AppBar(
        backgroundColor: const Color(0xFF091B46),
        title: const Text(
          'Library',
          style: TextStyle(fontSize: 25),
        ),
        toolbarHeight: 65,
        elevation: 0,
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          libraryList(
            child: ListTile(
              onTap: () => showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                        title: const Text(
                          "Add new playlist",
                          style: TextStyle(fontSize: 18),
                        ),
                        content: TextField(
                          controller: controller,
                          autofocus: true,
                          cursorRadius: const Radius.circular(50),
                          cursorColor: Colors.black,
                        ),
                        actions: [
                          GetBuilder<Controller>(builder: (_controller) {
                            return TextButton(
                                onPressed: () {
                                  // submit();
                                  playlistName = controller.text;
                                  List<Songs> librayry = [];
                                  List? excistingName = [];
                                  if (playlists.isNotEmpty) {
                                    excistingName = playlists
                                        .where((element) =>
                                            element == playlistName)
                                        .toList();
                                  }

                                  if (playlistName != '' &&
                                      excistingName.isEmpty) {
                                    box.put(playlistName, librayry);
                                    Navigator.of(context).pop();
                                    // setState(() {});
                                    playlists = box.keys.toList();
                                    _controller.update();
                                  } else {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(excistingPlaylist);
                                  }
                                  controller.clear();
                                },
                                child: Text(
                                  "ADD",
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 18),
                                ));
                          })
                        ],
                      )),
              leading: Icon(
                Icons.library_add_outlined,
                color: Colors.white,
              ),
              title: const Text(
                "Create Playlist",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
          ),
          // libraryItems(
          //   title: "Favourites",
          //   leadIcon: Icons.favorite,
          //   leadSize: 25,
          // ),
          Padding(
            padding: const EdgeInsets.only(left: 5, right: 5, bottom: 15),
            child: ListTile(
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (context) => Favourites())),
              leading: Icon(
                Icons.favorite,
                color: Colors.white,
              ),
              title: Text(
                "Favourites",
                style: const TextStyle(fontSize: 20, color: Colors.white),
              ),
              // trailing: IconButton(
              //   onPressed: () => Navigator.push(context,MaterialPageRoute(builder: (context) =>  Favourites())),
              //   icon: Icon(
              //     tail,
              //     size: 20,
              //   ),
              // ),
            ),
          ),
          ValueListenableBuilder(
              valueListenable: box.listenable(),
              builder: (context, boxes, _) {
                playlists = box.keys.toList();

                return ListView.builder(
                    shrinkWrap: true,
                    itemCount: playlists.length,
                    itemBuilder: (context, index) => GestureDetector(
                        onTap: () {},
                        child: playlists[index] != "musics" &&
                                playlists[index] != "favorites"
                            ? libraryList(
                                child: GetBuilder<Controller>(
                                    builder: (_controller) {
                                  return ListTile(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  PlaylistScreen(
                                                    playlistName:
                                                        playlists[index],
                                                  )),
                                        );
                                      },
                                      leading: Icon(
                                        Icons.playlist_play,
                                        color: Colors.white,
                                        size: 30,
                                      ),
                                      title: Text(
                                        playlists[index].toString(),
                                        style: const TextStyle(
                                            fontSize: 20, color: Colors.white),
                                      ),
                                      trailing: PopupMenuButton(
                                          icon: Icon(
                                            Icons.more_vert,
                                            color: Colors.white,
                                          ),
                                          itemBuilder: (context) => [
                                                PopupMenuItem(
                                                  child:
                                                      Text('Delete playlist'),
                                                  value: "0",
                                                ),
                                              ],
                                          onSelected: (value) {
                                            Fluttertoast.showToast(
                                                msg: "Deleted Successfully");
                                            if (value == "0") {
                                              box.delete(playlists[index]);
                                              // setState(() {});
                                              playlists = box.keys.toList();
                                              _controller.update();
                                            }
                                          }));
                                }),
                              )
                            : Container()));
              }),

          // ...playlists
          //     .map((e) => e != "musics" && e != "favorites"
          //         ? libraryList(
          //             child: ListTile(
          //                 onTap: () {
          //                   Navigator.push(
          //                     context,
          //                     MaterialPageRoute(
          //                         builder: (context) => PlaylistScreen(
          //                               playlistName: e,
          //                             )),
          //                   );
          //                 },
          //                 leading: Icon(
          //                   Icons.playlist_play,
          //                   color: Colors.white,
          //                   size: 30,
          //                 ),
          //                 title: Text(
          //                   e.toString(),
          //                   style: const TextStyle(
          //                       fontSize: 20, color: Colors.white),
          //                 ),
          //                 trailing: PopupMenuButton(
          //                     icon: Icon(
          //                       Icons.more_vert,
          //                       color: Colors.white,
          //                     ),
          //                     itemBuilder: (context) => [
          //                           PopupMenuItem(
          //                             child: Text('Remove playlist'),
          //                             value: "0",
          //                           ),
          //                         ],
          //                     onSelected: (value) {
          //                       if (value == "0") {
          //                         box.delete(e);
          //                         setState(() {
          //                           playlists = box.keys.toList();
          //                         });
          //                       }
          //                     })),
          //           )
          //         : Container())
          //     .toList()
        ],
      ),
    );
  }

  // Padding libraryItems(
  //     {required title,
  //     leadIcon = Icons.favorite,
  //     double leadSize = 28,
  //     tail,
  //     leadClr = Colors.white}) {
  //   return Padding(
  //     padding: const EdgeInsets.only(left: 5, right: 5, bottom: 15),
  //     child: ListTile(
  //         onTap: () => Navigator.push(context,
  //             MaterialPageRoute(builder: (context) =>  Favourites())),
  //         leading: Icon(
  //           Icons.favorite,
  //           color: Colors.white,
  //         ),
  //         title: Text(
  //           title,
  //           style: const TextStyle(fontSize: 20, color: Colors.white),
  //         ),
  //         trailing: IconButton(
  //           onPressed: () => Navigator.push(context,MaterialPageRoute(builder: (context) =>  Favourites())),
  //           icon: Icon(
  //             tail,
  //             size: 20,
  //           ),
  //         )),
  //   );
  // }

  Padding libraryList({required child}) {
    return Padding(
      padding: const EdgeInsets.only(left: 5, right: 5, bottom: 10),
      child: child,
    );
  }

  // void submit() {
  //   playlistName = controller.text;
  //   List<Songs> librayry = [];
  //   List? excistingName = [];
  //   if (playlists.isNotEmpty) {
  //     excistingName =
  //         playlists.where((element) => element == playlistName).toList();
  //   }

  //   if (playlistName != '' && excistingName.isEmpty) {
  //     box.put(playlistName, librayry);
  //     Navigator.of(context).pop();
  //     setState(() {
  //       playlists = box.keys.toList();
  //     });
  //   }
  //   else {
  //     ScaffoldMessenger.of(context).showSnackBar(excistingPlaylist);
  //   }
  //   controller.clear();
  // }
}
