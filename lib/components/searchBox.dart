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
        left: 30.0,
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
            ),
          ),
          IconButton(
            onPressed: () {
              widget.searchFunction(resetPagination: true);
            },
            icon: const Icon(
              Icons.search,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
