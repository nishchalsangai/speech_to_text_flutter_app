import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:ninjastudytask/models/Secondary/restaurant.dart';
import 'package:ninjastudytask/services/ChatDataService.dart';
import 'package:ninjastudytask/services/secondary/ResService.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'dart:async';
import 'package:flutter/foundation.dart';

import '../models/MessageBasketHive.dart';

class ChatManager extends ChangeNotifier {
  late List<Restaurant> resChat;
  late List<MessageBasketHive> messages;
  late bool loading = true;
  late StreamSubscription _messagesStream;
  late List<bool> pronouncedCorrect = [];
  late String expectedReply;
  late ChatDataService chatDataService;
  int _index = 0;
  int messagesIndex = 0;
  final GlobalKey<AnimatedListState> listKey = GlobalKey();
  bool glow = false;
  bool check = false;
  List<dynamic> preSavedChatLength = [];
  SpeechToText speechToText = SpeechToText();
  bool speechEnabled = false;
  String lastWords = '';

  ChatManager(String topic) {
    chatDataService = ChatDataService(topic: topic);
    _initSpeech();
    initializeChat();
    messagesStream();
  }

  getAllPreMessages() async {
    await chatDataService.getAllMessages().then((messageVault) {
      print(messageVault.values.length);
      for (final ele in messageVault.values) {
        pronouncedCorrect.add(true);
        preSavedChatLength.add(ele);
      }
      notifyListeners();
    });
  }

  initializeChat() async {
    await getAllPreMessages();
    print("THe preSaved ${preSavedChatLength.length}\n\n\n\n\n\n\n");
    if (preSavedChatLength.isNotEmpty) {
      check = true;
      loading = false;
      messages = [];
      messages.addAll(preSavedChatLength.cast<MessageBasketHive>());
      lastWords = '';
      expectedReply = "Conversation ends here!";
      notifyListeners();
    } else {
      try {
        messages = [];
        resChat = await getChatData();
        notifyListeners();
        final mssg = MessageBasketHive()
          ..message = resChat[_index].bot
          ..sentByUser = false;
        expectedReply = resChat[_index].human;
        addMessage(mssg);
        loading = false;
        notifyListeners();
      } catch (Ex) {
        print(Ex);
      }
    }
  }

  void _initSpeech() async {
    speechEnabled = await speechToText.initialize();
    notifyListeners();
  }

  void startListening() async {
    glow = true;
    await speechToText.listen(
        onResult: _onSpeechResult,
        listenFor: glow ? const Duration(days: 365) : const Duration(seconds: 0),
        pauseFor: const Duration(seconds: 5),
        partialResults: true,
        listenMode: ListenMode.confirmation);
    notifyListeners();
  }

  void stopListening() async {
    glow = false;
    await speechToText.stop();
    notifyListeners();
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    lastWords = result.recognizedWords;
    glow = false;
    notifyListeners();
  }

  messagesStream() {
    _messagesStream = chatDataService.stream.listen((event) {
      messagesIndex = messages.length;
      messages.add(event);
      if (event.sentByUser!) {
        if (event.message.toLowerCase() !=
            (_index == 0
                ? resChat[0].human.toLowerCase().replaceAll(",", '')
                : resChat[_index - 1].human.toLowerCase().replaceAll(",", ''))) {
          pronouncedCorrect.add(false);
        } else {
          pronouncedCorrect.add(true);
        }
      } else {
        pronouncedCorrect.add(true);
      }
      if (listKey.currentState != null) listKey.currentState!.insertItem(messagesIndex);
      notifyListeners();
    });
  }

  UnmodifiableListView<MessageBasketHive> get allMessages {
    return UnmodifiableListView(messages);
  }

  addMessage(MessageBasketHive msg) {
    chatDataService.addMessageToChat(msg);
  }

  checkMessage(BuildContext context) {
    MessageBasketHive m = MessageBasketHive()
      ..message = lastWords
      ..sentByUser = true;
    addMessage(m);
    notifyListeners();
    if (lastWords.isEmpty ||
        (lastWords.toLowerCase() != expectedReply.toLowerCase().replaceAll(",", ''))) {
      lastWords = '';
      showInSnackBar(context);
      notifyListeners();
    } else {
      _index++;
      if (_index == resChat.length) {
        lastWords = '';
        expectedReply = "Conversation ends here!";
        checkIndex();
      } else {
        expectedReply = resChat[_index].human;
        lastWords = '';
        notifyListeners();
        m = MessageBasketHive()
          ..message = resChat[_index].bot
          ..sentByUser = false;
        Future.delayed(const Duration(milliseconds: 600), () {
          addMessage(m);
          notifyListeners();
        });
      }
    }
  }

  void showInSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text("Your reply is not correct"),
    ));
  }

  checkIndex() {
    if (_index == resChat.length) {
      check = true;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _messagesStream.cancel();
    /* chatDataService.clearHiveBox();*/
  }
}
