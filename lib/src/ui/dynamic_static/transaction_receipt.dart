// ignore_for_file: must_be_immutable

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import 'package:craft_dynamic/craft_dynamic.dart';
import 'package:craft_dynamic/dynamic_widget.dart';
import 'package:craft_dynamic/src/util/clipper_util.dart';
import 'package:vibration/vibration.dart';

class TransactionReceipt extends StatefulWidget {
  final PostDynamic postDynamic;
  String? moduleName;

  TransactionReceipt({required this.postDynamic, this.moduleName, super.key});

  @override
  State<StatefulWidget> createState() => _TransactionReceiptState();
}

class _TransactionReceiptState extends State<TransactionReceipt>
    with SingleTickerProviderStateMixin {
  late var _controller;

  @override
  void initState() {
    super.initState();
    Vibration.vibrate();
    _controller = AnimationController(vsync: this);
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Future.delayed(const Duration(milliseconds: 1000), () {
          if (!mounted) {
            if (!_controller.isCompleted) {
              _controller.forward(from: 0.0);
            }
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var postDynamic = widget.postDynamic;

    return WillPopScope(
        onWillPop: () async {
          Navigator.of(context).pop();
          Navigator.of(context).pop();
          return true;
        },
        child: Scaffold(
          body: Center(
              child: SingleChildScrollView(
                  child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      child: ClipPath(
                          clipper: PointsClipper(),
                          child: Container(
                              decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(12.0),
                                      topRight: Radius.circular(12.0))),
                              padding: const EdgeInsets.only(
                                  bottom: 74, left: 12, right: 12),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Lottie.asset(
                                        "packages/craft_dynamic/assets/lottie/success.json",
                                        height: 122,
                                        width: 122,
                                        controller: _controller,
                                        onLoaded: (comp) {
                                      _controller
                                        ..duration = comp.duration
                                        ..forward();
                                    }),
                                    Row(
                                      children: [
                                        Expanded(
                                            child: Divider(
                                          color: Colors.grey[300],
                                        )),
                                        const Text(
                                          "Success",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ).tr(),
                                        Expanded(
                                          child: Divider(
                                            color: Colors.grey[300],
                                          ),
                                        )
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 22,
                                    ),
                                    Text(
                                      widget.moduleName ?? "",
                                      style: const TextStyle(fontSize: 24),
                                    ),
                                    const SizedBox(
                                      height: 24,
                                    ),
                                    ListView.builder(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 14),
                                        shrinkWrap: true,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        itemCount:
                                            postDynamic.receiptDetails?.length,
                                        itemBuilder: (context, index) {
                                          String title = MapItem.fromJson(
                                                  postDynamic
                                                      .receiptDetails?[index])
                                              .title;
                                          String? value = MapItem.fromJson(
                                                      postDynamic
                                                              .receiptDetails?[
                                                          index])
                                                  .value ??
                                              "****";
                                          return Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 8),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(title),
                                                  Text(
                                                    value.isEmpty
                                                        ? "****"
                                                        : value,
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  )
                                                ],
                                              ));
                                        }),
                                    const SizedBox(
                                      height: 44,
                                    ),
                                    WidgetFactory.buildButton(context, () {
                                      Navigator.of(context).pop();
                                      Navigator.of(context).pop();
                                    }, "Done"),
                                  ])))))),
          backgroundColor: APIService.appPrimaryColor,
        ));
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
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
