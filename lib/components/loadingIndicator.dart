import 'package:flutter/material.dart';

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(top: 200.0),
      child: Center(
        child: CircularProgressIndicator(
          color: Colors.black,
        ),
      ),
    );
  }
}
