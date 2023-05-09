// ignore_for_file: must_be_immutable
import 'package:craft_dynamic/src/state/plugin_state.dart';
import 'package:flutter/material.dart';

import 'package:craft_dynamic/craft_dynamic.dart';
import 'package:craft_dynamic/dynamic_widget.dart';
import 'package:provider/provider.dart';

class ModulesListWidget extends StatefulWidget {
  final Orientation orientation;
  final ModuleItem? moduleItem;
  FrequentAccessedModule? favouriteModule;

  ModulesListWidget({
    super.key,
    required this.orientation,
    required this.moduleItem,
    this.favouriteModule,
  });

  @override
  State<ModulesListWidget> createState() => _ModulesListWidgetState();
}

class _ModulesListWidgetState extends State<ModulesListWidget> {
  final _moduleRepository = ModuleRepository();

  getModules() =>
      _moduleRepository.getModulesById(widget.favouriteModule == null
          ? widget.moduleItem!.moduleId
          : widget.favouriteModule!.moduleID);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          Provider.of<PluginState>(context, listen: false)
              .setRequestState(false);
          return true;
        },
        child: Scaffold(
            appBar: AppBar(
                elevation: 2,
                title: Text(widget.favouriteModule == null
                    ? widget.moduleItem!.moduleName
                    : widget.favouriteModule!.moduleName)),
            body: FutureBuilder<List<ModuleItem>>(
                future: getModules(),
                builder: (BuildContext context,
                    AsyncSnapshot<List<ModuleItem>> snapshot) {
                  Widget child = const Center(child: Text("Please wait..."));
                  if (snapshot.hasData) {
                    var modules = snapshot.data?.toList();
                    debugPrint("Modules....$modules");
                    modules?.removeWhere((module) => module.isHidden == true);

                    if (modules != null) {
                      child = SizedBox(
                          height: double.infinity,
                          child: GridView.builder(
                              // physics: const NeverScrollableScrollPhysics(),
                              padding: const EdgeInsets.only(
                                  left: 12, right: 12, top: 8, bottom: 8),
                              shrinkWrap: true,
                              itemCount: modules.length,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3,
                                      crossAxisSpacing: 8,
                                      mainAxisSpacing: 12),
                              itemBuilder: (BuildContext context, int index) {
                                var module = modules[index];
                                return ModuleItemWidget(moduleItem: module);
                              }));
                    }
                  }
                  return child;
                })));
  }

  @override
  void dispose() {
    super.dispose();
  }
}
