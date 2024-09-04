
import 'package:hive/hive.dart';

part 'paper.g.dart';

@HiveType(typeId: 1)
class Paper {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String title;
  @HiveField(2)
  final String summary;
  @HiveField(3)
  final String publishedAt;
  @HiveField(4)
  final String authors;

  Paper(
    this.id,
    this.title,
    this.summary,
    this.publishedAt,
    this.authors,
  );

  @override
  String toString() {
    return 'Paper(id: $id, title: $title, summary: $summary, publishedAt: $publishedAt, authors: $authors)';
  }

  factory Paper.fromJson(Map<String, dynamic> jsonData) => Paper(
        jsonData["id"].toString(),
        jsonData["title"].toString(),
        jsonData["summary"].toString(),
        jsonData["published"].toString(),
        jsonData["author"]
            .toString()
            .replaceAll("name:", "")
            .replaceAll(RegExp("[\\[\\]\\{\\}]"), ""),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "summary": summary,
        "published": publishedAt,
        "author": authors,
      };
}
