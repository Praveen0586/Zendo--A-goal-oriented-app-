import 'package:hive_flutter/hive_flutter.dart';
part 'obj_hive.g.dart';

@HiveType(typeId: 0)
class HiveObj extends HiveObject {
  @HiveField(0)
  int id;
  @HiveField(1)
  String message;
  @HiveField(2)
  bool isEnabled;
  HiveObj({required this.id, required this.message, required this.isEnabled});
}
