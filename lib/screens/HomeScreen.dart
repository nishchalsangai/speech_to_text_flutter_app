import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ninjastudytask/constants/colors.dart';
import 'package:ninjastudytask/managers/AuthManager/AuthManager.dart';
import 'package:ninjastudytask/managers/ChatManager.dart';
import 'package:ninjastudytask/managers/DashboardManager.dart';
import 'package:ninjastudytask/screens/ChatScreen.dart';
import 'package:ninjastudytask/services/AuthService.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authLogOut = Provider.of<AuthManager>(context, listen: false);
    return Consumer<DashboardManager>(builder: (context, homeManager, child) {
      return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: GestureDetector(
            onTap: () {
              context.read<AuthenticationService>().logOut();
            },
            child: Text(
              "DashBoard",
              style: GoogleFonts.openSans(
                  fontSize: 20, color: AppColor.headingColor, fontWeight: FontWeight.w600),
            ),
          ),
          actions: [
            IconButton(onPressed: () => authLogOut.signOut(context), icon: const Icon(Icons.logout))
          ],
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  child: Text(
                    "History",
                    style: GoogleFonts.openSans(
                        fontSize: 24, color: AppColor.headingColor, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.left,
                  ),
                ),
                ListView.builder(
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    itemCount: homeManager.allChats.length,
                    itemBuilder: (context, index) {
                      print(homeManager.allChats.length);
                      return Container(
                        padding: const EdgeInsets.all(20),
                        margin: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: const BorderRadius.all(
                            Radius.circular(16),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.shade100,
                              blurRadius: 20,
                              spreadRadius: 10,
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CircleAvatar(
                                radius: 25.r, backgroundImage: AssetImage('assets/spot-197.png')),
                            SizedBox(
                              width: 10.w,
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                homeManager.allChats[index].split('_')[1],
                                style: GoogleFonts.openSans(
                                    fontSize: 16.sp,
                                    color: AppColor.headingColor,
                                    fontWeight: FontWeight.w600),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () async{
                                await homeManager
                                    .restartOrBrowse('Restaurant', context)
                                    .then((value) {
                                  print("it;s home manager check $value");
                                  if (value == true) {
                                    showAlertDialog(context, homeManager);
                                  } else {
                                    homeManager.addToDashboardVault('Restaurant', false, true);
                                    homeManager.browseOnPressed(context);
                                  }
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                primary: AppColor.accentColor.withOpacity(0.8),
                                elevation: 0,
                              ),
                              child: Text(
                                "Tap",
                                style: GoogleFonts.openSans(
                                    fontSize: 14.sp,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600),
                              ),
                            )
                          ],
                        ),
                      );
                    }),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              showModalBottomSheet(
                  context: context,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16.0),
                      topRight: Radius.circular(16.0),
                    ),
                  ),
                  builder: (context) {
                    return SizedBox(
                      height: 200,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          GestureDetector(
                            onTap: () async {
                              await homeManager
                                  .restartOrBrowse('Restaurant', context)
                                  .then((value) {
                                print("it;s home manager check $value");
                                if (value == true) {
                                  showAlertDialog(context, homeManager);
                                } else {
                                  homeManager.addToDashboardVault('Restaurant', false, true);
                                  homeManager.browseOnPressed(context);
                                }
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.all(16.0),
                              margin: const EdgeInsets.all(16.0),
                              decoration: BoxDecoration(
                                  color: AppColor.headingColor.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12)),
                              child: Column(
                                children: [
                                  const CircleAvatar(
                                      radius: 25,
                                      backgroundImage: AssetImage('assets/spot-197.png')),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    'Restaurant',
                                    style: GoogleFonts.openSans(
                                        fontSize: 16,
                                        color: AppColor.headingColor,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  });
            },
            label: Row(
              children: [
                const Icon(Icons.add),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  "New Conversation",
                  style: GoogleFonts.openSans(
                      fontSize: 16, color: Colors.white, fontWeight: FontWeight.w600),
                )
              ],
            )),
      );
    });
  }

  showAlertDialog(BuildContext context, DashboardManager homeManager) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: const Text("Restart"),
      onPressed: () => homeManager.clearChatAndRestart('Restaurant', context),
    );
    Widget continueButton = TextButton(
      child: const Text("Browse"),
      onPressed: () {
        Navigator.pop(context);
        homeManager.browseOnPressed(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("Restaurants"),
      content: const Text("You Already have some conversation, so what do you want to do now?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
