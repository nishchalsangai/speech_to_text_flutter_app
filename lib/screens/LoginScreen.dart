import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ninjastudytask/constants/colors.dart';
import 'package:ninjastudytask/constants/mixins.dart';
import 'package:ninjastudytask/screens/RegisterScreen.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../managers/AuthManager/AuthManager.dart';

class LogInScreen extends StatelessWidget with ValidateMixin {
  const LogInScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthManager>(builder: (context, authManager, child) {
      return Scaffold(
        backgroundColor: Colors.grey.shade100,
        body: SafeArea(
          child: Form(
              key: authManager.loginKey,
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
                        "LOGIN",
                        style: GoogleFonts.openSans(
                            fontSize: 30.sp,
                            color: AppColor.headingColor,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 70.h,
                      ),
                      emailHandler(),
                      SizedBox(
                        height: 20.h,
                      ),
                      passwordHandler(),
                      SizedBox(
                        height: 30.h,
                      ),
                      ElevatedButton(
                          onPressed: () => authManager.signIn(context),
                          child: SizedBox(
                            height: 50.h,
                            width: double.infinity,
                            child: Center(
                              child: authManager.loading
                                  ? const CircularProgressIndicator(
                                      color: Colors.white,
                                    )
                                  : Text(
                                      "Sign in",
                                      style: GoogleFonts.openSans(
                                          fontSize: 16.sp,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600),
                                    ),
                            ),
                          )),
                      SizedBox(
                        height: 15.h,
                      ),
                      orDivider(),
                      SizedBox(
                        height: 15.h,
                      ),
                      TextButton(
                          onPressed: () {
                            Navigator.push(
                                context, MaterialPageRoute(builder: (_) => SignUpScreen()));

                            //  ChangeNotifierProvider(
                            //                                     create: (_) => AuthManager(), child: const SignUpScreen())
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "New to the app? ",
                                style: GoogleFonts.openSans(
                                    fontSize: 14.sp,
                                    color: AppColor.headingColor,
                                    fontWeight: FontWeight.w600),
                              ),
                              Text(
                                "Register here!",
                                style: GoogleFonts.openSans(
                                    fontSize: 14.sp,
                                    color: AppColor.primaryColor,
                                    fontWeight: FontWeight.w600),
                              )
                            ],
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
          padding: const EdgeInsets.symmetric(horizontal: 5.0),
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
          // validator: passwordValidator,
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
                fontSize: 14, color: AppColor.headingColor, fontWeight: FontWeight.w600),
            prefixIcon: const Icon(
              Icons.verified_user,
              color: AppColor.primaryColor,
            ),
            floatingLabelBehavior: FloatingLabelBehavior.always,
            hintMaxLines: 1,
            contentPadding: EdgeInsets.symmetric(horizontal: 25.r, vertical: 15.r),
            errorStyle: TextStyle(fontSize: 12.0.sp),
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

  emailHandler() {
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
          keyboardType: TextInputType.emailAddress,
          controller: authManager.email,
          // validator: emailValidator,
          style: GoogleFonts.openSans(
              fontSize: 16.sp, color: AppColor.headingColor, fontWeight: FontWeight.w600),
          decoration: InputDecoration(
            filled: true,
            hintText: 'Email',
            fillColor: Colors.white,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16.r), borderSide: BorderSide.none),
            hintStyle: GoogleFonts.openSans(
                fontSize: 14.sp, color: AppColor.headingColor, fontWeight: FontWeight.w600),
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
            contentPadding: EdgeInsets.symmetric(horizontal: 25.r, vertical: 15.r),
            errorStyle: TextStyle(fontSize: 12.0.sp),
          ),
        ),
      );
    });
  }
}
