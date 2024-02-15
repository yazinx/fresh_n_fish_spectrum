import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fresh_n_fish_spectrum/view/auth_ui/sentopt.dart';
import 'package:fresh_n_fish_spectrum/view/auth_ui/welcome_screen.dart';
import 'package:get/get.dart';
import 'package:get/route_manager.dart';

import '../../controller/email-sign-in-controller.dart';
import '../../controller/google-sign-in-controller.dart';
import '../../services/validator/validator.dart';
import '../../utils/app-constant.dart';
import '../main-page.dart';
import 'forgot_password_screen.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final _formKey = GlobalKey<FormState>();
  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();
  get passwordTextController => _passwordTextController;

  get emailTextController => _emailTextController;
  final EmailPassController _emailPassController =
      Get.put(EmailPassController());
  final GoogleSignInController _googleSignInController =
      Get.put(GoogleSignInController());
  Widget getTextField(
      {required String hint,
        bool obstxt = null ?? false,
      var suficons,
      required var validator,
      required var icons,
      required var controller,
      required var keyboardType}) {
    return TextFormField(
      obscureText: obstxt,
      keyboardType: keyboardType,
      validator: validator,
      controller: controller,
      decoration: InputDecoration(
          suffixIcon: suficons,
          errorStyle: const TextStyle(
            color: Colors.yellow,
            fontSize: null,
            fontWeight: FontWeight.w400,
            fontStyle: FontStyle.normal,
          ),
          prefixIcon: icons,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.r),
            borderSide: const BorderSide(color: Colors.transparent),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.r),
            borderSide: const BorderSide(color: Colors.transparent),
          ),
          contentPadding:
              EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
          filled: true,
          fillColor: const Color(0xFFF1F4FF),
          hintText: hint,
          hintStyle: TextStyle(
            color: Colors.black54,
            fontFamily: 'Roboto-Regular',
            fontSize: 15.sp,
            height: 0.h,
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppConstant.appScendoryColor,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: AppConstant.appScendoryColor,
          elevation: 0,
          leading: IconButton(
              onPressed: () => Get.offAll(() => const WelcomeScreen(),
                  transition: Transition.leftToRightWithFade),
              icon: const Icon(CupertinoIcons.back, color: Colors.white)),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: SizedBox(
            width: Get.width,
            height: Get.height,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 50.0).w,
                    width: MediaQuery.of(context).size.width,
                    child: Column(children: [
                      Text(
                        'Login here',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppConstant.yellowText,
                          fontSize: 30.sp,
                          fontFamily: 'Roboto-Bold',
                        ),
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      const Text(
                        'Welcome back you’ve been missed!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontFamily: 'Roboto-Regular',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ]),
                  ),
                  Expanded(
                    child: Center(
                      child: Form(
                        key: _formKey,
                        child: SizedBox(
                          width: 323.w,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              getTextField(
                                  hint: "Email",
                                  icons: const Icon(Icons.email),
                                  validator: (value) => Validator.validateEmail(
                                        email: value,
                                      ),
                                  controller: _emailTextController,
                                  keyboardType: TextInputType.emailAddress),
                              SizedBox(
                                height: 26.h,
                              ),
                              Obx(() => getTextField(
                                obstxt: _emailPassController.passwordVisible.value,
                                suficons: IconButton(
                                  onPressed: () {
                                    _emailPassController.updateVisibility(); // Use the controller method to toggle visibility
                                  },
                                  icon: Icon(_emailPassController.passwordVisible.value
                                      ? Icons.visibility
                                      : Icons.visibility_off),
                                ),
                                keyboardType: TextInputType.visiblePassword,
                                hint: "Password",
                                icons: const Icon(Icons.lock),
                                validator: (value) => Validator.validatePassword(
                                  password: value,
                                ),
                                controller: _passwordTextController,
                              )),
                              SizedBox(
                                height: 15.h,
                              ),
                              Container(
                                alignment: Alignment.topRight,
                                child: TextButton(
                                  onPressed: () {
                                    Get.offAll(() => const ForgotPasswordPage(),
                                        transition:
                                            Transition.leftToRightWithFade);
                                  },
                                  child: Text(
                                    'Forgot your password?',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontFamily: 'Roboto-Regular',
                                      color: AppConstant.appTextColor,
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w600,
                                      height: 0.h,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 15.h,
                              ),
                              Obx(() =>  SizedBox(
                                  width: 357.w,
                                  height: 50.h,
                                  child: ElevatedButton(
                                    style: ButtonStyle(
                                        shape: MaterialStatePropertyAll(
                                            RoundedRectangleBorder(
                                                borderRadius:
                                                BorderRadius.circular(
                                                    9.r))),
                                        backgroundColor:
                                        const MaterialStatePropertyAll(
                                            Color(0xFF1F41BB))),
                                    onPressed: () async {
                                      if (_formKey.currentState!.validate()) {
                                        _emailPassController.updateLoading();
                                        try {
                                          UserCredential? userCredential =
                                          await _emailPassController
                                              .signinUser(
                                            _emailTextController.text,
                                            _passwordTextController.text,
                                          );
                                          if (userCredential!
                                              .user!.emailVerified) {
                                            final user = userCredential.user;
                                            Get.off(() => const MainPage(),
                                                transition: Transition
                                                    .leftToRightWithFade);
                                          }
                                        } catch (e) {
                                          print(e);
                                        } finally {
                                          _emailPassController.updateLoading();
                                        }
                                      }
                                    },
                                    child: _emailPassController.loading.value
                                        ? const CircularProgressIndicator(
                                      color: Colors.white,
                                    )
                                        : Text(
                                      'Sign in',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: AppConstant.appTextColor,
                                        fontSize: 20.sp,
                                        height: 0.h,
                                        fontFamily: 'Roboto-Bold',
                                      ),
                                    ),
                                  )))

                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    margin: const EdgeInsets.only(bottom: 90.0).w,
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              _googleSignInController.signInWithGoogle();
                            },
                            child: SizedBox(
                              width: 60.w,
                              height: 44.h,
                              child: SvgPicture.asset(
                                  'assets/images/flat-color-icons_google.svg'),
                            ),
                          ),
                          SizedBox(
                            width: 10.w,
                          ),
                          GestureDetector(
                            onTap: () => Get.to(() => SendOtp()),
                            child: SizedBox(
                              width: 60.w,
                              height: 44.h,
                              child: SvgPicture.asset(
                                  'assets/images/ic_sharp-local-phone.svg'),
                            ),
                          ),
                        ]),
                  ),
                ]),
          ),
        ),
      ),
    );
  }
}
