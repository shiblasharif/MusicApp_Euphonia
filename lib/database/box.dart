import 'package:hive/hive.dart';
import 'package:music_player/database/songmodel_adapter.dart';

String boxname = "songs";

class Boxes { 
  static Box<List>? _box;

  static Box<List> getInstance() {
    return _box ??= Hive.box(boxname);
  }
}
