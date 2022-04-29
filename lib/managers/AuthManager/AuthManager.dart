import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../services/AuthService.dart';

class AuthManager extends ChangeNotifier {
  late String loggedId;
  bool loading = false;

  TextEditingController username = TextEditingController();
  final GlobalKey<FormState> registerKey = GlobalKey<FormState>();
  TextEditingController email = TextEditingController();
  final GlobalKey<FormState> loginKey = GlobalKey<FormState>();
  TextEditingController password = TextEditingController();
  bool isPasswordVisible = true;
  double passwordStrength = 0;

  AuthManager() {
    loggedId = "";
  }

  changePasswordVisibility() {
    isPasswordVisible = !isPasswordVisible;
    notifyListeners();
  }

  Future<int> signUp(BuildContext context) async {
    try {
      final isValid = registerKey.currentState!.validate();
      if (isValid) {
        registerKey.currentState!.save();
        loading = true;
        notifyListeners();
        context
            .read<AuthenticationService>()
            .signUp(userEmail: email.text, userPassword: password.text, userName: username.text)
            .then((value) {
          print("The value is $value");
          loading = false;
          notifyListeners();
          return value;
        });
      }
    } catch (Ex) {
      print(Ex);
      loading = false;
      username.clear();
      email.clear();
      password.clear();
      notifyListeners();
      return -1;
    }
    loading = false;
    notifyListeners();
    return -1;
  }

  Future<int> signIn(BuildContext context) async {
    try {
      final isValid = loginKey.currentState!.validate();
      if(email.text.isEmpty || password.text.isEmpty){
        showInSnackBar(context,0);
      }
      else if (isValid) {
        loginKey.currentState!.save();
        loading = true;
        notifyListeners();
        context.read<AuthenticationService>().signIn(email.text, password.text).then((value) {
          print("The value is $value");
          loading = false;
          notifyListeners();
          showInSnackBar(context, value);
          return value;
        });
      }
    } catch (Ex) {
      print(Ex);
      loading = false;

      notifyListeners();
      return -1;
    }
    loading = false;
    notifyListeners();
    return -1;
  }

  strongPasswordCheck(value) {
    RegExp regex = RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
    if (value.toString().isEmpty) {
      passwordStrength = 0;
      notifyListeners();
    } else if (value.toString().length <= 4) {
      passwordStrength = 1 / 3;
      notifyListeners();
    } else if (value.toString().length > 4 && value.toString().length <= 8) {
      passwordStrength = 2 / 3;
      notifyListeners();
    } else if (value.toString().length > 8 && regex.hasMatch(value.toString())) {
      passwordStrength = 1;
      notifyListeners();
    }
    return null;
  }

  signOut(BuildContext context) async {
    email.clear();
    password.clear();
    await context.read<AuthenticationService>().logOut();
  }

  void showInSnackBar(BuildContext context, int val) {
    val == -1
        ? ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.red,
            content: Text(
              "Credentials you provided are incorrect",
              style: GoogleFonts.openSans(
                  fontSize: 13.sp, color: Colors.white, fontWeight: FontWeight.w600),
            ),
          ))
        : val == 0
            ? ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                backgroundColor: Colors.red,
                content: Text(
                  "Fields are empty, please fill it!",
                  style: GoogleFonts.openSans(
                      fontSize: 13.sp, color: Colors.white, fontWeight: FontWeight.w600),
                ),
              ))
            : null;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    username.dispose();
    email.dispose();
    password.dispose();
    super.dispose();
  }
}
