// ignore_for_file: file_names
import 'package:flutter/material.dart';

class ResultLabel extends StatelessWidget {
  const ResultLabel({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(
        left: 15.0,
        bottom: 10.0,
      ),
      child: Text(
        "Results...",
        style: TextStyle(
          fontSize: 25.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
