import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
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
  late int _index;
  late int messagesIndex;
  final GlobalKey<AnimatedListState> listKey = GlobalKey();
  late bool isListening;
  late bool check;
  late List<dynamic> preSavedChatLength;
  SpeechToText speechToText = SpeechToText();
  late bool speechEnabled;
  late String lastWords;

  ChatManager(String topic, String userId) {
    chatDataService = ChatDataService(topic: "${userId}_${topic}");
    _index = 0;
    messagesIndex = 0;
    isListening = false;
    check = false;
    preSavedChatLength = [];
    speechEnabled = false;
    lastWords = '';
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

  timeOut() {
    Future.delayed(const Duration(milliseconds: 400)).then((value) {
      isListening = false;
      notifyListeners();
    });
    return const Duration(seconds: 1);
  }

  checkIfSpeechIsOn() {
    isListening = speechToText.isListening ? true : false;
    print(isListening);
    print("asdasdasdasd");
  }
  /* void startListening() async {
    isListening = true;
    await speechToText.listen(
      onResult: _onSpeechResult,
    );
    notifyListeners();
  }

  void stopListening() async {
    isListening = false;
    notifyListeners();
    await speechToText.stop();
    notifyListeners();
  }*/

  void _onSpeechResult(SpeechRecognitionResult result) {
    lastWords = result.recognizedWords;
    isListening = false;
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
    MessageBasketHive m;
    if (lastWords.isNotEmpty) {
      m = MessageBasketHive()
        ..message = lastWords
        ..sentByUser = true;
      addMessage(m);
      notifyListeners();
    }
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
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      elevation: 0,
      backgroundColor: Colors.red.shade200,
      content: Text(
        "Your reply is not correct",
        style:
            GoogleFonts.openSans(fontSize: 13.sp, color: Colors.white, fontWeight: FontWeight.w600),
      ),
    ));
  }

  checkIndex() {
    if (_index == resChat.length) {
      check = true;
      notifyListeners();
    }
  }

  statusListener(val) {
    if (val == 'notListening') {
      isListening = false;
      notifyListeners();
    }
  }

  changeIsListening() {
    isListening = false;
    notifyListeners();
  }

  /* errorListener(error) {
    changeIsListening();
    print("Received error status: $error, listening: ${speechToText.isListening}");
    var lastError = "${error.errorMsg} - ${error.permanent}";
    print(lastError);
  }*/

  void listen() async {
    if (!isListening) {
      print("is speech enabled? $speechEnabled");
      if (speechEnabled) {
        isListening = true;

        notifyListeners();
        await speechToText.listen(onResult: _onSpeechResult).then((value) {
          lastWords.isEmpty
              ? Future.delayed(const Duration(seconds: 2)).then((value) {
                  isListening = false;

                  notifyListeners();
                })
              : null;
        });
        notifyListeners();
      }
    } else {
      isListening = false;
      speechToText.stop();
      notifyListeners();
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    speechToText.cancel();

    super.dispose();
    _messagesStream.cancel();
  }
}
