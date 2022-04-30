import 'package:hive/hive.dart';

import '../models/UserData.dart';

class UserDataService {
  String? _userEmail;
  UserDataService({String? userEmail}) {
    _userEmail = userEmail;
  }

  Future<UserData?> get userData async {
    if (_userEmail == null) return null;
    final userVault = await Hive.openBox('UserData');
    UserData userData = UserData.fromMap(userVault.get(_userEmail));
    return userData;
  }

  Future<void> saveUserData(String userEmail, String userName) async {
    final userVault = await Hive.openBox('UserData');
    Map userData = {'userEmail': userEmail, 'userName': userName};
    userVault.put(userEmail, userData).then((value) {
      return 1;
    });
  }

  String? get userEmail {
    return _userEmail;
  }
}
