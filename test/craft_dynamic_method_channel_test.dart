import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:craft_dynamic/craft_dynamic_method_channel.dart';

void main() {
  MethodChannelCraftDynamic platform = MethodChannelCraftDynamic();
  const MethodChannel channel = MethodChannel('craft_dynamic');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.getPlatformVersion(), '42');
  });
}
