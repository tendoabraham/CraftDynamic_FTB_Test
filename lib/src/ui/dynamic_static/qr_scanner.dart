import 'dart:io';

import 'package:craft_dynamic/craft_dynamic.dart';
import 'package:craft_dynamic/src/state/plugin_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';
import 'package:vibration/vibration.dart';

import '../../network/dynamic_postcall.dart';
import '../../network/dynamic_request.dart';

class QRScanner extends StatefulWidget {
  final ModuleItem moduleItem;
  final FormItem formItem;

  const QRScanner(
      {super.key, required this.moduleItem, required this.formItem});

  @override
  State<StatefulWidget> createState() => _QRScannerState();
}

class _QRScannerState extends State<QRScanner> {
  final cameraController = MobileScannerController();
  final _dynamicRequest = DynamicFormRequest();
  Set<Map<String, dynamic>> input = {};
  MobileScannerArguments? arguments;
  Barcode? barcode;
  BarcodeCapture? capture;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (Provider.of<PluginState>(context, listen: false).deleteFormInput) {
      WidgetsBinding.instance.addPostFrameCallback((_) {});
    }

    final scanWindow = Rect.fromCenter(
      center: MediaQuery.of(context).size.center(Offset.zero),
      width: 200,
      height: 200,
    );

    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Text(widget.moduleItem.moduleName),
          actions: [
            IconButton(
              color: Colors.white,
              icon: ValueListenableBuilder(
                valueListenable: cameraController.torchState,
                builder: (context, state, child) {
                  switch (state as TorchState) {
                    case TorchState.off:
                      return const Icon(Icons.flash_off, color: Colors.grey);
                    case TorchState.on:
                      return const Icon(Icons.flash_on, color: Colors.yellow);
                  }
                },
              ),
              iconSize: 32.0,
              onPressed: () => cameraController.toggleTorch(),
            ),
            IconButton(
              color: Colors.white,
              icon: ValueListenableBuilder(
                valueListenable: cameraController.cameraFacingState,
                builder: (context, state, child) {
                  switch (state as CameraFacing) {
                    case CameraFacing.front:
                      return const Icon(Icons.camera_front);
                    case CameraFacing.back:
                      return const Icon(Icons.camera_rear);
                  }
                },
              ),
              iconSize: 32.0,
              onPressed: () => cameraController.switchCamera(),
            ),
          ],
        ),
        body: Stack(
          children: [
            MobileScanner(
                controller: cameraController,
                scanWindow: scanWindow,
                onDetect: (capture) {
                  final Barcode barcode = capture.barcodes.first;
                  final Uint8List? image = capture.image;
                  input.add({"ACCOUNTID": barcode.rawValue});

                  if (barcode.rawValue != null && barcode.rawValue != "") {
                    AppLogger.appLogD(
                        tag: "qr code",
                        message: "scanning qr ----> ${barcode.rawValue}");
                    CommonUtils.showToast("Successfully scanned QR");
                    cameraController.stop();
                    Navigator.of(context).pop();
                    _dynamicRequest
                        .dynamicRequest(widget.moduleItem,
                            formItem: widget.formItem,
                            dataObj: input,
                            context: context,
                            tappedButton: true)
                        .then((value) => DynamicPostCall.processDynamicResponse(
                            value!.dynamicData!,
                            context,
                            widget.formItem.controlId!,
                            moduleItem: widget.moduleItem));
                    Vibration.vibrate();
                  }
                }),
            if (barcode != null &&
                barcode?.corners != null &&
                arguments != null)
              CustomPaint(
                painter: BarcodeOverlay(
                  barcode: barcode!,
                  arguments: arguments!,
                  boxFit: BoxFit.contain,
                  capture: capture!,
                ),
              ),
            CustomPaint(
              painter: ScannerOverlay(scanWindow),
            ),
          ],
        ));
  }
}

class ScannerOverlay extends CustomPainter {
  ScannerOverlay(this.scanWindow);

  final Rect scanWindow;

  @override
  void paint(Canvas canvas, Size size) {
    final backgroundPath = Path()..addRect(Rect.largest);
    final cutoutPath = Path()..addRect(scanWindow);

    final backgroundPaint = Paint()
      ..color = Colors.black.withOpacity(0.5)
      ..style = PaintingStyle.fill
      ..blendMode = BlendMode.dstOut;

    final backgroundWithCutout = Path.combine(
      PathOperation.difference,
      backgroundPath,
      cutoutPath,
    );
    canvas.drawPath(backgroundWithCutout, backgroundPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class BarcodeOverlay extends CustomPainter {
  BarcodeOverlay({
    required this.barcode,
    required this.arguments,
    required this.boxFit,
    required this.capture,
  });

  final BarcodeCapture capture;
  final Barcode barcode;
  final MobileScannerArguments arguments;
  final BoxFit boxFit;

  @override
  void paint(Canvas canvas, Size size) {
    if (barcode.corners == null) return;
    final adjustedSize = applyBoxFit(boxFit, arguments.size, size);

    double verticalPadding = size.height - adjustedSize.destination.height;
    double horizontalPadding = size.width - adjustedSize.destination.width;
    if (verticalPadding > 0) {
      verticalPadding = verticalPadding / 2;
    } else {
      verticalPadding = 0;
    }

    if (horizontalPadding > 0) {
      horizontalPadding = horizontalPadding / 2;
    } else {
      horizontalPadding = 0;
    }

    final ratioWidth =
        (Platform.isIOS ? capture.width! : arguments.size.width) /
            adjustedSize.destination.width;
    final ratioHeight =
        (Platform.isIOS ? capture.height! : arguments.size.height) /
            adjustedSize.destination.height;

    final List<Offset> adjustedOffset = [];
    for (final offset in barcode.corners!) {
      adjustedOffset.add(
        Offset(
          offset.dx / ratioWidth + horizontalPadding,
          offset.dy / ratioHeight + verticalPadding,
        ),
      );
    }
    final cutoutPath = Path()..addPolygon(adjustedOffset, true);

    final backgroundPaint = Paint()
      ..color = Colors.red.withOpacity(0.3)
      ..style = PaintingStyle.fill
      ..blendMode = BlendMode.dstOut;

    canvas.drawPath(cutoutPath, backgroundPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
