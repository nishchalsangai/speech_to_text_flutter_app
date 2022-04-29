import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';

import '../models/MessageBasketHive.dart';

class DashboardService {
  late String _topic;
  final _controller = StreamController<String>();

  DashboardService({required String topic}) {
    _topic = topic;
  }

  addToDashBoard(String value, bool isRestarted, bool firstTime) async {
    final allChatVault = await Hive.openBox(_topic);
    allChatVault.put("${value}_1", value).then((val) {
      isRestarted
          ? null
          : firstTime
              ? addLastlyAddedChat(value)
              : addLastlyAddedChat(value);
    });
  }

  addLastlyAddedChat(String value) async {
    final allChatVault = await Hive.openBox(_topic);
    var str = allChatVault.get("${value}_1");
    _controller.sink.add(str);
  }

  getAllChatsOnDashboard() async {
    final allChatVault = await Hive.openBox(_topic);
    for (final ele in allChatVault.values) {
      _controller.sink.add(ele);
    }
  }

  Future<bool>? checkIfBoxExist(String topic) async {
    var a = await Hive.boxExists("${topic}_chat");
    return a;
  }

  clearHiveBox(String topic) async {
    final Box chatVault = await Hive.openBox<MessageBasketHive>("${topic}_chat");
    await chatVault.clear();
  }

  Stream<String> get stream => _controller.stream;
}
