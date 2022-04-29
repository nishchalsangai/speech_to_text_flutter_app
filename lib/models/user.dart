class User {
  late String _emailId;
  late String _password;
  late bool _loggedIn;

  User({required String emailId, required String password}) {
    _emailId = emailId;
    _password = password;
    _loggedIn = false;
  }

  String get emailId {
    if (_emailId.isNotEmpty) {
      return _emailId;
    }
    return "No email found";
  }

  String get password {
    if (_password.isNotEmpty) {
      return _password;
    }
    return "No password found";
  }

  bool get loginStatus {
    return _loggedIn;
  }
}
