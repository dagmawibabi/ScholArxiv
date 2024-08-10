// ignore_for_file: file_names
import 'package:flutter/material.dart';

class IDAndDate extends StatefulWidget {
  const IDAndDate({
    super.key,
    required this.id,
    required this.date,
  });

  final String id;
  final String date;

  @override
  State<IDAndDate> createState() => _IDAndDateState();
}

class _IDAndDateState extends State<IDAndDate> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        bottom: 2.0,
        right: 5.0,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "ID: ${widget.id}",
            style: const TextStyle(
              fontSize: 12.0,
            ),
          ),
          const SizedBox(width: 10.0),
        ],
      ),
    );
  }
}
