// ignore_for_file: must_be_immutable

import 'package:cached_network_image/cached_network_image.dart';
import 'package:craft_dynamic/src/util/widget_util.dart';
import 'package:flutter/material.dart';
import 'package:craft_dynamic/craft_dynamic.dart';
import 'package:pinput/pinput.dart';

const primaryColor = Color(0xff0D4C92);

class ListWidget extends StatelessWidget {
  ListWidget(
      {Key? key,
      required this.scrollable,
      this.dynamicList = const [],
      this.summary = const [],
      this.controlID,
      this.serviceParamID,
      this.moduleItem})
      : super(key: key);

  final bool scrollable;
  String? controlID, serviceParamID;
  ModuleItem? moduleItem;
  List<dynamic>? dynamicList, summary;

  List<Map> mapItems = [];
  List<Map> summaryItems = [];

  @override
  Widget build(BuildContext context) {
    // return Text(jsonTxt!.toString());
    mapItems.clear();
    summaryItems.clear();

    if (dynamicList != null) {
      for (var item in dynamicList ?? []) {
        mapItems.add(item);
      }
    }

    if (summary != null) {
      for (var item in summary ?? []) {
        summaryItems.add(item);
      }
    }

    AppLogger.appLogD(tag: "summary list", message: summaryItems);

    bool checkDate(String date) {
      // final RegExp regex = RegExp(r'^\d{4}-\d{2}-\d{2}\s\d{2}:\d{2}$');
      final RegExp regex = RegExp(r'^\d{4}-\d{2}-\d{2}\s\d{2}:\d{2}:\d{2}$');
      if (regex.hasMatch(date)) {
        return true;
      } else {
        return false;
      }
    }

    return dynamicList != null && dynamicList!.isNotEmpty
        ? Column(children: [
            summaryItems.isNotEmpty
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Summary",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: summaryItems.length,
                          itemBuilder: (context, index) {
                            var mapItem = summaryItems[index];
                            mapItem.removeWhere(
                                (key, value) => key == null || value == null);
                            return Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 0, vertical: 0.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 4.0, vertical: 0.0),
                                      child: Column(
                                        children: mapItem
                                            .map((key, value) => MapEntry(
                                                key,
                                                Container(
                                                    padding: const EdgeInsets
                                                        .symmetric(vertical: 2),
                                                    child: Column(
                                                      children: [
                                                        Row(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Text(
                                                              "$key:",
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Theme.of(
                                                                          context)
                                                                      .primaryColor),
                                                            ),
                                                            Flexible(
                                                                child: Text(
                                                              value.toString(),
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal,
                                                                  color: WidgetUtil
                                                                      .getTextColor(
                                                                          value
                                                                              .toString(),
                                                                          key.toString())),
                                                              textAlign:
                                                                  TextAlign
                                                                      .right,
                                                            )),
                                                          ],
                                                        ),
                                                        const Divider(
                                                          color: Colors.grey,
                                                        )
                                                      ],
                                                    ))))
                                            .values
                                            .toList(),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 12,
                                    )
                                  ],
                                ));
                          },
                        ),
                        Divider(
                          height: 1,
                          color: Theme.of(context).primaryColor.withOpacity(.6),
                        )
                      ],
                    ))
                : const SizedBox(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    mapItems.length == 1
                        ? Text(
                            "${mapItems.length} transaction found",
                            style: TextStyle(
                                fontFamily: "Myriad Pro", color: primaryColor),
                          )
                        : Text(
                            "${mapItems.length} transactions found",
                            style: TextStyle(
                              color: primaryColor,
                              fontFamily: "Myriad Pro",
                            ),
                          ),
                    CachedNetworkImage(
                      imageUrl: moduleItem?.moduleUrl ?? "",
                      errorWidget: (context, url, error) => const SizedBox(),
                      height: 64,
                      width: 64,
                      fit: BoxFit.contain,
                    )
                  ]),
            ),
            // const SizedBox(
            //   height: 4,
            // ),
            Expanded(
                child: ListView.builder(
              shrinkWrap: true,
              itemCount: mapItems.length,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemBuilder: (context, index) {
                var mapItem = mapItems[index];
                var status = mapItem["Status"]?.toLowerCase();
                Color color = getItemColor(context, status);

                mapItem
                    .removeWhere((key, value) => key == null || value == null);
                return Card(
                    margin: EdgeInsets.zero,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
                      //set border radius more than 50% of height and width to make circle
                    ),
                    surfaceTintColor: Colors.white,
                    elevation: 3,
                    child: InkWell(
                        borderRadius: BorderRadius.zero,
                        onTap: () {
                          PDFUtil.downloadReceipt(
                              receiptdetails: mapItem as Map<String, dynamic>);
                        },
                        child: IntrinsicHeight(
                            child: Row(
                          children: [
                            Container(
                              width: 12,
                              decoration: BoxDecoration(
                                  color: color,
                                  borderRadius: const BorderRadius.only(
                                      topLeft: Radius.zero,
                                      bottomLeft: Radius.zero)),
                            ),
                            Expanded(
                                child: Column(children: [
                              Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 4.0),
                                child: Column(
                                  children: mapItem
                                      .map((key, value) => MapEntry(
                                          key,
                                          Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 4,
                                                      horizontal: 4),
                                              child: Column(
                                                children: [
                                                  Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        "$key:",
                                                        style: TextStyle(
                                                            fontFamily:
                                                                "Myriad Pro",
                                                            fontSize: 14,
                                                            color: Theme.of(
                                                                    context)
                                                                .primaryColor),
                                                      ),
                                                      Flexible(
                                                          child: Text(
                                                        value.toString(),
                                                        style: TextStyle(
                                                            fontFamily:
                                                                "Myriad Pro",
                                                            fontWeight:
                                                                checkDate(value
                                                                        .toString())
                                                                    ? FontWeight
                                                                        .normal
                                                                    : FontWeight
                                                                        .bold,
                                                            fontSize: checkDate(
                                                                    value
                                                                        .toString())
                                                                ? 12
                                                                : 14,
                                                            color:
                                                                primaryColor),
                                                        textAlign:
                                                            TextAlign.right,
                                                      ))
                                                    ],
                                                  ),
                                                ],
                                              ))))
                                      .values
                                      .toList(),
                                ),
                              ),
                            ])),
                          ],
                        ))));
              },
            ))
          ])
        : Center(
            child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "packages/craft_dynamic/assets/images/empty.png",
                height: 64,
                width: 64,
                fit: BoxFit.cover,
              ),
              const SizedBox(
                height: 14,
              ),
              Text(
                "Nothing found!",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: APIService.appPrimaryColor),
              )
            ],
          ));
  }

  Color getItemColor(BuildContext context, String? status) {
    if (status == "success") {
      return Colors.green;
    }
    if (status == "fail") {
      return Colors.red;
    }
    if (status == "pending" || status == "processing") {
      return Colors.blue;
    }
    return Colors.white;
  }

  Color getTextColor(BuildContext context, String? status) {
    if (status == "success") {
      return Colors.green;
    }
    if (status == "fail") {
      return Colors.red;
    }
    if (status == "pending" || status == "processing") {
      return Colors.blue;
    }
    return Colors.black;
  }
}
