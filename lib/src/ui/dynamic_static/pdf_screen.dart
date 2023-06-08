import 'dart:async';
import 'dart:io';

import 'package:craft_dynamic/craft_dynamic.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

class PDFScreen extends StatefulWidget {
  final String? path;
  final String? pdfName;
  final PdfDocument document;
  bool downloadReceipt;

  PDFScreen(
      {Key? key,
      this.path,
      this.pdfName,
      required this.document,
      this.downloadReceipt = true})
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
          widget.downloadReceipt
              ? IconButton(
                  icon: const Icon(Icons.download),
                  onPressed: () async {
                    saveFile(context, isDownload: widget.downloadReceipt);
                  },
                )
              : const SizedBox(),
          widget.downloadReceipt
              ? const SizedBox()
              : IconButton(
                  icon: const Icon(Icons.share),
                  onPressed: () {
                    saveFile(context, isDownload: false);
                  },
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

  saveFile(BuildContext context, {isDownload = true}) {
    if (Platform.isAndroid) {
      try {
        String receiptPath = "";
        String receipt = "${widget.pdfName}.pdf";

        Directory directory = Directory("");
        directory = Directory("/storage/emulated/0/Download");
        AppLogger.appLogD(
            tag: "pdf file",
            message: "Copying file to ==========>${directory.path}");
        receiptPath = "${directory.path}/$receipt";
        File(widget.path ?? "").copy(receiptPath).then((value) {
          if (isDownload) {
            CommonUtils.showActionSnackBar(
              context: context,
              message: "$receipt saved to Download",
            );
          } else {
            openFile(receiptPath, widget.pdfName ?? "", isDownload: isDownload);
          }
        });
      } catch (e) {}
    }
  }

  openFile(String filePath, String pdfName, {isDownload = true}) async {
    Directory tempDir = await getTemporaryDirectory();
    String tempFilePath = '${tempDir.path}/$pdfName.pdf';
    File tempFile = File(tempFilePath);
    await tempFile.writeAsBytes(await File(filePath).readAsBytes());

    if (isDownload) {
      try {
        OpenFile.open(tempFilePath);
      } catch (e) {
        AppLogger.appLogD(tag: "file log....", message: e.toString());
      }
    } else {
      Share.shareXFiles([XFile(tempFilePath)], subject: 'Sharing PDF');
    }
  }

  @override
  void dispose() {
    super.dispose();
    widget.document.dispose();
  }
}
