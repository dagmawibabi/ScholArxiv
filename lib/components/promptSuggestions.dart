import 'package:flutter/material.dart';
import 'package:theme_provider/theme_provider.dart';

class PromptSuggestions extends StatefulWidget {
  const PromptSuggestions({
    super.key,
    required this.chatWithAI,
    required this.userMessageController,
    required this.promptSuggestions,
  });

  final Function chatWithAI;
  final TextEditingController userMessageController;
  final List promptSuggestions;

  @override
  State<PromptSuggestions> createState() => _PromptSuggestionsState();
}

class _PromptSuggestionsState extends State<PromptSuggestions> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 20.0),
      child: Column(
        children: widget.promptSuggestions
            .map(
              (suggestion) => GestureDetector(
                onTap: () {
                  widget.userMessageController.text = suggestion;
                  widget.chatWithAI();
                },
                child: Center(
                  child: Container(
                    margin: const EdgeInsets.only(
                      top: 10.0,
                      left: 20.0,
                      right: 20.0,
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14.0, vertical: 10.0),
                    decoration: BoxDecoration(
                      color: ThemeProvider.themeOf(context)
                              .data
                              .textTheme
                              .bodyLarge
                              ?.color
                              ?.withAlpha(12) ??
                          Colors.grey[100],
                      border: Border.all(
                        color: Colors.grey[200]!,
                      ),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Text(
                      suggestion,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
