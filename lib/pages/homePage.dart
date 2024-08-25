// ignore_for_file: file_names
import 'dart:convert';
import 'dart:math';
import 'package:arxiv/components/eachPaperCard.dart';
import 'package:arxiv/components/loadingIndicator.dart';
import 'package:arxiv/components/searchBox.dart';
import 'package:arxiv/pages/aiChatPage.dart';
import 'package:arxiv/pages/bookmarksPage.dart';
import 'package:arxiv/pages/pdfViewer.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:theme_provider/theme_provider.dart';
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
  var sourceCodeURL = "https://github.com/dagmawibabi/ScholArxiv";
  var arxivBaseURL = "http://export.arxiv.org/api/query?search_query=all:";
  int startPagination = 0;
  int maxContent = 30;
  int paginationGap = 30;
  var arxivBaseLimitURL = "&start=0&max_results=30";
  var pdfBaseURL = "https://arxiv.org/pdf";
  List suggestions = [
    "acid",
    "atheory of justice",
    "attention is all you need",
    "augmented",
    "behavioural",
    "books",
    "black hole",
    "brain",
    "cats",
    "computer",
    "creative",
    "dog",
    "dna sequencing",
    "dysonsphere",
    "ecg",
    "emotional",
    "entanglement",
    "fear",
    "fuzzy sets",
    "fidgeting",
    "glucose",
    "garbage",
    "gonad",
    "hands",
    "heart",
    "higgs boson",
    "hydron",
    "identity",
    "industrial",
    "isolation",
    "laptop",
    "love",
    "labratory",
    "machine learning",
    "mathematical theory of communication",
    "mental state",
    "micro",
    "microchip",
    "mobile",
    "molecular cloning",
    "neural network",
    "negative",
    "numbers",
    "pc",
    "planet",
    "protein measurement",
    "psychology",
    "quantum",
    "quasar",
    "qubit",
    "reading",
    "relationship",
    "relativity",
    "robotics",
    "rocket",
    "sitting",
    "spider",
    "spiritual",
    "sulpher",
    "television",
    "tiered reward",
    "transport",
    "virtual reality",
    "volcano",
    "vision",
  ];

  var isHomeScreenLoading = true;
  TextEditingController searchTermController = TextEditingController();

  var dio = Dio();
  final xml2json = Xml2Json();
  List data = [];

  Future<void> search({bool? resetPagination}) async {
    if (resetPagination == true) {
      startPagination = 0;
    }
    arxivBaseLimitURL = "&start=$startPagination&max_results=$maxContent";
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

  @override
  void initState() {
    super.initState();
    search();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:
            ThemeProvider.themeOf(context).data.appBarTheme.backgroundColor,
        title: const Text(
          "ScholArxiv",
        ),
        actions: [
          // BOOKMARKS
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
          // CHANGE THEME
          IconButton(
            onPressed: () {
              ThemeProvider.controllerOf(context).nextTheme();
            },
            icon: Icon(
              ThemeProvider.themeOf(context).id == "light_theme"
                  ? Icons.dark_mode_outlined
                  : ThemeProvider.themeOf(context).id == "dark_theme"
                      ? Icons.sunny_snowing
                      : Ionicons.sunny,
            ),
          ),

          // CHAT WITH AI
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AIChatPage(
                    paperData: "",
                  ),
                ),
              );
            },
            icon: const Icon(
              Icons.auto_awesome_outlined,
            ),
          ),
          const SizedBox(width: 10.0),
        ],
      ),
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
            data.isNotEmpty && searchTermController.text.trim() != ""
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () {
                          if (startPagination >= paginationGap) {
                            startPagination -= paginationGap;
                            search();
                          }
                        },
                        icon: Icon(
                          Ionicons.arrow_back,
                          color: startPagination < paginationGap
                              ? Colors.white
                              : Colors.grey[400]!,
                          size: 20.0,
                        ),
                      ),
                      Text(
                        "Showing results from $startPagination to ${startPagination + maxContent}",
                        style: TextStyle(
                          color: Colors.grey[600]!,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          startPagination += paginationGap;
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

            Container(
              width: 100.0,
              padding: const EdgeInsets.only(top: 200.0, bottom: 40.0),
              child: Center(
                child: Text(
                  "Thank you to arXiv for use of its \nopen access interoperability.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey[400]!,
                    fontSize: 12.0,
                  ),
                ),
              ),
            ),
            Center(
              child: GestureDetector(
                onTap: () {
                  launchUrl(Uri.parse(sourceCodeURL));
                },
                child: const Text(
                  "View Source Code on GitHub",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.blueAccent,
                    fontSize: 12.0,
                  ),
                ),
              ),
            ),

            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: Text(
                  "Made with 🤍 by Dream Intelligence",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey[600]!,
                    fontSize: 12.0,
                  ),
                ),
              ),
            ),

            const SizedBox(
              height: 20.0,
            ),
          ],
        ),
      ),
    );
  }
}
