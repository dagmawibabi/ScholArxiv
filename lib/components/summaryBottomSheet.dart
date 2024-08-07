// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:hive/hive.dart';
import 'package:ionicons/ionicons.dart';

class SummaryBottomSheet extends StatefulWidget {
  const SummaryBottomSheet({
    super.key,
    required this.paperData,
    required this.parseAndLaunchURL,
  });

  final dynamic paperData;
  final Function parseAndLaunchURL;

  @override
  State<SummaryBottomSheet> createState() => _SummaryBottomSheetState();
}

class _SummaryBottomSheetState extends State<SummaryBottomSheet> {
  var tts = FlutterTts();
  var isSpeaking = false;
  var summary = "";
  var speedRate = 0.5;
  var speedFactor = 0.1;

  void readSummary() async {
    if (isSpeaking == false) {
      await tts.setLanguage("en-US");
      tts.speak(summary);
    } else {
      tts.stop();
    }
    isSpeaking = !isSpeaking;
    setState(() {});
  }

  void changeSpeedRate({bool? increase}) async {
    if (increase == true) {
      if (speedRate < 0.9) {
        speedRate += speedFactor;
      }
    } else {
      if (speedRate >= 0.1) {
        speedRate -= speedFactor;
      }
    }
    tts.stop();
    tts.setSpeechRate(speedRate);
    isSpeaking = false;
    readSummary();
    final box = await Hive.openBox("speedRateBox");
    box.put("speedRate", speedRate);
    await Hive.close();
  }

  void getSpeedRate() async {
    final box = await Hive.openBox("speedRateBox");
    speedRate = await box.get("speedRate");
    await Hive.close();
    tts.setSpeechRate(speedRate);
  }

  void resetSpeechRate() async {
    speedRate = 0.5;
    final box = await Hive.openBox("speedRateBox");
    box.put("speedRate", speedRate);
    await Hive.close();
    tts.stop();
    tts.setSpeechRate(speedRate);
    isSpeaking = false;
    readSummary();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getSpeedRate();
    tts.setCompletionHandler(() {
      isSpeaking = false;
      setState(() {});
    });
    summary = widget.paperData["summary"]
        .trim()
        .replaceAll(RegExp(r'\\n'), ' ')
        .replaceAll(
          RegExp(r'\\'),
          '',
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        clipBehavior: Clip.hardEdge,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              clipBehavior: Clip.hardEdge,
              margin: const EdgeInsets.all(2.0),
              decoration: const BoxDecoration(
                color: Color(0xff121212),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0),
                  // bottomLeft: Radius.circular(20.0),
                  // bottomRight: Radius.circular(20.0),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 20.0,
                  right: 5.0,
                  top: 5.0,
                  bottom: 5.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      "Summary",
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        isSpeaking == true
                            ? Row(
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      if (speedRate > 0.0) {
                                        changeSpeedRate(increase: false);
                                      }
                                    },
                                    icon: Icon(
                                      Icons.remove,
                                      color: Colors.grey[200],
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      resetSpeechRate();
                                    },
                                    child: Text(
                                      speedRate.toStringAsFixed(1).toString(),
                                      style: TextStyle(
                                        color: Colors.grey[200],
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      if (speedRate < 1.0) {
                                        changeSpeedRate(increase: true);
                                      }
                                    },
                                    icon: Icon(
                                      Icons.add,
                                      color: Colors.grey[200],
                                    ),
                                  )
                                ],
                              )
                            : Container(),
                        IconButton(
                          onPressed: () {
                            readSummary();
                          },
                          icon: Icon(
                            isSpeaking == true
                                ? Ionicons.stop_outline
                                : Ionicons.volume_high_outline,
                            color: Colors.white,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 4.0),
                          child: IconButton(
                            onPressed: () {
                              widget.parseAndLaunchURL(
                                widget.paperData["id"].toString(),
                                widget.paperData["title"].toString(),
                              );
                            },
                            icon: const Icon(
                              Ionicons.open_outline,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.47,
              width: double.infinity,
              child: ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 20.0,
                      right: 20.0,
                      top: 10.0,
                      bottom: 100.0,
                    ),
                    child: SelectableText(
                      widget.paperData["summary"]
                          .trim()
                          .replaceAll(RegExp(r'\\n'), ' ')
                          .replaceAll(RegExp(r'\\'), ''),
                      style: const TextStyle(
                        fontSize: 15.0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
