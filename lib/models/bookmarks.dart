import 'package:hive/hive.dart';

part 'bookmarks.g.dart';

@HiveType(typeId: 0)
class Bookmark extends HiveObject {
  @HiveField(0)
  late dynamic paperData;
}
