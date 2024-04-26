// ignore_for_file: must_be_immutable

import 'package:craft_dynamic/src/ui/dynamic_static/list_data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:craft_dynamic/craft_dynamic.dart';
import 'package:craft_dynamic/src/util/widget_util.dart';

class TabWidget extends StatefulWidget {
  List<FormItem> formItems;
  String title;
  ModuleItem moduleItem;
  Function? updateState;

  TabWidget(
      {super.key,
        required this.title,
        required this.formItems,
        required this.moduleItem,
        this.updateState});

  @override
  State<TabWidget> createState() => _TabWidgetState();
}

class _TabWidgetState extends State<TabWidget> {
  FormItem? recentList;
  List<FormItem> horizontalScroll = [];
  List<Tab> tabs = [];
  List<FormItem> tabForms = [];
  List<TabWidgetList> tabWidgetList = [];
  List<String> linkControls = [];

  @override
  void initState() {
    super.initState();
    tabWidgetList.clear();
    logForms();
    addTabWidgetList();
  }

  List<FormItem> getContainers(List<FormItem> forms) {
    List<FormItem> containers = forms
        .where((element) => element.controlType == ViewType.CONTAINER.name)
        .toList();
    return containers;
  }

  List<FormItem> getContainerForms(List<FormItem> forms, FormItem container) {
    return forms
        .where((element) =>
    element.containerID == container.controlId ||
        element.linkedToControl == container.controlId)
        .toList();
  }

  List<FormItem> getRButtonForms(List<FormItem> forms, FormItem rButton) {
    return forms
        .where((element) => element.linkedToControl == rButton.controlId)
        .toList();
  }

  logForms() {
    List<FormItem> containers = getContainers(widget.formItems);
    for (int i = 0; i < containers.length; i++) {
      List<FormItem> temp = getContainerForms(widget.formItems, containers[i]);
      for (var element in temp) {
        if (element.controlType == ViewType.RBUTTON.name ||
            element.controlType == ViewType.TAB.name) {
          linkControls.add(element.controlId!);
          tabs.add(Tab(
            text: element.controlText!.capitalize(),
          ));
        }
      }
      if (containers[i].controlType == ViewType.CONTAINER.name &&
          containers[i].controlFormat == ControlFormat.HorizontalScroll.name) {
        horizontalScroll.addAll(widget.formItems.where((item) =>
        item.containerID == containers[i].controlId ||
            item.linkedToControl == containers[i].controlId));
      }
    }
  }

  bool checkGlobalControlType(
      List<String> linkControls, String linkControl, FormItem formItem) {
    bool isGlobal = true;
    for (var element in linkControls) {
      if (element == formItem.linkedToControl) {
        isGlobal = false;
      }
    }
    return isGlobal;
  }

  List<FormItem> getTabForms(List<FormItem> formItems, String linkControl) {
    List<FormItem> items = formItems
        .where((element) =>
    element.linkedToControl == linkControl ||
        element.linkedToControl == "" ||
        element.linkedToControl == null)
        .toList();

    try {
      recentList = items.firstWhere(
            (item) => item.controlType == ViewType.LIST.name,
      );
    } catch (e) {
      AppLogger.appLogE(tag: "tab forms error", message: e.toString());
    }
    items.removeWhere((element) => element.controlType == ViewType.LIST.name);
    return items;
  }

  addTabWidgetList() {
    tabForms.clear();
    linkControls.asMap().forEach((index, linkControl) {
      tabForms = getTabForms(widget.formItems, linkControl).toList();
      tabWidgetList.add(TabWidgetList(
        moduleItem: widget.moduleItem,
        formItems: tabForms,
        updateState: widget.updateState,
        horizontalScroll: horizontalScroll,
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          Provider.of<PluginState>(context, listen: false)
              .setRequestState(false);
          return true;
        },
        child: DefaultTabController(
            length: tabs.length,
            child: Builder(builder: (BuildContext context) {
              final TabController tabController =
              DefaultTabController.of(context);
              tabController.addListener(() {
                if (!tabController.indexIsChanging) {
                  Provider.of<PluginState>(context, listen: false)
                      .setRequestState(false,
                      currentTab: linkControls[tabController.index]);
                }
              });
              return Scaffold(
                  body:Column(
                    mainAxisSize: MainAxisSize.max,
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
                      Container(
                          width: double.infinity,
                          color: const Color.fromARGB(255, 0, 80, 170), // Add a background color for debugging
                          child: Center(
                            child: TabBar(
                              tabs: tabs,
                              isScrollable: true,
                            ),
                          )
                      ),
                      Expanded(child: Container(
                        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 2),
                        height: double.maxFinite,
                        color: const Color.fromARGB(255, 219, 220, 221),
                        child: TabBarView(children: tabWidgetList),))
                    ],
                  )
              );
            })));
  }

  @override
  void dispose() {
    super.dispose();
  }
}

class TabWidgetList extends StatefulWidget {
  final List<FormItem> formItems;
  List<FormItem>? horizontalScroll;
  Function? updateState;
  ModuleItem moduleItem;

  TabWidgetList(
      {super.key,
        required this.formItems,
        required this.moduleItem,
        this.updateState,
        this.horizontalScroll});

  @override
  State<TabWidgetList> createState() => _TabWidgetListState();
}

class _TabWidgetListState extends State<TabWidgetList> {
  final _formKey = GlobalKey<FormState>();
  List<FormItem> sortedForms = [];

  @override
  void initState() {
    super.initState();
    sortedForms = WidgetUtil.sortForms(widget.formItems);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: double.infinity,
        child: SingleChildScrollView(
            child: Column(mainAxisSize: MainAxisSize.max, children: [
              const SizedBox(
                height: 12,
              ),
              Form(
                  key: _formKey,
                  child: ListView.builder(
                      shrinkWrap: true,
                      padding: const EdgeInsets.only(left: 18, right: 18, top: 8),
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: sortedForms.length,
                      itemBuilder: (context, index) {
                        return BaseFormComponent(
                            formItem: sortedForms[index],
                            moduleItem: widget.moduleItem,
                            formKey: _formKey,
                            formItems: sortedForms,
                            child: IFormWidget(
                              sortedForms[index],
                            ).render());
                      }))
            ])));
  }

  bool get wantKeepAlive => true;
}
