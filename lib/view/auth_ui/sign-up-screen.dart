import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fresh_n_fish_spectrum/view/auth_ui/sentopt.dart';
import 'package:fresh_n_fish_spectrum/view/auth_ui/welcome_screen.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../controller/email-sign-in-controller.dart';
import '../../controller/google-sign-in-controller.dart';
import '../../services/validator/validator.dart';
import '../../utils/app-constant.dart';
import 'email_validation.dart';
import 'forgot_password_screen.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();
  final _nameTextController = TextEditingController();
  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();
  final GoogleSignInController _googleSignInController =
      Get.put(GoogleSignInController());
  final EmailPassController _emailPassController =
      Get.put(EmailPassController());
  Widget getTextField(
      {required String hint,
      required var icons,
        bool obstxt = null ?? false,
      var suficons,
      required var validator,
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
            child: Column(children: [
              Container(
                margin: const EdgeInsets.only(top: 70.0).w,
                child: Column(children: [
                  Text(
                    'Create Account',
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
                    'Create an account so you can \n explore all the existing jobs',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontFamily: 'Poppins',
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
                              keyboardType: TextInputType.text,
                              hint: "Name",
                              icons: const Icon(Icons.person_outline),
                              validator: (value) => Validator.validateName(
                                    name: value,
                                  ),
                              controller: _nameTextController),
                          SizedBox(
                            height: 26.h,
                          ),
                          getTextField(
                              keyboardType: TextInputType.emailAddress,
                              hint: "Email",
                              icons: const Icon(Icons.email),
                              validator: (value) => Validator.validateEmail(
                                    email: value,
                                  ),
                              controller: _emailTextController),
                          SizedBox(
                            height: 26.h,
                          ),
                          Obx(() => getTextField(
                                obstxt: _emailPassController.passwordVisible.value,
                                suficons: IconButton(
                                  onPressed: () {
                                    _emailPassController
                                        .updateVisibility(); // Use the controller method to toggle visibility
                                  },
                                  icon: Icon(
                                      _emailPassController.passwordVisible.value
                                          ? Icons.visibility
                                          : Icons.visibility_off),
                                ),
                                keyboardType: TextInputType.visiblePassword,
                                hint: "Password",
                                icons: const Icon(Icons.lock),
                                validator: (value) =>
                                    Validator.validatePassword(
                                  password: value,
                                ),
                                controller: _passwordTextController,
                              )),
                          SizedBox(
                            height: 15.h,
                          ),
                          Obx(() => SizedBox(
                              width: 357.w,
                              height: 50.h,
                              child: ElevatedButton(
                                style: ButtonStyle(
                                    shape: MaterialStatePropertyAll(
                                        RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(9.r))),
                                    backgroundColor:
                                        const MaterialStatePropertyAll(
                                            Color(0xFF1F41BB))),
                                onPressed: () async {
                                  if (_formKey.currentState!.validate()) {
                                    _emailPassController.updateLoading();
                                    try {
                                      await _emailPassController.signupUser(
                                        _emailTextController.text,
                                        _passwordTextController.text,
                                        _nameTextController.text,
                                      );
                                      if (_emailPassController.currentUser !=
                                          null) {
                                        Get.off(
                                            () => EmailValidationScreen(
                                                user: _emailPassController
                                                    .currentUser!),
                                            transition:
                                                Transition.leftToRightWithFade);
                                      } else {
                                        // No user is currently authenticated
                                        Get.snackbar('No user is',
                                            'currently authenticated');
                                      }
                                    } catch (e) {
                                      Get.snackbar('Error', e.toString());
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
                                        'Sign Up',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: AppConstant.appTextColor,
                                          fontSize: 20.sp,
                                          height: 0.h,
                                          fontFamily: 'Roboto-Bold',
                                        ),
                                      ),
                              ))),
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
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
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
                    onTap: () => Get.to(() => const SendOtp()),
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
