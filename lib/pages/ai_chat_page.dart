// ignore_for_file: file_names

import 'package:arxiv/components/api_settings.dart';
import 'package:arxiv/components/each_chat_message.dart';
import 'package:arxiv/components/prompt_suggestions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:hive/hive.dart';
import 'package:ionicons/ionicons.dart';
import 'package:theme_provider/theme_provider.dart';

class AIChatPage extends StatefulWidget {
  const AIChatPage({super.key, required this.paperData});

  final dynamic paperData;

  @override
  State<AIChatPage> createState() => _AIChatPageState();
}

class _AIChatPageState extends State<AIChatPage> {
  TextEditingController userMessageController = TextEditingController();
  ScrollController scrollController = ScrollController();
  var apiKey = "";
  var aiResponse = "";
  var systemPrompt = "";
  List chatList = [];
  var apiKeySettingsOn = false;
  var toolsOn = true;

  var paperPromptSuggestions = [
    "Who wrote this paper?",
    "What is the title of this paper?",
    "What is the summary of this paper?",
    "What is the significance of this paper?",
    "Tell me a joke based on this paper's title?",
    "Can you explain like I am five years old?",
    "What do you know about the authors?",
    "Suggest and list related papers?",
    "How can this apply to my life?",
  ];

  var generalPromptSuggestions = [
    "What is arXiv?",
    "Tell me about ScholArxiv?",
    "Most profound research papers published?",
    "How can I get started writing research papers?",
    "Precautions to take while reading research papers?",
    "Where can I view the source code of ScholArxiv?",
    "List the main sections of research papers?",
    "Purpose of research papers?",
  ];

  void scrollToTheBottom() {
    setState(() {});
    try {
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    } catch (e) {
      //
    }
  }

  void chatWithAI() async {
    var message = userMessageController.text.trim();
    userMessageController.clear();

    if (message != "") {
      var userResponseObject = {"role": "USER", "content": message};
      chatList.add(userResponseObject);

      var systemLoadingObject = {
        "role": "SYSTEM",
        "content": "SYMLOADINGANIMATION"
      };
      chatList.add(systemLoadingObject);
      scrollToTheBottom();
      var aiResponseObject = {};

      try {
        var model = GenerativeModel(
          apiKey: apiKey,
          model: 'gemini-1.5-flash',
          systemInstruction: Content.system(systemPrompt),
          generationConfig: GenerationConfig(
            temperature: 1,
            topK: 64,
            topP: 0.95,
            maxOutputTokens: 8192,
            responseMimeType: 'text/plain',
          ),
        );

        var chat = model.startChat();
        var content = Content.text(message);

        var response = await chat.sendMessage(content);
        aiResponse = response.text?.trim() ?? "";
        aiResponseObject = {"role": "AI", "content": response.text};
      } catch (e) {
        aiResponseObject = {"role": "AI", "content": e.toString()};
      }

      chatList.removeLast();
      setState(() {});
      chatList.add(aiResponseObject);
      setState(() {});

      scrollToTheBottom();
    }
  }

  void clearChat() async {
    chatList.clear();
    setState(() {});
  }

  void configAPIKey() async {
    Box apiBox = await Hive.openBox("apibox");
    apiKey = await apiBox.get("apikey") ?? "";
    await Hive.close();
    if (apiKey == "") {
      apiKeySettingsOn = true;
    } else {
      apiKeySettingsOn = false;
    }
    setState(() {});
  }

  void toggleAPIKeySettings() {
    apiKeySettingsOn = !apiKeySettingsOn;
    setState(() {});
  }

  void toggleTools() async {
    toolsOn = !toolsOn;
    Box toolsBox = await Hive.openBox("toolsBox");
    await toolsBox.put("toolsBox", toolsOn);
    await Hive.close();
    setState(() {});
  }

  void getToggleTools() async {
    Box toolsBox = await Hive.openBox("toolsBox");
    toolsOn = await toolsBox.get("toolsBox") ?? true;
    await Hive.close();
    setState(() {});
  }

  void setupModelSystemMessage() async {
    var paperId = widget.paperData["id"].toString().substring(
        widget.paperData["id"].lastIndexOf("/") + 1,
        widget.paperData["id"].length);
    var paperTitle = widget.paperData["title"]
        .toString()
        .replaceAll(RegExp(r'\\n'), '')
        .replaceAll(RegExp(r'\\ '), '');
    var paperAuthors = widget.paperData["author"]
        .toString()
        .replaceAll("name:", "")
        .replaceAll(RegExp("[\\[\\]\\{\\}]"), "");
    var paperPublishedDate =
        widget.paperData["published"].toString().substring(0, 10);
    var paperSummary = widget.paperData["summary"]
        .trim()
        .replaceAll(RegExp(r'\\n'), ' ')
        .replaceAll(RegExp(r'\\'), '');

    var substitutes = {
      'paperId': paperId,
      'paperTitle': paperTitle,
      'paperAuthors': paperAuthors,
      'paperPublishedDate': paperPublishedDate,
      'paperSummary': paperSummary
    };

    systemPrompt = await fromTemplateFile(
        'assets/system_message_templates/model.txt', substitutes);
  }

