import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ninjastudytask/constants/mixins.dart';
import 'package:provider/provider.dart';
import '../constants/colors.dart';
import '../constants/widgets.dart';
import '../managers/AuthManager/AuthManager.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SignUpScreen extends StatelessWidget with ValidateMixin {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthManager>(builder: (context, authManager, child) {
      return Scaffold(
        backgroundColor: Colors.grey.shade100,
        body: SafeArea(
          child: Form(
              key: authManager.registerKey,
              child: Padding(
                padding: EdgeInsets.all(32.0.r),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 90.h,
                      ),
                      Text(
                        "REGISTER",
                        style: GoogleFonts.openSans(
                            fontSize: 30.sp,
                            color: AppColor.headingColor,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 70.h,
                      ),
                      userNameHandler(),
                      SizedBox(
                        height: 20.h,
                      ),
                      emailHandler(),
                      SizedBox(
                        height: 20.h,
                      ),
                      passwordHandler(),
                      SizedBox(
                        height: 20.h,
                      ),
                      passwordCheckIndicator(authManager.passwordStrength),
                      SizedBox(
                        height: 10.h,
                      ),
                      authManager.passwordStrength == 0
                          ? Text(
                              "Enter a strong password",
                              style: GoogleFonts.openSans(
                                  fontSize: 12.sp,
                                  color: AppColor.headingColor,
                                  fontWeight: FontWeight.w500),
                            )
                          : authManager.passwordStrength == 1 / 3
                              ? Text(
                                  "Password is weak",
                                  style: GoogleFonts.openSans(
                                      fontSize: 12.sp,
                                      color: AppColor.headingColor,
                                      fontWeight: FontWeight.w500),
                                )
                              : authManager.passwordStrength == 2 / 3
                                  ? Text(
                                      "Password is moderate",
                                      style: GoogleFonts.openSans(
                                          fontSize: 12.sp,
                                          color: AppColor.headingColor,
                                          fontWeight: FontWeight.w500),
                                    )
                                  : Text(
                                      "Password is strong",
                                      style: GoogleFonts.openSans(
                                          fontSize: 12.sp,
                                          color: AppColor.headingColor,
                                          fontWeight: FontWeight.w500),
                                    ),
                      SizedBox(
                        height: 30.h,
                      ),
                      ElevatedButton(
                          onPressed: () {
                            print("Initiating signup");
                            authManager.signUp(context).then((value) {
                              if (value == 1) {
                                print("Successful");
                                Navigator.of(context).popUntil((route) => route.isFirst);
                              } else {
                                print("Check your credentials");
                              }
                            });
                            Navigator.of(context).popUntil((route) => route.isFirst);
                          },
                          child: SizedBox(
                            height: 50.h,
                            width: double.infinity,
                            child: Center(
                              child: Text(
                                "REGISTER",
                                style: GoogleFonts.openSans(
                                    fontSize: 16.sp,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          )),
                    ],
                  ),
                ),
              )),
        ),
      );
    });
  }

  SizedBox orDivider() {
    return SizedBox(
        child: Row(
      children: [
        const Expanded(child: Divider()),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.0.r),
          child: Text(
            "OR",
            style: GoogleFonts.openSans(
                fontSize: 12.sp, color: AppColor.headingColor, fontWeight: FontWeight.w600),
          ),
        ),
        const Expanded(child: Divider()),
      ],
    ));
  }

  passwordHandler() {
    return Consumer<AuthManager>(builder: (context, authManager, child) {
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(16.r),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade100,
              blurRadius: 20.r,
              spreadRadius: 10.r,
            ),
          ],
        ),
        child: TextFormField(
          // autovalidateMode: AutovalidateMode.always,
          onChanged: (value) => authManager.strongPasswordCheck(value),
          validator: passwordValidator,
          controller: authManager.password,
          obscureText: authManager.isPasswordVisible,
          style: GoogleFonts.openSans(
              fontSize: 16.sp, color: AppColor.headingColor, fontWeight: FontWeight.w600),
          decoration: InputDecoration(
            focusColor: AppColor.primaryColor,
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16.r), borderSide: BorderSide.none),
            hintStyle: GoogleFonts.openSans(
                fontSize: 14.sp, color: AppColor.headingColor, fontWeight: FontWeight.w600),
            prefixIcon: const Icon(
              Icons.verified_user,
              color: AppColor.primaryColor,
            ),
            floatingLabelBehavior: FloatingLabelBehavior.always,
            hintMaxLines: 1,
            contentPadding: EdgeInsets.symmetric(horizontal: 25.r, vertical: 15.r),
            errorStyle: TextStyle(fontSize: 16.0.sp),
            suffixIcon: IconButton(
              color: AppColor.primaryColor,
              icon: authManager.isPasswordVisible
                  ? const Icon(Icons.visibility_off)
                  : const Icon(Icons.visibility),
              onPressed: () => authManager.changePasswordVisibility(),
            ),
            hintText: "Password",
          ),
        ),
      );
    });
  }

  userNameHandler() {
    return Consumer<AuthManager>(builder: (context, authManager, child) {
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(16.r),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade100,
              blurRadius: 20.r,
              spreadRadius: 10.r,
            ),
          ],
        ),
        child: TextFormField(
          keyboardType: TextInputType.text,
          validator: usernameValidator,
          controller: authManager.username,
          style: GoogleFonts.openSans(
              fontSize: 16.sp, color: AppColor.headingColor, fontWeight: FontWeight.w600),
          decoration: InputDecoration(
            filled: true,
            hintText: 'Full Name',
            fillColor: Colors.white,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16.r), borderSide: BorderSide.none),
            hintStyle: GoogleFonts.openSans(
                fontSize: 14.sp, color: AppColor.headingColor, fontWeight: FontWeight.w600),
            prefixIcon: const Icon(
              Icons.person,
              color: AppColor.primaryColor,
            ),
            suffixIcon: const Icon(
              Icons.lock,
              color: AppColor.primaryColor,
            ),
            floatingLabelBehavior: FloatingLabelBehavior.always,
            hintMaxLines: 1,
            contentPadding: EdgeInsets.symmetric(horizontal: 25.r, vertical: 15.r),
            errorStyle: TextStyle(fontSize: 16.0.sp),
          ),
        ),
      );
    });
  }

  emailHandler() {
    return Consumer<AuthManager>(builder: (context, authManager, child) {
      return Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(
            Radius.circular(16),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade100,
              blurRadius: 20,
              spreadRadius: 10,
            ),
          ],
        ),
        child: TextFormField(
          keyboardType: TextInputType.emailAddress,
          validator: emailValidator,
          controller: authManager.email,
          style: GoogleFonts.openSans(
              fontSize: 16, color: AppColor.headingColor, fontWeight: FontWeight.w600),
          decoration: InputDecoration(
            filled: true,
            hintText: 'Email',
            fillColor: Colors.white,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
            hintStyle: GoogleFonts.openSans(
                fontSize: 14, color: AppColor.headingColor, fontWeight: FontWeight.w600),
            prefixIcon: const Icon(
              Icons.email_rounded,
              color: AppColor.primaryColor,
            ),
            suffixIcon: const Icon(
              Icons.lock,
              color: AppColor.primaryColor,
            ),
            floatingLabelBehavior: FloatingLabelBehavior.always,
            hintMaxLines: 1,
            contentPadding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
            errorStyle: const TextStyle(fontSize: 16.0),
          ),
        ),
      );
    });
  }
}
