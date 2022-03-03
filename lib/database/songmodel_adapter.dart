import 'package:hive/hive.dart';
part 'songmodel_adapter.g.dart';

@HiveType(typeId: 1)
class Songs extends HiveObject {
  @HiveField(0)
  String? title;
  @HiveField(1)
  String? artist;
  @HiveField(2)
  int? id;
  @HiveField(3)
  int? duration;
  @HiveField(4)
  String? uri;

  Songs(
      {required this.title,
      required this.artist,
      required this.id,
      required this.duration,
      required this.uri});
}
