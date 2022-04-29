class UserData {
  late String _userEmail;
  late String _userName;

  UserData({required String emailId, required String userName}) {
    _userEmail = emailId;
    _userName = userName;
  }

  factory UserData.fromMap(Map data) {
    return UserData(emailId: data['userEmail'], userName: data['userName']);
  }

  String get userName {
    return _userName;
  }

  String get userEmail {
    return _userEmail;
  }
}
