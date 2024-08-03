import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PDFViewer extends StatefulWidget {
  const PDFViewer({
    super.key,
    required this.paperTitle,
    required this.savePath,
    required this.pdfURL,
    required this.urlType,
  });

  final String paperTitle;
  final String savePath;
  final String pdfURL;
  final int urlType;

  @override
  State<PDFViewer> createState() => _PDFViewerState();
}

class _PDFViewerState extends State<PDFViewer> {
  bool isNightMode = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          widget.paperTitle,
          style: const TextStyle(
            fontSize: 16.0,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => {
              setState(() {
                isNightMode != isNightMode;
              }),
            },
            icon: const Icon(
              Icons.download_outlined,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.bookmark_outline,
            ),
          ),
        ],
      ),
      body: widget.urlType == 1
          ? SfPdfViewer.network(
              widget.pdfURL,
              enableTextSelection: true,
            )
          : PDFView(
              filePath: widget.savePath,
              // enableSwipe: true,
              // swipeHorizontal: true,
              autoSpacing: false,
              pageFling: false,
              nightMode: isNightMode,
            ),
    );
  }
}
