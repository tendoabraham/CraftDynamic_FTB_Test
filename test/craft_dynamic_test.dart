import 'package:flutter_test/flutter_test.dart';
import 'package:craft_dynamic/craft_dynamic.dart';
import 'package:craft_dynamic/craft_dynamic_platform_interface.dart';
import 'package:craft_dynamic/craft_dynamic_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockCraftDynamicPlatform
    with MockPlatformInterfaceMixin
    implements CraftDynamicPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final CraftDynamicPlatform initialPlatform = CraftDynamicPlatform.instance;

  test('$MethodChannelCraftDynamic is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelCraftDynamic>());
  });

  test('getPlatformVersion', () async {
    CraftDynamic craftDynamicPlugin = CraftDynamic();
    MockCraftDynamicPlatform fakePlatform = MockCraftDynamicPlatform();
    CraftDynamicPlatform.instance = fakePlatform;

    expect(await craftDynamicPlugin.getPlatformVersion(), '42');
  });
}
