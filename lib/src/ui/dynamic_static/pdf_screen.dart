import 'dart:io';

import 'package:craft_dynamic/craft_dynamic.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

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
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.transparent,
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
        body: Container(
          color: Colors.white,
          child: SfPdfViewer.file(
            File.fromUri(Uri.parse(widget.path ?? "")),
            key: _pdfViewerKey,
            pageLayoutMode: PdfPageLayoutMode.single,
            canShowPageLoadingIndicator: true,
          ),
        ));
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
