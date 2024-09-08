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
        jsonData["id"].toString().substring(
              jsonData["id"].toString().lastIndexOf("/") + 1,
              jsonData["id"].toString().length,
            ),
        _parseLatex(
          jsonData["title"]
              .toString()
              .replaceAll(RegExp(r'\\n'), '')
              .replaceAll(RegExp(r'\\ '), ''),
        ),
        _parseLatex(
          jsonData["summary"]
              .toString()
              .trim()
              .replaceAll(RegExp(r'\\n'), ' ')
              .replaceAll(RegExp(r'\\'), ''),
        ),
        jsonData["published"].toString().substring(0, 10),
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

  static bool containsLatex(String title) {
    final latexRegex = RegExp(r'[$\\{}]');
    return latexRegex.hasMatch(title);
  }

  static String _parseLatex(String content) {
    if (containsLatex(content)) {
      return content
          .replaceAll(RegExp(r'\$ '), r' \) ')
          .replaceAll(RegExp(r' \$'), r' \( ')
          .replaceAll(r'$', r' \) ');
    }
    return content;
  }
}
