import 'dart:ui';

import 'package:hive/hive.dart';
import 'package:hive_learn/constants.dart';
import "package:hive_learn/hiv_/models.dart";
import 'package:hive_learn/hiv_/obj_hive.dart';

late Box hiveBox;
late Box themeBox;
Future<List<Todo>> loadHiveData() async {
  List<Todo> todos = [];
  final my = hiveBox.values.toList();
  todos =
      my
          .map(
            (e) => Todo(id: e.id, message: e.message, isEnabled: e.isEnabled),
          )
          .toList();
  return todos;
}

void updateBoolean(int ind) async {
  final value = hiveBox.getAt(ind);
  await hiveBox.putAt(
    ind,
    HiveObj(id: value.id, message: value.message, isEnabled: !value.isEnabled),
  );
}

void updateBrightness(bool value) {
  isDarkModeNotifier.value = value;
  themeBox.put("theme", value);
}

// HiveObj converttoHive(Todo todo) {
//   final hiveobj = HiveObj(id: todo.id, message: todo.message);
//   return hiveobj;
// }
