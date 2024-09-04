import 'dart:convert';
import 'dart:math';

import 'package:arxiv/models/paper.dart';
import 'package:dio/dio.dart';
import 'package:xml2json/xml2json.dart';

class Arxiv {
  static const _baseUrl = "http://export.arxiv.org/api/query?search_query=all";

  static final _dio = Dio();

  static const _topics = [
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

  /// Fetches papers for the requested [term].
  /// [page] and [pageSize] are optional. If missing, 0 and 30 are used as defaults respectively.
  static Future<List<Paper>> search(
    String term, {
    int page = 0,
    int pageSize = 30,
  }) async {
    final xml2json = Xml2Json();

    try {
      var response = await _dio.get(
        "$_baseUrl:$term&start=$page&max_results=$pageSize",
      );
      xml2json.parse(response.data);
      var jsonData = await json.decode(xml2json.toParker());
      return jsonData["feed"]["entry"].map<Paper>((entry) => Paper.fromJson(entry)).toList();
    } catch (e) {
      return [];
    }
  }

  /// Fetches papers for a random topic.
  static Future<List<Paper>> suggest({int pageSize = 30}) {
    Random random = Random();
    int randomIndex = random.nextInt(_topics.length);
    String topic = _topics[randomIndex];

    return search(topic, pageSize: pageSize);
  }
}
