import 'package:craft_dynamic/craft_dynamic.dart';
import 'package:flutter/material.dart';

import '../../../dynamic_widget.dart';

abstract class IMenuUtil {
  factory IMenuUtil(MenuType menuType, ModuleItem moduleItem) {
    switch (menuType) {
      case MenuType.VerticalPlain:
        return VerticalPlainMenuItem(moduleItem: moduleItem);
      case MenuType.VerticalOutlined:
        return VerticalOutlinedMenuItem(moduleItem: moduleItem);
      case MenuType.HorizontalPlain:
        return HorizontalPlainMenuItem(moduleItem: moduleItem);
      case MenuType.HorizontalOutlined:
        return HorizontalOutlinedMenuItem(moduleItem: moduleItem);
      case MenuType.DefaultMenuItem:
        return DefaultMenuItem(moduleItem: moduleItem);
      default:
        return DefaultMenuItem(moduleItem: moduleItem);
    }
  }

  Widget getMenuItem();
}

class DefaultMenuItem implements IMenuUtil {
  final ModuleItem moduleItem;

  DefaultMenuItem({required this.moduleItem});

  @override
  Widget getMenuItem() => VerticalModule(moduleItem: moduleItem);
}

class VerticalPlainMenuItem implements IMenuUtil {
  final ModuleItem moduleItem;

  VerticalPlainMenuItem({required this.moduleItem});

  @override
  Widget getMenuItem() => VerticalModule(moduleItem: moduleItem);
}

class VerticalOutlinedMenuItem implements IMenuUtil {
  final ModuleItem moduleItem;

  VerticalOutlinedMenuItem({required this.moduleItem});

  @override
  Widget getMenuItem() => VerticalModule(
        moduleItem: moduleItem,
      );
}

class HorizontalPlainMenuItem implements IMenuUtil {
  final ModuleItem moduleItem;

  HorizontalPlainMenuItem({required this.moduleItem});

  @override
  Widget getMenuItem() => HorizontalModule(
        moduleItem: moduleItem,
      );
}

class HorizontalOutlinedMenuItem implements IMenuUtil {
  final ModuleItem moduleItem;

  HorizontalOutlinedMenuItem({required this.moduleItem});
  @override
  Widget getMenuItem() => HorizontalModule(
        moduleItem: moduleItem,
      );
}
