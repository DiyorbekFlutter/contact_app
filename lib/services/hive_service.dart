import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

sealed class HiveService {
  static Box box = Hive.box('data');
  static bool get registered => box.get(HiveStorageKey.registered) ?? false;


  static final Box _box = Hive.box('data');
  static storage(HiveStorageKey key, Object? object) => _box.put(key.name, object);
  static get(HiveStorageKey key) => _box.get(key.name);
  static delete(HiveStorageKey key) => _box.delete(key.name);
}

enum HiveStorageKey {
  registered
}
