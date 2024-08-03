import 'package:flutter/material.dart';

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
        left: 25.0,
        right: 10.0,
      ),
      margin: const EdgeInsets.only(
        // left: 10.0,
        // right: 10.0,
        bottom: 15.0,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            // color: Colors.blue, // Border color
            width: 2.0, // Border width
          ),
        ),
        // border: Border.all(
        //   color: Colors.black,
        // ),
        // borderRadius: BorderRadius.circular(100.0),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: widget.searchTermController,
              decoration: const InputDecoration(
                hintText: "Attention is all...",
                border: InputBorder.none,
              ),
            ),
          ),
          IconButton(
            onPressed: () {
              widget.searchFunction();
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
