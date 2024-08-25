// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:theme_provider/theme_provider.dart';

class SearchBox extends StatefulWidget {
  const SearchBox({
    super.key,
    required this.searchTermController,
    required this.searchFunction,
  });

  final TextEditingController searchTermController;
  final Function searchFunction;

  @override
  State<SearchBox> createState() => _SearchBoxState();
}

class _SearchBoxState extends State<SearchBox> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        left: 10.0,
        right: 10.0,
      ),
      margin: const EdgeInsets.only(
        bottom: 12.0,
      ),
      decoration: BoxDecoration(
        color: ThemeProvider.themeOf(context).data.appBarTheme.backgroundColor,
      ),
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
                controller: widget.searchTermController,
                keyboardType: TextInputType.url,
                cursorColor: ThemeProvider.themeOf(context).id == "mixed_theme"
                    ? Colors.white
                    : ThemeProvider.themeOf(context)
                        .data
                        .textTheme
                        .bodyLarge
                        ?.color,
                style: TextStyle(
                  color: ThemeProvider.themeOf(context).id == "light_theme"
                      ? Colors.black
                      : Colors.white,
                ),
                decoration: InputDecoration(
                  hintText: "Search...",
                  hintStyle: TextStyle(color: Colors.grey[700]),
                  border: InputBorder.none,
                ),
                onSubmitted: (searchTerm) {
                  widget.searchFunction(resetPagination: true);
                },
              ),
            ),
          ),
          IconButton(
            onPressed: () {
              widget.searchFunction(resetPagination: true);
            },
            icon: const Icon(
              Icons.search,
            ),
          ),
        ],
      ),
    );
  }
}
