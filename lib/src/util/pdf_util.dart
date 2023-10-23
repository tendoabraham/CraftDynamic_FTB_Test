part of craft_dynamic;

class PDFUtil {
  static downloadReceipt(
      {PostDynamic? postDynamic,
      Map<String, dynamic>? receiptdetails,
      downloadReceipt = true,
      isShare=false}) async {
    String receiptNo = "";
    Color color = APIService.appPrimaryColor;
    final profileRepo = ProfileRepository();
    final PdfDocument document = PdfDocument();
    final directory = await getExternalStorageDirectory();

    AppLogger.appLogD(tag: "pdf", message: "started creating pdf");

    PdfPage page = document.pages.add();

    PdfPageTemplateElement header = PdfPageTemplateElement(
        Rect.fromLTWH(0, 0, document.pageSettings.size.width, 100));

    header.graphics.drawRectangle(
      bounds: Rect.fromLTWH(0, 0, header.width, header.height),
      brush: PdfSolidBrush(PdfColor(color.red, color.green,
          color.blue)), // Replace with your desired background color
    );

    var headerfont =
        PdfStandardFont(PdfFontFamily.timesRoman, 28, style: PdfFontStyle.bold);

    header.graphics.drawString(
      APIService.appLabel,
      headerfont,
      brush: PdfSolidBrush(PdfColor(255, 255, 255)),
      bounds: Rect.fromLTWH(
          (header.width - headerfont.measureString(APIService.appLabel).width) /
              2,
          (header.height / 2) - 20,
          0,
          header.height),
    );

    document.template.top = header;

    double hiTextUpperBound = 60;
    double subTitleUpperBound = hiTextUpperBound + 50;
    PdfStringFormat format = PdfStringFormat();
    format.alignment = PdfTextAlignment.center;

    page.graphics.drawString(
        'Hi ${await profileRepo.getUserInfo(UserAccountData.FirstName)},',
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

    (postDynamic?.receiptDetails?.isEmpty ?? true)
        ? receiptdetails?.entries.forEach((item) {
            PdfGridRow row = grid.rows.add();
            String title = item.key;
            String value = row.cells[1].value = item.value ?? "****";
            if (title == "Reference No") {
              receiptNo = value;
            }
            row.cells[0].value = title;
            row.cells[1].value = value;
          })
        : postDynamic?.receiptDetails?.asMap().forEach((index, item) {
            PdfGridRow row = grid.rows.add();
            String title =
                MapItem.fromJson(postDynamic.receiptDetails?[index]).title;
            String value = row.cells[1].value =
                MapItem.fromJson(postDynamic.receiptDetails?[index]).value ??
                    "****";
            if (title == "Reference No") {
              receiptNo = value;
            }
            row.cells[0].value = title;
            row.cells[1].value = value;
          });

    //Watermark image
    ByteData imageBytes = await rootBundle.load('assets/launcher/launcher.png');
    List<int> imageBitmap = imageBytes.buffer.asUint8List();

    PdfGraphicsState state = page.graphics.save();
    page.graphics.setTransparency(0.25);
    page.graphics.drawImage(
        PdfBitmap.fromBase64String(base64.encode(imageBitmap)),
        Rect.fromLTWH((page.graphics.clientSize.width / 2) - 150,
            (page.graphics.clientSize.height / 2) - 150, 300, 300));
    page.graphics.restore(state);

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

    AppLogger.appLogD(tag: "pdf", message: "saving pdf $filePath");

    await saveFile(filePath, document);

    CommonUtils.getxNavigate(
        widget: PDFScreen(
      path: filePath,
      pdfName: receiptname,
      document: document,
      downloadReceipt: downloadReceipt,
      isShare: isShare,
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
