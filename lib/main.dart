import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive/hive.dart';
import 'package:ninjastudytask/constants/custom_themes.dart';
import 'package:ninjastudytask/services/AuthService.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import 'AuthWidget.dart';
import 'AuthWidgetBuilder.dart';
import 'models/MessageBasketHive.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  const secureStorage = FlutterSecureStorage();
  // if key not exists return null
  String? encryptionKey;
  if (encryptionKey == null) {
    final secureKey = Hive.generateSecureKey();
    await secureStorage.write(
      key: 'key',
      value: base64UrlEncode(secureKey),
    );
  }
  encryptionKey = await secureStorage.read(key: 'key');
  Directory tempDir = await getTemporaryDirectory();
  Hive.init(tempDir.path);
  Hive.registerAdapter(MessageBasketHiveAdapter());

  runApp(MyApp(secureKey: encryptionKey!));
}

class MyApp extends StatelessWidget {
  final String secureKey;
  MyApp({required this.secureKey});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          Provider<AuthenticationService>(
            create: (_) => AuthenticationService(secureKey: secureKey),
          ),
        ],
        child: AuthWidgetBuilder(builder: (context, userSnapshot) {
          return ScreenUtilInit(
              designSize: Size(360, 690),
              minTextAdapt: true,
              splitScreenMode: true,
              builder: (_) => MaterialApp(
                    debugShowCheckedModeBanner: false,
                    builder: (context, widget) {
                      ScreenUtil.setContext(context);
                      return MediaQuery(
                        data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                        child: widget!,
                      );
                    },
                    theme: CustomTheme.mainTheme,
                    home: AuthWidget(userSnapshot: userSnapshot),
                  ));
        }));
  }
}
