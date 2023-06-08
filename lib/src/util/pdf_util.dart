import 'dart:io';
import 'dart:ui';

import 'package:craft_dynamic/craft_dynamic.dart';
import 'package:craft_dynamic/src/ui/dynamic_static/pdf_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

class PDFUtil {
  static downloadReceipt(PostDynamic postDynamic,
      {downloadReceipt = true}) async {
    String receiptNo = "";
    Color color = APIService.appPrimaryColor;
    final _profileRepo = ProfileRepository();
    final PdfDocument document = PdfDocument();
    final directory = await getExternalStorageDirectory();
    debugPrint("Path=========>$directory");

    PdfPage page = document.pages.add();

    PdfPageTemplateElement header = PdfPageTemplateElement(
        Rect.fromLTWH(0, 0, document.pageSettings.size.width, 100));

    header.graphics.drawRectangle(
      bounds: Rect.fromLTWH(0, 0, header.width, header.height),
      brush: PdfSolidBrush(PdfColor(color.red, color.green,
          color.blue)), // Replace with your desired background color
    );

    PdfCompositeField compositefields = PdfCompositeField(
        font: PdfStandardFont(PdfFontFamily.timesRoman, 28,
            style: PdfFontStyle.bold),
        brush: PdfSolidBrush(PdfColor(255, 255, 255)),
        text: ' ${APIService.appLabel} Mobile Banking',
        fields: <PdfAutomaticField>[]);

    compositefields.draw(header.graphics,
        Offset(0, 50 - PdfStandardFont(PdfFontFamily.timesRoman, 11).height));

    document.template.top = header;

    double hiTextUpperBound = 60;
    double subTitleUpperBound = hiTextUpperBound + 50;
    PdfStringFormat format = PdfStringFormat();
    format.alignment = PdfTextAlignment.center;

    page.graphics.drawString(
        'Hi ${await _profileRepo.getUserInfo(UserAccountData.FirstName)},',
        PdfStandardFont(PdfFontFamily.helvetica, 40, style: PdfFontStyle.bold),
        brush: PdfSolidBrush(PdfColor(color.red, color.green, color.blue)),
        bounds: Rect.fromLTWH(0, hiTextUpperBound, page.size.width - 100, 0),
        format: format);

    page.graphics.drawString('Thank you for using ${APIService.appLabel}',
        PdfStandardFont(PdfFontFamily.helvetica, 18),
        brush: PdfSolidBrush(PdfColor(color.red, color.green, color.blue)),
        bounds: Rect.fromLTWH(
            0, subTitleUpperBound, document.pageSettings.size.width - 100, 0),
        format: format);

    PdfGrid grid = PdfGrid();
    var gridStyle = PdfGridStyle(
      cellPadding: PdfPaddings(left: 20, right: 20, top: 8, bottom: 8),
      backgroundBrush: PdfBrushes.transparent,
      textBrush: PdfBrushes.black,
      font: PdfStandardFont(PdfFontFamily.helvetica, 18),
    );
    grid.style = gridStyle;

    grid.columns.add(count: 2);
    debugPrint("receipt details====>${postDynamic.receiptDetails}");
    postDynamic.receiptDetails?.asMap().forEach((index, item) {
      PdfGridRow row = grid.rows.add();
      String title = MapItem.fromJson(postDynamic.receiptDetails?[index]).title;
      String value = row.cells[1].value =
          MapItem.fromJson(postDynamic.receiptDetails?[index]).value ?? "****";
      if (title == "Reference No") {
        receiptNo = value;
      }
      row.cells[0].value = title;
      row.cells[1].value = value;
    });

    // Set margins for the page
    double leftMargin = 8; // Adjust the left margin value as desired
    double rightMargin = 4; // Adjust the right margin value as desired
    double topMargin = 20 +
        hiTextUpperBound +
        subTitleUpperBound; // Adjust the top margin value as desired
    double bottomMargin = 0; // A

    PdfLayoutResult? layoutResult = grid.draw(
      page: page,
      bounds: Rect.fromLTWH(
        leftMargin,
        topMargin,
        page.getClientSize().width - (leftMargin + rightMargin),
        0,
      ),
    );

    String receiptname = "Receipt$receiptNo";
    String filePath = "${directory?.path}/$receiptname.pdf";

    await saveFile(filePath, document);

    CommonUtils.getxNavigate(
        widget: PDFScreen(
      path: filePath,
      pdfName: receiptname,
      document: document,
      downloadReceipt: downloadReceipt,
    ));
  }

  static saveFile(String path, PdfDocument document) async {
    await File(path).writeAsBytes(await document.save());
  }
}

class MapItem {
  String title;
  String? value;

  MapItem({required this.title, required this.value});

  MapItem.fromJson(Map<String, dynamic> json)
      : title = json["Title"],
        value = json["Value"];
}
