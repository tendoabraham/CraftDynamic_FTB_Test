// ignore_for_file: must_be_immutable
import 'package:craft_dynamic/src/state/plugin_state.dart';
import 'package:flutter/material.dart';

import 'package:craft_dynamic/craft_dynamic.dart';
import 'package:craft_dynamic/dynamic_widget.dart';
import 'package:provider/provider.dart';

class ModulesListWidget extends StatefulWidget {
  Orientation orientation;
  ModuleItem? moduleItem;
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
  final _disabledModulesRepo = ModuleToDisableRepository();

  Future<List<ModuleItem>?> getModules() async {
    var disabledModules = await _disabledModulesRepo.getAllModulesToDisable();

    List<ModuleItem>? modules = await _moduleRepository.getModulesById(
        widget.favouriteModule == null
            ? widget.moduleItem!.moduleId
            : widget.favouriteModule!.moduleID);
    disabledModules?.forEach((module) {
      modules?.removeWhere((item) => item.moduleId == module.moduleID);
    });
    return modules;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DynamicState>(builder: (context, state, child) {
      MenuScreenProperties? menuScreenProperties = state.menuScreenProperties;
      var crossAxisSpacing = menuScreenProperties?.crossAxisSpacing ?? 8;
      double horizontalPadding = 12;

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
              body: FutureBuilder<List<ModuleItem>?>(
                  future: getModules(),
                  builder: (BuildContext context,
                      AsyncSnapshot<List<ModuleItem>?> snapshot) {
                    Widget child = const Center(child: Text("Please wait..."));
                    if (snapshot.hasData) {
                      var modules = snapshot.data?.toList();
                      modules?.removeWhere((module) => module.isHidden == true);

                      if (modules != null) {
                        child = SizedBox(
                            height: double.infinity,
                            child: GridView.builder(
                                // physics: const NeverScrollableScrollPhysics(),
                                padding: EdgeInsets.only(
                                    left: horizontalPadding,
                                    right: horizontalPadding,
                                    top: 8,
                                    bottom: 8),
                                shrinkWrap: true,
                                itemCount: modules.length,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: menuScreenProperties
                                                ?.gridcount ??
                                            3,
                                        crossAxisSpacing: crossAxisSpacing,
                                        mainAxisSpacing: menuScreenProperties
                                                ?.mainAxisSpacing ??
                                            12,
                                        childAspectRatio: menuScreenProperties
                                                ?.childAspectRatio ??
                                            1),
                                itemBuilder: (BuildContext context, int index) {
                                  var module = modules[index];
                                  return ModuleItemWidget(moduleItem: module);
                                }));
                      }
                    }
                    return child;
                  })));
    });
  }

  @override
  void dispose() {
    super.dispose();
  }
}
