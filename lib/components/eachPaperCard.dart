// ignore_for_file: file_names
import 'package:arxiv/components/idAndDate.dart';
import 'package:arxiv/components/summaryBottomSheet.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:ionicons/ionicons.dart';
import 'package:share_plus/share_plus.dart';

class EachPaperCard extends StatefulWidget {
  const EachPaperCard({
    super.key,
    required this.parseAndLaunchURL,
    required this.eachPaper,
    required this.downloadPaper,
    required this.isBookmarked,
  });

  final dynamic eachPaper;
  final Function downloadPaper;
  final Function parseAndLaunchURL;
  final bool isBookmarked;

  @override
  State<EachPaperCard> createState() => _EachPaperCardState();
}

class _EachPaperCardState extends State<EachPaperCard> {
  var pdfBaseURL = "https://arxiv.org/pdf";

  void shareLink(shareURL) {
    var splitURL = shareURL.split("/");
    var id = splitURL[splitURL.length - 1];
    var selectedURL = "";
    if (id.contains(".") == true) {
      selectedURL = "$pdfBaseURL/$id";
    } else {
      selectedURL = "$pdfBaseURL/cond-mat/$id";
    }
    Share.share(selectedURL);
  }

  void showSummary(dynamic paperData) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SummaryBottomSheet(
        paperData: paperData,
        parseAndLaunchURL: widget.parseAndLaunchURL,
      ),
    );
  }

  bool isBookmarked = false;

  void bookmarkToggle() async {
    await checkIfBookmarked();
    if (isBookmarked == false) {
      Box bookmarksBox = await Hive.openBox("bookmarks");
      List bookmarks = await bookmarksBox.get("bookmarks") ?? [];
      bookmarks.add(widget.eachPaper);
      await bookmarksBox.put("bookmarks", bookmarks);
      await Hive.close();
    } else {
      Box bookmarksBox = await Hive.openBox("bookmarks");
      List bookmarks = await bookmarksBox.get("bookmarks") ?? [];
      List newBookmarks = [];
      for (var eachBookmark in bookmarks) {
        if (eachBookmark["id"] != widget.eachPaper["id"]) {
          newBookmarks.add(eachBookmark);
        }
      }
      await bookmarksBox.put("bookmarks", newBookmarks);
      await Hive.close();
    }
    await checkIfBookmarked();
    setState(() {});
  }

  Future<void> checkIfBookmarked() async {
    Box bookmarksBox = await Hive.openBox("bookmarks");
    List bookmarks = await bookmarksBox.get("bookmarks") ?? [];
    await Hive.close();

    for (var eachBookmark in bookmarks) {
      if (eachBookmark["id"] == widget.eachPaper["id"]) {
        isBookmarked = true;
        break;
      }
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    checkIfBookmarked();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        left: 8.0,
        right: 8.0,
        bottom: 6.0,
        top: 6.0,
      ),
      padding: const EdgeInsets.only(
        left: 10.0,
        right: 10.0,
        top: 6.0,
        bottom: 6.0,
      ),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ID and Published Date
          IDAndDate(
            id: widget.eachPaper["id"].toString().substring(
                widget.eachPaper["id"].lastIndexOf("/") + 1,
                widget.eachPaper["id"].length),
            date: widget.eachPaper["published"].toString().substring(0, 10),
          ),

          // TITLE
          GestureDetector(
            onTap: () => widget.parseAndLaunchURL(
              widget.eachPaper["id"].toString(),
              widget.eachPaper["title"].toString(),
            ),
            child: Container(
              padding: const EdgeInsets.only(bottom: 5.0),
              child: Text(
                widget.eachPaper["title"]
                    .toString()
                    .replaceAll(RegExp(r'\\n'), '')
                    .replaceAll(RegExp(r'\\ '), ''),
                style: const TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(bottom: 2.0),
            child: Text(
              "Published: ${widget.eachPaper["published"].toString().substring(0, 10)}",
              style: const TextStyle(
                fontSize: 12.0,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 10.0),
            child: Text(
              "Authors: ${widget.eachPaper["author"].toString().replaceAll("name:", "").replaceAll(RegExp("[\\[\\]\\{\\}]"), "")}",
              style: const TextStyle(
                fontSize: 13.0,
              ),
            ),
          ),

          // AUTHORS
          // Container(
          //   padding: const EdgeInsets.only(bottom: 10.0),
          //   child: Text(
          //     "Authors: ${jsonEncode(eachPaper["author"])}",
          //   ),
          // ),
          // Container(
          //   padding: const EdgeInsets.only(bottom: 20.0),
          //   child: Column(
          //     children: (jsonDecode(jsonEncode(eachPaper["author"])))
          //         .map((eachAuthor) {
          //       return Text(
          //         eachAuthor["name"].toString(),
          //       );
          //     }).toList(),
          //   ),
          // ),
          // SUMMARY, DOWNLOAD and SHARE

          // Actions
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    showSummary(widget.eachPaper);
                  },
                  child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20.0,
                      vertical: 8.0,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xff121212),
                      border: Border.all(
                        color: Colors.black,
                      ),
                      borderRadius: BorderRadius.circular(20.0),
                      // borderRadius: const BorderRadius.only(
                      //   bottomLeft: Radius.circular(12.0),
                      //   bottomRight: Radius.circular(12.0),
                      // ),
                    ),
                    child: const Text(
                      "Summary",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10.0),
              IconButton(
                onPressed: () {
                  bookmarkToggle();
                },
                icon: Icon(
                  isBookmarked == false
                      ? Icons.bookmark_border
                      : Icons.bookmark,
                  color: isBookmarked == false ? Colors.black : Colors.black,
                ),
              ),
              IconButton(
                onPressed: () {
                  shareLink(
                    widget.eachPaper["id"].toString(),
                  );
                },
                icon: const Icon(
                  Ionicons.share_outline,
                ),
              ),
              IconButton(
                onPressed: () {
                  widget.downloadPaper(
                    widget.eachPaper["id"].toString(),
                  );
                },
                icon: const Icon(
                  Icons.downloading_outlined,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
