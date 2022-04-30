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
    const capitalLetterPattern = r'^(?=.*?[A-Z])$';
    const smallLetterPattern = r'^(?=.*?[a-z])$';
    const numberPattern = r'^(?=.*?[0-9])$';
    const specialPattern = r'^(?=.*?[!@#\$&*~])$';
    final regExp = RegExp(pattern);

    if (value!.isEmpty) {
      return 'Enter Password';
    } else if (!regExp.hasMatch(value)) {
     /* if (!value.toString().contains(capitalLetterPattern)) {
        return 'Password should contain at least one capital letter\n';
      }
      if (!value.toString().contains(smallLetterPattern)) {
        return 'Password should contain at least one small letter\n';
      }
      if (!value.toString().contains(numberPattern)) {
        return 'Password should contain at least one number\n';
      }
      if (!value.toString().contains(specialPattern)) {
        return 'Password should contain at least one special character\n';
      }
      if (value.toString().length < 8) {
        return 'Password length should be equal or greater than 8\n';
      }*/
         return 'Password should contain:\n1)at least one capital letter\n2)at least one small letter\n3)at least one special character\n4)minimum length should be 8';
    }
    {
      return null;
    }
  }
}
