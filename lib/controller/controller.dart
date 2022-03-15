import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:get/get.dart';
import 'package:music_player/database/box.dart';
import 'package:music_player/database/songmodel_adapter.dart';
import 'package:on_audio_query/on_audio_query.dart';

class Controller extends GetxController {
  @override
  void onInit() {
    // requesrpermisson();
    fetchSongs();
    super.onInit();
  }

  final _audioQuery = OnAudioQuery();
//int currentIndex = 0;
  final box = Boxes.getInstance();
  final assetAudioPlayer = AssetsAudioPlayer.withId("0");
  List<SongModel> allsong = [];
  List<Songs> mappedSongs = [];
  List<Songs> dbSongs = [];
  List<Audio> audiosongs = [];
  fetchSongs() async {
    bool permissionStatus = await _audioQuery.permissionsStatus();
    if (!permissionStatus) {
      await _audioQuery.permissionsRequest();
    }
    allsong = await _audioQuery.querySongs();
    mappedSongs = allsong
        .map((e) => Songs(
            title: e.title,
            id: e.id,
            uri: e.uri!,
            duration: e.duration,
            artist: e.artist))
        .toList();

    await box.put("musics", mappedSongs);
    dbSongs = box.get("musics") as List<Songs>;
    dbSongs.forEach((element) {
      audiosongs.add(Audio.file(element.uri.toString(),
          metas: Metas(
              title: element.title,
              id: element.id.toString(),
              artist: element.artist)));
    });
  }
}

class SongBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(Controller());
  }
}
