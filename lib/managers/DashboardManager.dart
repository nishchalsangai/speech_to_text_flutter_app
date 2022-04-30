import 'dart:async';
import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ninjastudytask/services/AuthService.dart';
import 'package:provider/provider.dart';

import '../screens/ChatScreen.dart';
import '../services/DashboardService.dart';
import 'ChatManager.dart';

class DashboardManager extends ChangeNotifier {
  late DashboardService dashboardService;
  late StreamSubscription _dashboardStream;
  late List<String> dashboardBasket;
  late bool check = false;
  int index = 0;
  late String _userId;

  DashboardManager(BuildContext context, String userId) {
    dashboardService = DashboardService(topic: "${userId}_Dashboard");
    _userId = userId;
    dashboardBasket = [];
    dashboardChats();
    dashboardStream();
  }

  dashboardStream() {
    _dashboardStream = dashboardService.stream.listen((event) {
      dashboardBasket.add(event);
      notifyListeners();
    });
  }

  addToDashboardVault(String value, bool isRestarted, bool firstTime) async {
    await dashboardService.addToDashBoard("${_userId}_${value}", isRestarted, firstTime);
  }

  dashboardChats() async {
    await dashboardService.getAllChatsOnDashboard();
  }

  UnmodifiableListView get allChats {
    return UnmodifiableListView(dashboardBasket);
  }

  restartOrBrowse(String topic, BuildContext context) async {
    check = (await dashboardService.checkIfBoxExist("${_userId}_${topic}"))!;
    return check;
  }

  clearChatAndRestart(String topic, BuildContext context) async {
    await dashboardService.clearHiveBox("${_userId}_$topic").then((value) async {
      await addToDashboardVault("${_userId}_$topic", true, false);
      Navigator.pop(context);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => ChangeNotifierProvider(
                    create: (_) => ChatManager('Restaurant', _userId),
                    child: const ChatScreen(),
                  )));
    });
  }

  browseOnPressed(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => ChangeNotifierProvider(
                  create: (_) => ChatManager('Restaurant', _userId),
                  child: const ChatScreen(),
                )));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}
