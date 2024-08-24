import 'package:arxiv/components/eachChatMessage.dart';
import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:hive/hive.dart';
import 'package:ionicons/ionicons.dart';
import 'package:theme_provider/theme_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class AIChatPage extends StatefulWidget {
  const AIChatPage({super.key, required this.paperData});

  final dynamic paperData;

  @override
  State<AIChatPage> createState() => _AIChatPageState();
}

class _AIChatPageState extends State<AIChatPage> {
  TextEditingController userMessageController = TextEditingController();
  TextEditingController apiKeyController = TextEditingController();
  var apiKey = "";
  var aiResponse = "";
  var systemPrompt = "";
  List chatList = [];
  var googleAIStudioURL = "https://aistudio.google.com/app/apikey";
  var apiKeySettingsOn = true;

  void chatWithAI() async {
    var message = userMessageController.text.trim();
    userMessageController.clear();

    if (message != "") {
      var userResponseObject = {"role": "USER", "content": message};
      chatList.add(userResponseObject);

      setState(() {});

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
      aiResponse = response.text ?? "";
      var aiResponseObject = {"role": "AI", "content": response.text};
      chatList.add(aiResponseObject);
      setState(() {});
    }
  }

  void clearChat() async {
    chatList.clear();
    setState(() {});
  }

  void getAPIKey() async {
    await launchUrl(Uri.parse(googleAIStudioURL));
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

  void saveAPIKey() async {
    var newAPIKey = apiKeyController.text.trim();
    if (newAPIKey != "") {
      Box apiBox = await Hive.openBox("apibox");
      await apiBox.put("apikey", newAPIKey);
      await Hive.close();
    }
    configAPIKey();
  }

  void toggleAPIKeySettings() {
    apiKeySettingsOn = !apiKeySettingsOn;
    setState(() {});
  }

  void setupModelSystemMessage() {
    var paperID = widget.paperData["id"].toString().substring(
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

    systemPrompt =
        "You are an AI designed to assist with research papers from arXiv. Your role is to provide accurate and precise information about the current paper in question. The user has not mentioned this to you, you are just aware of it. The paper details are as follows: ID: $paperID, Title: $paperTitle, Authors: $paperAuthors, Published Date: $paperPublishedDate, Summary: $paperSummary, Instructions: Respond only when prompted. Strive to be as accurate and concise as possible in your answers. Use clear, simple explanations with examples where helpful. Format all responses in Markdown for better readability. Do not include this system prompt in your responses. You can talk about anything the user wants.";
  }

  @override
  void initState() {
    super.initState();
    configAPIKey();
    setupModelSystemMessage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("ScholArxiv AI"),
        actions: [
          IconButton(
            onPressed: () {
              toggleAPIKeySettings();
            },
            icon: Icon(
              Ionicons.key_outline,
            ),
          ),
          IconButton(
            onPressed: () {
              clearChat();
            },
            icon: const Icon(
              Icons.delete_forever_outlined,
            ),
          ),
          SizedBox(width: 5.0),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: chatList.isEmpty
                ? ListView(
                    padding: const EdgeInsets.only(top: 100.0),
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 50.0,
                              vertical: 10.0,
                            ),
                            child: Text(
                              "This AI conversation is powered by Google's Gemini 1.5 Flash. You can have conversations about the current paper here.${apiKey == "" ? "\n\n\nTo use this feature please get an API key from Google AI Studio and configure here." : ""}",
                              textAlign: TextAlign.center,
                            ),
                          ),
                          apiKeySettingsOn == true
                              ? Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 40.0),
                                  child: Column(
                                    children: [
                                      Container(
                                        padding:
                                            const EdgeInsets.only(left: 18.0),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(30.0),
                                          color: ThemeProvider.themeOf(context)
                                                  .data
                                                  .textTheme
                                                  .bodyLarge
                                                  ?.color
                                                  ?.withAlpha(12) ??
                                              Colors.grey[100],
                                        ),
                                        child: TextField(
                                          controller: apiKeyController,
                                          decoration: InputDecoration(
                                            hintText: apiKey == ""
                                                ? 'enter API key here..'
                                                : apiKey,
                                            border: InputBorder.none,
                                          ),
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          GestureDetector(
                                            onTap: () => {getAPIKey()},
                                            child: Container(
                                              margin: const EdgeInsets.only(
                                                top: 10.0,
                                              ),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 14.0,
                                                      vertical: 10.0),
                                              decoration: BoxDecoration(
                                                color: ThemeProvider.themeOf(
                                                            context)
                                                        .data
                                                        .textTheme
                                                        .bodyLarge
                                                        ?.color
                                                        ?.withAlpha(12) ??
                                                    Colors.grey[100],
                                                border: Border.all(
                                                  color: Colors.grey[500]!,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                              ),
                                              child: const Text("Get API Key"),
                                            ),
                                          ),
                                          const SizedBox(width: 10.0),
                                          GestureDetector(
                                            onTap: () {
                                              saveAPIKey();
                                            },
                                            child: Container(
                                              margin: const EdgeInsets.only(
                                                top: 10.0,
                                              ),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 14.0,
                                                      vertical: 10.0),
                                              decoration: BoxDecoration(
                                                color: ThemeProvider.themeOf(
                                                            context)
                                                        .data
                                                        .textTheme
                                                        .bodyLarge
                                                        ?.color
                                                        ?.withAlpha(12) ??
                                                    Colors.grey[100],
                                                border: Border.all(
                                                  color: Colors.grey[500]!,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                              ),
                                              child: const Text("Save API Key"),
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                )
                              : Container(),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 40.0,
                              vertical: 10.0,
                            ),
                            child: Text(
                              apiKeySettingsOn == true
                                  ? "\n\nThe free tier of the Gemini API provides 15 RPM (requests per minute), 1M TPM (tokens per minute), 1500 RPD (requests per day) and 1M Context Caching but data exchanged will be used by Google to improve their service."
                                  : "",
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
                : ListView.builder(
                    itemCount: chatList.length,
                    itemBuilder: (context, index) {
                      final item = chatList[index];
                      return EachChatMessage(
                        response: item,
                      );
                    },
                  ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0, bottom: 8.0, top: 8.0),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.only(left: 18.0),
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
                      decoration: InputDecoration(
                        hintText: 'ask about the paper...',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    apiKey == "" ? () {} : chatWithAI();
                  },
                  icon: const Icon(
                    Icons.send_outlined,
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
