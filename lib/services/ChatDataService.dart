import 'dart:async';
import 'package:hive/hive.dart';
import 'package:ninjastudytask/models/MessageBasketHive.dart';

class ChatDataService {
  String? _topic;
  final _controller = StreamController<MessageBasketHive>();
  ChatDataService({required String topic}) {
    _topic = topic;
  }

  addMessageToChat(MessageBasketHive message) async {
    final chatVault = await Hive.openBox<MessageBasketHive>("${_topic}_chat");
    chatVault.add(message).then((value) {
      print(value);
      _controller.sink.add(message);
    });
  }

  getAllMessages() async {
    final chatVault = await Hive.openBox<MessageBasketHive>("${_topic}_chat");
    return chatVault;
  }

  Stream<MessageBasketHive> get stream => _controller.stream;

  clearHiveBox() async {
    final Box chatVault = await Hive.openBox<MessageBasketHive>("${_topic}_chat");
    print(chatVault.isOpen);
    await chatVault.clear();
  }
}
