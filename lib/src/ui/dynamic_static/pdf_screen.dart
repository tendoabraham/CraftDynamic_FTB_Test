import 'dart:async';
import 'dart:io';

import 'package:craft_dynamic/craft_dynamic.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

class PDFScreen extends StatefulWidget {
  final String? path;
  final String? pdfName;
  final PdfDocument document;

  PDFScreen({Key? key, this.path, this.pdfName, required this.document})
      : super(key: key);

  _PDFScreenState createState() => _PDFScreenState();
}

class _PDFScreenState extends State<PDFScreen> with WidgetsBindingObserver {
  final Completer<PDFViewController> _controller =
      Completer<PDFViewController>();
  int? pages = 0;
  int? currentPage = 0;
  bool isReady = false;
  String errorMessage = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Receipt"),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () async {
              saveFile();
            },
          ),
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {},
          ),
        ],
      ),
      body: Stack(
        children: <Widget>[
          PDFView(
            filePath: widget.path,
            enableSwipe: false,
            swipeHorizontal: true,
            autoSpacing: false,
            pageFling: true,
            pageSnap: true,
            defaultPage: currentPage!,
            fitPolicy: FitPolicy.BOTH,
            preventLinkNavigation:
                false, // if set to true the link is handled in flutter
            onRender: (_pages) {
              setState(() {
                pages = _pages;
                isReady = true;
              });
            },
            onError: (error) {
              setState(() {
                errorMessage = error.toString();
              });
              print(error.toString());
            },
            onPageError: (page, error) {
              setState(() {
                errorMessage = '$page: ${error.toString()}';
              });
              print('$page: ${error.toString()}');
            },
            onViewCreated: (PDFViewController pdfViewController) {
              _controller.complete(pdfViewController);
            },
            onLinkHandler: (String? uri) {
              print('goto uri: $uri');
            },
            onPageChanged: (int? page, int? total) {
              print('page change: $page/$total');
              setState(() {
                currentPage = page;
              });
            },
          ),
          errorMessage.isEmpty
              ? !isReady
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : Container()
              : Center(
                  child: Text(errorMessage),
                )
        ],
      ),
    );
  }

  saveFile() async {
    if (Platform.isAndroid) {
      try {
        String receipt = "${widget.pdfName}.pdf";
        Directory _directory = Directory("");
        _directory = Directory("/storage/emulated/0/Download");
        AppLogger.appLogD(
            tag: "pdf file",
            message: "Copying file to ==========>${_directory.path}");
        await File(widget.path ?? "").copy("${_directory.path}/$receipt");
        CommonUtils.showToast("$receipt saved successfully to Downloads");
      } catch (e) {}
    }
  }

  @override
  void dispose() {
    super.dispose();
    widget.document.dispose();
  }
}
