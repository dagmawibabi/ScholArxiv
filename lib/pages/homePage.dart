import 'dart:convert';

import 'package:arxiv/components/loadingIndicator.dart';
import 'package:arxiv/components/resultsLabel.dart';
import 'package:arxiv/components/searchBox.dart';
import 'package:arxiv/components/summaryBottomSheet.dart';
import 'package:arxiv/pages/pdfViewer.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:xml2json/xml2json.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:ionicons/ionicons.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var arxivBaseURL = "http://export.arxiv.org/api/query?search_query=all:";
  var arxivBaseLimitURL = "&start=0&max_results=30";
  var pdfBaseURL = "https://arxiv.org/pdf";
  var isHomeScreenLoading = true;
  TextEditingController searchTermController = TextEditingController();

  var dio = Dio();
  final xml2json = Xml2Json();
  List data = [];

  void search() async {
    isHomeScreenLoading = true;
    data = [];
    setState(() {});

    Response result;
    var searchTerm = searchTermController.text.toString().trim();
    if (searchTerm == "" || searchTerm == " ") {
      result = await dio
          .get("${arxivBaseURL}attention is all you need$arxivBaseLimitURL");
    } else {
      result = await dio.get("$arxivBaseURL$searchTerm$arxivBaseLimitURL");
    }
    xml2json.parse(result.data);
    var jsonString = xml2json.toParker();
    var jsonObject = await json.decode(jsonString);
    data = jsonObject["feed"]["entry"];

    isHomeScreenLoading = false;
    setState(() {});
  }

  var paperTitle = "";
  var savePath = "";
  var pdfURL = "";

  Future<void> parseAndLaunchURL(String currentURL, String title) async {
    paperTitle = title;

    var splitURL = currentURL.split("/");
    var id = splitURL[splitURL.length - 1];
    var urlType = 0;
    if (id.contains(".") == true) {
      pdfURL = "$pdfBaseURL/$id";
      urlType = 1;
    } else {
      pdfURL = "$pdfBaseURL/cond-mat/$id";
      urlType = 2;
    }

    final Uri parsedURL = Uri.parse(pdfURL);
    savePath = '${(await getTemporaryDirectory()).path}/paper3.pdf';

    print("=======================");
    print(savePath);
    print(parsedURL);
    print("=======================");

    if (urlType == 2) {
      var result = await dio.downloadUri(parsedURL, savePath);
      if (result.statusCode != 200) {}
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PDFViewer(
          paperTitle: paperTitle,
          savePath: savePath,
          pdfURL: pdfURL,
          urlType: urlType,
        ),
      ),
    );
    setState(() {});
  }

  void showSummary(String summary) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SummaryBottomSheet(
        summary: summary,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    search();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "ScholArxiv",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.bookmark_border_outlined,
            ),
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: ListView(
        children: [
          // Search Box
          SearchBox(
              searchTermController: searchTermController,
              searchFunction: search),

          // Results Label
          const ResultLabel(),

          // Data or Loading
          isHomeScreenLoading == true
              ? const LoadingIndicator()
              : Column(
                  children: data.map(
                    (eachPaper) {
                      return Container(
                        margin: const EdgeInsets.only(
                          left: 10.0,
                          right: 10.0,
                          bottom: 10.0,
                        ),
                        padding: const EdgeInsets.only(
                          left: 15.0,
                          right: 10.0,
                          top: 12.0,
                          bottom: 10.0,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          // border: Border.all(
                          //   color: Colors.black,
                          // ),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // AUTHORS
                            Container(
                              padding: const EdgeInsets.only(
                                  bottom: 5.0, right: 5.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "ID: ${eachPaper["id"].toString().substring(eachPaper["id"].lastIndexOf("/") + 1, eachPaper["id"].length)}",
                                    style: const TextStyle(
                                      fontSize: 12.0,
                                    ),
                                  ),
                                  const SizedBox(width: 10.0),
                                  Text(
                                    "Published: ${eachPaper["published"].toString().substring(0, 10)}",
                                    style: const TextStyle(
                                      fontSize: 12.0,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // TITLE
                            GestureDetector(
                              onTap: () => parseAndLaunchURL(
                                eachPaper["id"].toString(),
                                eachPaper["title"].toString(),
                              ),
                              child: Container(
                                padding: const EdgeInsets.only(bottom: 10.0),
                                child: Text(
                                  eachPaper["title"]
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
                            // PUBLISHED DATE
                            // Container(
                            //   padding: const EdgeInsets.only(bottom: 10.0),
                            //   child: Text(
                            //     "Published: ${eachPaper["published"].toString().substring(0, 10)}",
                            //     style: const TextStyle(
                            //       fontSize: 12.0,
                            //     ),
                            //   ),
                            // ),
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
                            Container(
                              child: Row(
                                children: [
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        showSummary(
                                            eachPaper["summary"].toString());
                                      },
                                      child: Container(
                                        alignment: Alignment.center,
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 20.0,
                                          vertical: 8.0,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.black,
                                          border: Border.all(
                                            color: Colors.black,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(12.0),
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
                                  IconButton(
                                    onPressed: () {},
                                    icon: const Icon(
                                      Icons.bookmark_border,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      Share.share(pdfURL);
                                    },
                                    icon: const Icon(
                                      Ionicons.share_outline,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {},
                                    icon: const Icon(
                                      Icons.downloading_outlined,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ).toList(),
                ),
        ],
      ),
    );
  }
}
