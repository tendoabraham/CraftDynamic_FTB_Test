import 'package:hive/hive.dart';

class HiveBox<T> {
  static final Map<Type, HiveBox<dynamic>> _instances = {};

  factory HiveBox(Type type) {
    if (_instances.containsKey(type)) {
      return _instances[type] as HiveBox<T>;
    } else {
      final instance = HiveBox<T>._internal();
      _instances[type] = instance;
      return instance;
    }
  }

  HiveBox._internal();

  Box<T>? _box;

  Future<Box<T>?> getBox(String name) async {
    _box ??= await Hive.openBox<T>(name);
    return _box;
  }
}