  void setupGeneralSystemMessage() async {
    systemPrompt = await fromTemplateFile(
        'assets/system_message_templates/general.txt', {});
  }

  /// Interpolates values to a text read from a file. The format for a placeholder is {{some_name}}.
  Future<String> fromTemplateFile(
      String fileName, Map<String, dynamic> substitutes) async {
    var template = await rootBundle.loadString(fileName);
    return template.splitMapJoin(RegExp('{{.*?}}'),
        onMatch: (m) => substitutes[getPlaceholderName(m.group(0))] ?? '');
  }

  String getPlaceholderName(String? placeholderTemplate) {
    if (placeholderTemplate == null) return '';

    return placeholderTemplate.substring(2, placeholderTemplate.length - 2);
  }

  @override
  void initState() {
    super.initState();
    getToggleTools();
    configAPIKey();
    widget.paperData == ""
        ? setupGeneralSystemMessage()
        : setupModelSystemMessage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("ScholArxiv AI"),
        actions: [
          // TOGGLE TOOLS
          IconButton(
            onPressed: () {
              toggleTools();
            },
            icon: const Icon(
              Icons.menu_open_rounded,
            ),
          ),
          // API KEY SETTINGS
          IconButton(
            onPressed: () {
              toggleAPIKeySettings();
            },
            icon: const Icon(
              Ionicons.key_outline,
            ),
          ),

          // CLEAR CHAT
          IconButton(
            onPressed: () {
              clearChat();
            },
            icon: const Icon(
              Icons.delete_forever_outlined,
            ),
          ),
          const SizedBox(width: 5.0),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 10.0),

          Expanded(
            child: chatList.isEmpty || apiKeySettingsOn == true
                ? ListView(
                    padding: const EdgeInsets.only(top: 30.0),
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 20.0),
                            child: Icon(
                              Icons.auto_awesome_outlined,
                              size: 30.0,
                              color: ThemeProvider.themeOf(context)
                                  .data
                                  .textTheme
                                  .bodyLarge
                                  ?.color,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 50.0,
                            ),
                            child: const Text(
                              "This AI conversation is powered by Google's Gemini 1.5 Flash. You can have conversations about the current paper here.",
                              textAlign: TextAlign.center,
                            ),
                          ),
                          apiKeySettingsOn == true
                              ? APISettings(
                                  configAPIKey: configAPIKey,
                                )
                              : PromptSuggestions(
                                  chatWithAI: chatWithAI,
                                  userMessageController: userMessageController,
                                  promptSuggestions: widget.paperData == ""
                                      ? generalPromptSuggestions
                                      : paperPromptSuggestions,
                                ),
                        ],
                      ),
                    ],
                  )
                : ListView.builder(
                    controller: scrollController,
                    itemCount: chatList.length,
                    itemBuilder: (context, index) {
                      final item = chatList[index];
                      return EachChatMessage(
                        response: item,
                        toolsOn: toolsOn,
                      );
                    },
                  ),
          ),
          // Chat Box and Send Button
          Padding(
            padding: const EdgeInsets.only(left: 10.0, bottom: 8.0, top: 8.0),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.only(left: 18.0, right: 18.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30.0),
                      color: ThemeProvider.themeOf(context)
                              .data
                              .textTheme
                              .bodyLarge
                              ?.color
                              ?.withAlpha(12) ??
                          Colors.grey[100],
                    ),
                    child: TextField(
                      controller: userMessageController,
                      enabled: !(apiKeySettingsOn == true),
                      cursorColor:
                          ThemeProvider.themeOf(context).id == "mixed_theme"
                              ? Colors.white
                              : ThemeProvider.themeOf(context)
                                  .data
                                  .textTheme
                                  .bodyLarge
                                  ?.color,
                      style: TextStyle(
                        color: ThemeProvider.themeOf(context).id == "dark_theme"
                            ? Colors.white
                            : Colors.black,
                      ),
                      decoration: InputDecoration(
                        hintText: widget.paperData == ""
                            ? "ask about anything..."
                            : 'ask about the paper...',
                        hintStyle: TextStyle(color: Colors.grey[700]),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: IconButton(
                    onPressed: () {
                      apiKey == "" ? () {} : chatWithAI();
                    },
                    icon: Icon(
                      Ionicons.paper_plane_outline,
                      color: ThemeProvider.themeOf(context)
                          .data
                          .textTheme
                          .bodyLarge
                          ?.color,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
