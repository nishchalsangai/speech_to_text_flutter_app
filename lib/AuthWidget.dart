import 'package:flutter/material.dart';
import 'package:ninjastudytask/screens/HomeScreen.dart';
import 'package:ninjastudytask/screens/LoginScreen.dart';
import 'package:ninjastudytask/services/AuthService.dart';
import 'package:provider/provider.dart';
import 'managers/AuthManager/AuthManager.dart';
import 'managers/DashboardManager.dart';
import 'models/Secondary/category.dart';
import 'models/user.dart';

class AuthWidget extends StatelessWidget {
  final userSnapshot;

  AuthWidget({required this.userSnapshot});

  @override
  Widget build(BuildContext context) {
    print("I am here,  ${userSnapshot.data} and ${userSnapshot.connectionState}\n\n\n\n\n\n");
    if (userSnapshot.connectionState == ConnectionState.active ||
        userSnapshot.connectionState == ConnectionState.done) {
      final userId = context.watch<AuthenticationService>().userEmail;
      print("${userSnapshot.data} \n\n\n\n\n\n");
      if (userId != null) {
        return ChangeNotifierProvider(
            create: (_) => DashboardManager(context, userId), child: const HomePage());
      } else {
        return const LogInScreen();
      }
    }
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
