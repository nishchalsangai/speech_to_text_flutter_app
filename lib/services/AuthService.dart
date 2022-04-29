import 'dart:async';
import 'dart:convert';

import 'package:hive/hive.dart';

class AuthenticationService {
  late String _secureKey;

  String? _userEmail;

  String? get userEmail {
    return _userEmail;
  }

  AuthenticationService({required String secureKey}) {
    _secureKey = secureKey;
    controller.add(false);
  }
  StreamController<bool> controller = StreamController<bool>();

  bool loginValue = false;

  Stream get loginStatus {
    return controller.stream;
  }

  Future<int> signIn(String email, String userPassword) async {
    print("The values are $email, $userPassword");
    print(_secureKey);
    final encryptionKey = base64Url.decode(_secureKey);
    print(encryptionKey);
    final encryptedCredentials =
        await Hive.openBox('Credentials', encryptionCipher: HiveAesCipher(encryptionKey));

    String? password = encryptedCredentials.get(email);
    if (password == userPassword) {
      _userEmail = email;
      loginValue = true;
      controller.add(true);
      return 1;
    } else if (password == null) {
      return -1;
    } else //if (password != userPassword)
    {
      return 0;
    }
  }

  Future<int> signUp({required String userEmail, required String userPassword}) async {
    final encryptionKey = base64Url.decode(_secureKey);
    final encryptedCredentials =
        await Hive.openBox('Credentials', encryptionCipher: HiveAesCipher(encryptionKey));
    try {
      String? password = encryptedCredentials.get(userEmail);
      if (password != null) {
        return 0;
      }
      encryptedCredentials.put(userEmail, userPassword);
      _userEmail = userEmail;
      loginValue = true;
      controller.add(true);
      return 1;
    } catch (error) {
      return -1;
    }
  }

  logOut() {
    _userEmail = null;
    loginValue = false;
    controller.add(false);
  }
  //
  // String? get userEmail {
  //   return _userEmail;
  // }

}
