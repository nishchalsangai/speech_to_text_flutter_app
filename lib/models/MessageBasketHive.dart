import 'package:hive/hive.dart';

part 'MessageBasketHive.g.dart';

@HiveType(typeId: 0)
class MessageBasketHive extends HiveObject {
  @HiveField(0)
  late bool? sentByUser;
  @HiveField(1)
  late String message;
}
