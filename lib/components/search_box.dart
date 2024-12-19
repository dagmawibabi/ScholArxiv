// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:theme_provider/theme_provider.dart';

class SearchBox extends StatefulWidget {
  const SearchBox({
    super.key,
    required this.searchTermController,
    required this.searchFunction,
    required this.toggleSortOrder,
    required this.sortOrderNewest,
  });

  final TextEditingController searchTermController;
  final Function searchFunction;
  final Function toggleSortOrder;
  final bool sortOrderNewest;

  @override
  State<SearchBox> createState() => _SearchBoxState();
}

class _SearchBoxState extends State<SearchBox> {
  @override
  void initState() {
    super.initState();
    widget.searchTermController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  void clearSearchQuery() {
    widget.searchTermController.clear();
  }

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
                  contentPadding: const EdgeInsets.symmetric(vertical: 15.0),
                  suffixIcon: widget.searchTermController.text.isNotEmpty
                      ? IconButton(
                          onPressed: () {
                            clearSearchQuery();
                          },
                          icon: const Icon(
                            Icons.clear,
                            color: Colors.grey,
                          ),
                        )
                      : null,
                ),
                onSubmitted: (searchTerm) {
                  widget.searchFunction(resetPagination: true);
                },
              ),
            ),
          ),
          IconButton(
            onPressed: () {
              widget.toggleSortOrder();
            },
            icon: const Icon(
              Icons.sort,
              color: Colors.grey,
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
