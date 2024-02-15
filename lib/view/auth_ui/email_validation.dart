import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fresh_n_fish_spectrum/view/auth_ui/welcome_screen.dart';

import 'package:get/get.dart';

import '../../controller/email-validation-controller.dart';
import '../../utils/app-constant.dart';
import '../main-page.dart';

class EmailValidationScreen extends StatefulWidget {
  final User user;
  const EmailValidationScreen({super.key, required this.user});

  @override
  State<EmailValidationScreen> createState() => _EmailValidationScreenState();
}

class _EmailValidationScreenState extends State<EmailValidationScreen> {
  bool _isSendingVerification = false;
  bool _isSigningOut = false;
  final EmailValidationController _emailValidationController =
      Get.put(EmailValidationController());
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppConstant.appScendoryColor,
        body: SizedBox(
          width: Get.width,
          height: Get.height,
          child: Column(children: [
            SizedBox(
              height: 10.h,
            ),
            Center(
              child: Text(
                'Verify your email address',
                style: TextStyle(
                  fontFamily: 'Roboto-Bold',
                  fontSize: 18.sp,
                  color: AppConstant.yellowText,
                ),
              ),
            ),
            SizedBox(
              height: 10.h,
            ),
            Center(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey,
                    width: 1.0,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 10.h,
                    ),
                    Text(
                      'Name: ${widget.user.displayName}',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontFamily: 'Roboto-Regular',
                        fontWeight: FontWeight.w400,
                        color: AppConstant.appTextColor,
                      ),
                    ),
                    SizedBox(
                      height: 5.h,
                    ),
                    Text(
                      'Email: ${widget.user.email}',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontFamily: 'Roboto-Regular',
                        color: AppConstant.appTextColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 30.h,
            ),
            widget.user.emailVerified
                ? Center(
                    child: Text(
                      'Email is verified',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontFamily: 'Roboto-Regular',
                        color: Colors.lightGreenAccent,
                      ),
                    ),
                  )
                : Center(
                    child: Text(
                      'Email is not verified',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontFamily: 'Roboto-Regular',
                        color: Colors.red,
                      ),
                    ),
                  ),
            SizedBox(
              height: 30.h,
            ),
            _isSendingVerification
                ? const Center(child: CircularProgressIndicator())
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Color(0xFF1F41BB)),
                          ),
                          onPressed: () async {
                            setState(() {
                              _isSendingVerification = true;
                            });
                            await _emailValidationController
                                .sendingEmailVerification(widget.user);
                            setState(() {
                              _isSendingVerification = false;
                            });
                          },
                          child: Text(
                            'Verify',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14.sp,
                              fontFamily: 'Roboto-Regular',
                              fontWeight: FontWeight.w400,
                              height: 0.h,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 30.w,
                      ),
                      TextButton.icon(
                        // <-- TextButton
                        onPressed: () async {
                          try {
                            User? user = await _emailValidationController
                                .refreshEmail(widget.user);
                            if (user != null && user.emailVerified) {
                              Get.snackbar('Success : ',
                                  'Email has been verified successfully');
                              Get.off(const MainPage(),
                                  transition: Transition.leftToRightWithFade);
                            } else {
                              Get.snackbar('Failed : ',
                                  'Email has been not verified check your mail');
                            }
                          } catch (e) {}
                        },
                        icon: const Icon(
                          Icons.refresh,
                          size: 24.0,
                          color: Color(0xFF1F41BB),
                        ),
                        label: Text(
                          'Check',
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontFamily: 'Roboto-Regular',
                            color: AppConstant.appTextColor,
                          ),
                        ),
                      ),
                    ],
                  ),
            SizedBox(height: 36.h),
            _isSigningOut
                ? const Center(child: CircularProgressIndicator())
                : Center(
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.grey),
                      ),
                      onPressed: () async {
                        setState(() {
                          _isSigningOut = true;
                        });
                        await FirebaseAuth.instance.signOut();
                        setState(() {
                          _isSigningOut = false;
                          Get.off(const WelcomeScreen(),
                              transition: Transition.rightToLeftWithFade);
                        });
                      },
                      child: Text(
                        'Sign out',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14.sp,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400,
                          height: 0.h,
                        ),
                      ),
                    ),
                  ),
          ]),
        ),
      ),
    );
  }
}
