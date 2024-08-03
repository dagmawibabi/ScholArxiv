import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

class SummaryBottomSheet extends StatefulWidget {
  const SummaryBottomSheet({
    super.key,
    required this.summary,
  });

  final String summary;

  @override
  State<SummaryBottomSheet> createState() => _SummaryBottomSheetState();
}

class _SummaryBottomSheetState extends State<SummaryBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        clipBehavior: Clip.hardEdge,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              clipBehavior: Clip.hardEdge,
              margin: const EdgeInsets.all(2.0),
              decoration: const BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0),
                  // bottomLeft: Radius.circular(20.0),
                  // bottomRight: Radius.circular(20.0),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 20.0,
                  right: 5.0,
                  top: 5.0,
                  bottom: 5.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Summary",
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Ionicons.open_outline,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.45,
              width: double.infinity,
              child: ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 20.0,
                      right: 20.0,
                      top: 10.0,
                      bottom: 100.0,
                    ),
                    child: Text(
                      widget.summary
                          .trim()
                          .replaceAll(RegExp(r'\\n'), ' ')
                          .replaceAll(RegExp(r'\\'), ''),
                      style: const TextStyle(
                        fontSize: 15.0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
