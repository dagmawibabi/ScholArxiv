import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:theme_provider/theme_provider.dart';

class EachChatMessage extends StatefulWidget {
  const EachChatMessage({
    super.key,
    required this.response,
  });

  final dynamic response;

  @override
  State<EachChatMessage> createState() => _EachChatMessageState();
}

class _EachChatMessageState extends State<EachChatMessage> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: widget.response["role"] == "USER"
          ? MainAxisAlignment.end
          : MainAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            widget.response["role"] == "AI"
                ? Padding(
                    padding: const EdgeInsets.only(top: 8.0, left: 10.0),
                    child: Icon(Icons.memory_outlined),
                  )
                : Container(),
            Container(
              constraints: BoxConstraints(
                minWidth: 50.0,
                maxWidth: MediaQuery.of(context).size.width * 0.75,
                maxHeight: 500.0,
              ),
              margin: const EdgeInsets.only(
                left: 8.0,
                right: 8.0,
                bottom: 12.0,
              ),
              decoration: BoxDecoration(
                color: ThemeProvider.themeOf(context)
                        .data
                        .textTheme
                        .bodyLarge
                        ?.color
                        ?.withAlpha(12) ??
                    Colors.grey[100],
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: widget.response["role"] == "USER"
                  ? Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 13.0,
                        vertical: 10.0,
                      ),
                      child: Text(
                        widget.response["content"],
                      ),
                    )
                  : Markdown(
                      data: widget.response["content"],
                      selectable: false,
                      shrinkWrap: true,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 13.0,
                        vertical: 10.0,
                      ),
                    ),
            ),
            widget.response["role"] == "USER"
                ? Padding(
                    padding: const EdgeInsets.only(top: 8.0, right: 10.0),
                    child: Icon(Icons.person_outline),
                  )
                : Container(),
          ],
        ),
      ],
    );
  }
}
