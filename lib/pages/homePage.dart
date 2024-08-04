// ignore_for_file: file_names
import 'dart:convert';
import 'dart:math';

import 'package:arxiv/components/eachPaperCard.dart';
import 'package:arxiv/components/loadingIndicator.dart';
import 'package:arxiv/components/searchBox.dart';
import 'package:arxiv/pages/bookmarksPage.dart';
import 'package:arxiv/pages/pdfViewer.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:xml2json/xml2json.dart';
import 'package:path_provider/path_provider.dart';
import 'package:ionicons/ionicons.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var arxivBaseURL = "http://export.arxiv.org/api/query?search_query=all:";
  int startPagination = 0;
  int endPagination = 30;
  int paginationGap = 30;
  var arxivBaseLimitURL = "&start=0&max_results=30";
  var pdfBaseURL = "https://arxiv.org/pdf";
  List suggestions = [
    "attention is all you need",
    "protein measurement",
    "relativity",
    "mathematical theory of communication",
    "molecular cloning",
    "dna sequencing",
    "mental state",
    "fuzzy sets",
    "atheory of justice",
    "tiered reward",
    "neural network",
    "quantum",
    "emotional",
    "behavioural",
    "spiritual",
    "machine learning",
    "entanglement",
    "computer",
    "robotics",
    "books",
    "reading",
    "higgs boson",
    "black hole",
    "planet",
    "rocket",
    "hands",
    "brain",
    "acid",
    "identity",
    "psychology",
    "cats",
    "spider",
    "dog",
    "fear",
  ];

  var isHomeScreenLoading = true;
  TextEditingController searchTermController = TextEditingController();

  var dio = Dio();
  final xml2json = Xml2Json();
  List data = [];

  Future<void> search({bool? resetPagination}) async {
    if (resetPagination == true) {
      startPagination = 0;
      endPagination = paginationGap;
    }
    arxivBaseLimitURL = "&start=$startPagination&max_results=$endPagination";
    isHomeScreenLoading = true;
    data = [];
    setState(() {});

    Response result;
    var searchTerm = searchTermController.text.toString().trim();
    if (searchTerm == "" || searchTerm == " ") {
      Random random = Random();
      int randomIndex = random.nextInt(suggestions.length);
      String randomItem = suggestions[randomIndex];
      int pageJump = random.nextInt(3) + random.nextInt(2);
      startPagination += paginationGap * pageJump;
      endPagination += paginationGap * pageJump;

      result = await dio.get("$arxivBaseURL$randomItem$arxivBaseLimitURL");
    } else {
      result = await dio.get("$arxivBaseURL$searchTerm$arxivBaseLimitURL");
    }
    xml2json.parse(result.data);
    var jsonString = xml2json.toParker();
    var jsonObject = await json.decode(jsonString);

    try {
      data = jsonObject["feed"]["entry"];
    } catch (e) {
      data = [];
    }

    isHomeScreenLoading = false;
    setState(() {});
  }

  var paperTitle = "";
  var savePath = "";
  var pdfURL = "";
  dynamic downloadPath = "";

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

    if (urlType == 2) {
      var result = await dio.downloadUri(parsedURL, savePath);
      if (result.statusCode != 200) {}
    }

    Navigator.push(
      // ignore: use_build_context_synchronously
      context,
      MaterialPageRoute(
        builder: (context) => PDFViewer(
          paperTitle: paperTitle,
          savePath: savePath,
          pdfURL: pdfURL,
          urlType: urlType,
          downloadPaper: downloadPaper,
        ),
      ),
    );
    setState(() {});
  }

  void downloadPaper(String paperURL) async {
    var splitURL = paperURL.split("/");
    var id = splitURL[splitURL.length - 1];
    var selectedURL = "";
    if (id.contains(".") == true) {
      selectedURL = "$pdfBaseURL/$id";
    } else {
      selectedURL = "$pdfBaseURL/cond-mat/$id";
    }
    await launchUrl(Uri.parse(selectedURL));
  }

  void askPermissions() async {
    await Permission.accessMediaLocation.request();
    await Permission.manageExternalStorage.request();
    await Permission.mediaLibrary.request();
    await Permission.storage.request();
  }

  @override
  void initState() {
    super.initState();
    search();
    askPermissions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "ScholArxiv",
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BookmarksPage(
                    downloadPaper: downloadPaper,
                    parseAndLaunchURL: parseAndLaunchURL,
                  ),
                ),
              );
            },
            icon: const Icon(
              Icons.bookmark_border_outlined,
            ),
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: LiquidPullToRefresh(
        onRefresh: search,
        backgroundColor: Colors.white,
        color: const Color(0xff121212),
        animSpeedFactor: 2.0,
        child: ListView(
          children: [
            // Search Box
            SearchBox(
              searchTermController: searchTermController,
              searchFunction: search,
            ),

            // Results Label
            // const ResultLabel(),

            // Data or Loading
            isHomeScreenLoading == true
                ? const LoadingIndicator(
                    topPadding: 200.0,
                  )
                : data.isNotEmpty
                    ? Column(
                        children: data.map(
                          (eachPaper) {
                            return EachPaperCard(
                              eachPaper: eachPaper,
                              downloadPaper: downloadPaper,
                              parseAndLaunchURL: parseAndLaunchURL,
                              isBookmarked: false,
                            );
                          },
                        ).toList(),
                      )
                    : const Padding(
                        padding: EdgeInsets.only(top: 200.0),
                        child: Center(
                          child: Text(
                            "No Results Found!",
                          ),
                        ),
                      ),

            const SizedBox(
              height: 20.0,
            ),

            // Pagination
            data.isNotEmpty
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () {
                          if (startPagination >= paginationGap) {
                            startPagination -= paginationGap;
                            endPagination -= paginationGap;
                            search();
                          }
                        },
                        icon: Icon(
                          Ionicons.arrow_back,
                          color: Colors.grey[400]!,
                          size: 20.0,
                        ),
                      ),
                      Text(
                        "Showing results from $startPagination to $endPagination",
                        style: TextStyle(
                          color: Colors.grey[600]!,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          startPagination += paginationGap;
                          endPagination += paginationGap;
                          search();
                        },
                        icon: Icon(
                          Ionicons.arrow_forward,
                          color: Colors.grey[400]!,
                          size: 20.0,
                        ),
                      ),
                    ],
                  )
                : Container(),

            const SizedBox(
              height: 200.0,
            ),
          ],
        ),
      ),
    );
  }
}
