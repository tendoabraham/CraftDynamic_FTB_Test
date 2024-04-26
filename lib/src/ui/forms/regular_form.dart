// ignore_for_file: must_be_immutable

import 'package:craft_dynamic/src/ui/dynamic_static/list_data.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

import 'package:craft_dynamic/craft_dynamic.dart';
import 'package:provider/provider.dart';

class RegularFormWidget extends StatefulWidget {
  final ModuleItem moduleItem;
  final List<FormItem> sortedForms;
  final List<dynamic>? jsonDisplay, formFields;
  final bool hasRecentList;

  const RegularFormWidget(
      {super.key,
        required this.moduleItem,
        required this.sortedForms,
        required this.jsonDisplay,
        required this.formFields,
        this.hasRecentList = false});

  @override
  State<RegularFormWidget> createState() => _RegularFormWidgetState();
}

class _RegularFormWidgetState extends State<RegularFormWidget> {
  final _formKey = GlobalKey<FormState>();
  final ScrollController _scrollController = ScrollController();
  List<FormItem> formItems = [];
  FormItem? recentList;

  @override
  initState() {
    recentList = widget.sortedForms.toList().firstWhereOrNull(
            (formItem) => formItem.controlType == ViewType.LIST.name);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    formItems = widget.sortedForms.toList()
      ..removeWhere((element) => element.controlType == ViewType.LIST.name);

    return WillPopScope(
        onWillPop: () async {
          if (Provider.of<PluginState>(context, listen: false)
              .loadingNetworkData) {
            CommonUtils.showToast("Please wait...");
            return false;
          }
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Provider.of<PluginState>(context, listen: false)
                .clearDynamicDropDown();
          });
          Provider.of<PluginState>(context, listen: false)
              .setRequestState(false);
          return true;
        },
        child: Scaffold(
            body: Column(
              children: [
                const SizedBox(
                  height: 35,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
                  child: Card(
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                        //set border radius more than 50% of height and width to make circle
                      ),
                      color: const Color.fromARGB(255, 0, 80, 170),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 15),
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: const Image(
                                image: AssetImage("assets/images/back_arrow.png"),
                                width: 25,
                              ),
                            ),
                            Expanded(
                                child: Text(
                                  widget.moduleItem?.moduleName ?? "",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontFamily: "Myriad Pro",
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                )),
                            Container(width: 25),
                          ],
                        ),
                      )),
                ),
                Expanded(
                    child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 5),
                        color: const Color.fromARGB(255, 219, 220, 221),
                        child:     SizedBox(
                            height: double.infinity,
                            child: Scrollbar(
                                thickness: 6,
                                controller: _scrollController,
                                child: SingleChildScrollView(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        const SizedBox(
                                          height: 12,
                                        ),
                                        Form(
                                            key: _formKey,
                                            child: ListView.builder(
                                                padding: const EdgeInsets.only(
                                                    left: 18, right: 18, top: 8),
                                                shrinkWrap: true,
                                                physics: const NeverScrollableScrollPhysics(),
                                                itemCount: formItems.length,
                                                itemBuilder: (context, index) {
                                                  return BaseFormComponent(
                                                      formItem: formItems[index],
                                                      moduleItem: widget.moduleItem,
                                                      formItems: formItems,
                                                      formKey: _formKey,
                                                      child: IFormWidget(formItems[index],
                                                          jsonText: widget.jsonDisplay,
                                                          formFields: widget.formFields)
                                                          .render());
                                                }))
                                      ],
                                    ))))
                    )
                )
              ],
            )
        ));
  }
}
