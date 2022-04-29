import 'package:flutter/material.dart';
import 'colors.dart';

class CustomTheme {
  static ThemeData get mainTheme {
    return ThemeData(
      primaryColor: AppColor.primaryColor,
      scaffoldBackgroundColor: Colors.white,
      fontFamily: 'Montserrat',
      appBarTheme: AppBarTheme(
        color: Colors.grey.shade200,
        elevation: 0,
        iconTheme: const IconThemeData(
          color: AppColor.headingColor, //change your color here
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColor.primaryColor,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
          primary: AppColor.primaryColor, // background (button) color
        ),
      ),
      buttonTheme: ButtonThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
        buttonColor: AppColor.primaryColor,
      ),
    );
  }
}
