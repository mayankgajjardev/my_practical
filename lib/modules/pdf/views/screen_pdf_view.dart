import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

class ScreenPdfView extends StatefulWidget {
  final String pdfUrl;
  const ScreenPdfView({super.key, required this.pdfUrl});

  @override
  State<ScreenPdfView> createState() => _ScreenPdfViewState();
}

class _ScreenPdfViewState extends State<ScreenPdfView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PDFView(
        filePath: widget.pdfUrl,
        onError: (error) {
          debugPrint("Mayank :: onError :: $error");
        },
        onPageError: (page, error) {
          debugPrint("Mayank :: onPageError :: $error");
        },
      ),
    );
  }
}
