import 'package:flutter/material.dart';

class ValidateMixin {
  String? usernameValidator(value) {
    if (value!.length < 4) {
      return 'Enter at least 4 characters';
    } else if (value.length > 30) {
      return 'Enter atmost 30 characters';
    } else {
      return null;
    }
  }

  String? emailValidator(value) {
    const pattern = r'(^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$)';
    final regExp = RegExp(pattern);

    if (value!.isEmpty) {
      return 'Enter an email';
    } else if (!regExp.hasMatch(value)) {
      return 'Enter a valid email';
    } else {
      return null;
    }
  }

  String? passwordValidator(value) {
    const pattern = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
    final regExp = RegExp(pattern);

    if (value!.isEmpty) {
      return 'Enter Password';
    } else if (!regExp.hasMatch(value)) {
      return 'Enter a valid password';
    } else {
      return null;
    }
  }
}
