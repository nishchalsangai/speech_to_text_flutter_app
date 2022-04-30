import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import '../constants/colors.dart';
import '../managers/ChatManager.dart';
import '../models/MessageBasketHive.dart';
import 'package:avatar_glow/avatar_glow.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatManager>(builder: (context, chatManager, child) {
      return chatManager.loading == true
          ? const Center(child: CircularProgressIndicator())
          : Scaffold(
              appBar: AppBar(
                centerTitle: true,
                title: Text("Restaurant",
                    style: GoogleFonts.openSans(
                        fontSize: 20.sp,
                        color: AppColor.headingColor,
                        fontWeight: FontWeight.w600)),
              ),
              body: SingleChildScrollView(
                  reverse: true,
                  physics: const BouncingScrollPhysics(),
                  child: AnimatedList(
                    key: chatManager.listKey,
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    initialItemCount: chatManager.allMessages.length,
                    padding: EdgeInsets.only(top: 20.r, bottom: 75.r),
                    itemBuilder: (context, index, animation) {
                      MessageBasketHive message = chatManager.allMessages.elementAt(index);
                      print(chatManager.pronouncedCorrect[index]);
                      return Padding(
                        padding: message.sentByUser!
                            ? EdgeInsets.only(left: 64.0.r, right: 16.0.r)
                            : EdgeInsets.only(left: 16.0.r, right: 64.0.r),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 10.h,
                            ),
                            message.sentByUser!
                                ? buildRowOfChat(
                                    const Spacer(),
                                    Expanded(
                                      child: componentOfMessage(
                                          message, index, chatManager.pronouncedCorrect[index]),
                                    ),
                                  )
                                : buildRowOfChat(
                                    Expanded(child: componentOfMessage(message, index, true)),
                                    const Spacer(),
                                  ),
                          ],
                        ),
                      );
                    },
                  )),
              bottomNavigationBar: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          color: AppColor.headingColor.withOpacity(0.05),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      chatManager.check
                                          ? chatManager.expectedReply
                                          : chatManager.lastWords,
                                      style: GoogleFonts.openSans(
                                          fontSize: 16.sp,
                                          color: AppColor.primaryColor,
                                          fontWeight: FontWeight.w600),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  AvatarGlow(
                                    endRadius: 30.r,
                                    repeat: true,
                                    glowColor: AppColor.primaryColor,
                                    animate: chatManager.isListening,
                                    child: CircleAvatar(
                                      radius: 20.r,
                                      backgroundColor: AppColor.headingColor.withOpacity(0.05),
                                      child: IconButton(
                                        onPressed: chatManager.check == true
                                            ? null
                                            : () => chatManager.listen(),
                                        icon: const Icon(Icons.mic),
                                        color: AppColor.headingColor,
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: chatManager.check == true
                                        ? null
                                        : () => chatManager.checkMessage(context),
                                    icon: const Icon(Icons.send),
                                    color: AppColor.headingColor,
                                  ),
                                ],
                              ),
                              !chatManager.check
                                  ? Container(
                                      color: AppColor.accentColor,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Text(
                                            "Say the sentence",
                                            style: GoogleFonts.openSans(
                                                fontSize: 16.sp,
                                                color: AppColor.headingColor,
                                                fontWeight: FontWeight.w600),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          Expanded(
                                            child: Text(
                                              chatManager.expectedReply,
                                              style: GoogleFonts.openSans(
                                                  fontSize: 16.sp,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w600),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  : const SizedBox(),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
    });
  }
}

Row buildRowOfChat(Widget first, Widget second) {
  return Row(
    children: [
      first,
      second,
    ],
  );
}

Container componentOfMessage(MessageBasketHive message, int index, bool isPronouncedCorrect) {
  return Container(
    decoration: BoxDecoration(
      color: message.sentByUser!
          ? isPronouncedCorrect
              ? AppColor.accentColor
              : Colors.redAccent.shade100
          : AppColor.headingColor.withOpacity(0.1),
      borderRadius: BorderRadius.circular(12.r),
    ),
    child: Padding(
      padding: EdgeInsets.all(8.0.r),
      child: Text(
        message.message,
        textAlign: TextAlign.center,
        style: GoogleFonts.openSans(
            fontSize: 16.sp,
            color: message.sentByUser! ? Colors.white : AppColor.headingColor,
            fontWeight: FontWeight.w500),
      ),
    ),
  );
}
