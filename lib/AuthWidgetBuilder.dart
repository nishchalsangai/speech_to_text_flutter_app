import 'package:flutter/material.dart';
import 'package:ninjastudytask/services/AuthService.dart';
import 'package:ninjastudytask/services/UserDataService.dart';
import 'package:provider/provider.dart';
import 'managers/AuthManager/AuthManager.dart';
import 'models/UserData.dart';

class AuthWidgetBuilder extends StatelessWidget {
  AuthWidgetBuilder({this.builder});
  final Widget Function(BuildContext, AsyncSnapshot<Object?>)? builder;
  @override
  Widget build(BuildContext context) {
    print('AuthWidgetBuilder rebuild');
    return StreamBuilder(
      stream: context.read<AuthenticationService>().loginStatus,
      builder: (context, userSnapshot) {
        print("Hello the user snapshot is here");
        print("${userSnapshot.data}");
        return FutureBuilder(
            future: UserDataService(userEmail: context.read<AuthenticationService>().userEmail)
                .userData,
            builder: (context, userSnap) {
              print("User snap data ${userSnap.data}  and ${userSnap.connectionState}");
              switch (userSnap.connectionState) {
                case ConnectionState.active:
                case ConnectionState.waiting:
                case ConnectionState.done:
                  if (userSnap.hasData && userSnap.data != null) {
                    print("Hello to provider builder");
                    return Provider<UserData>.value(
                      value: userSnap.data as UserData,
                      child: builder!(context, userSnapshot),
                    );
                  }
                  print("Hello to other builder");
                  return ChangeNotifierProvider(
                      create: (_) => AuthManager(), child: builder!(context, userSnapshot));
                case ConnectionState.none:
                default:
                  return const Scaffold(
                    body: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
              }
            });
      },
    );
  }
}
