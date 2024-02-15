import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fresh_n_fish_spectrum/view/auth_ui/sentopt.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../controller/verify-phone-controller.dart';
import '../../utils/app-constant.dart';



class VerifyOtp extends StatefulWidget {
  final String verificationId;
  const VerifyOtp({Key? key, required this.verificationId}) : super(key: key);

  @override
  State<VerifyOtp> createState() => _VerifyOtpState();
}

class _VerifyOtpState extends State<VerifyOtp> {
  final TextEditingController _otpController = TextEditingController();
  final SentOtpController _sentOtpController = Get.put(SentOtpController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppConstant.appScendoryColor,
        appBar: AppBar(

          backgroundColor: AppConstant.appScendoryColor,
          elevation: 0,
          leading: IconButton(onPressed: () => Get.offAll(() => const SendOtp(),
              transition: Transition.leftToRightWithFade), icon: Icon(CupertinoIcons.back,color: Colors.white)),
          centerTitle: true,
          title:Text("Verify OTP", style: TextStyle(
            color: Colors.white,
            fontSize: 18.sp,
            fontFamily: 'Roboto-Bold',
          )),
        ),
        body: SingleChildScrollView(
          child: Container(
            width: Get.width,
            height: Get.height,
            alignment: Alignment.center,
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Enter the OTP sent to your phone",
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Roboto-Regular',
                    fontSize: 15.sp,
                    height: 0.h,
                  ),
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  decoration: InputDecoration(
                      errorStyle: const TextStyle(
                        color: Colors.yellow,
                        fontSize: null,
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.normal,
                      ),
                      prefixIcon: Icon(Icons.verified_user),
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
                      hintText: "Enter OTP here",
                      hintStyle: TextStyle(
                        color: Colors.black54,
                        fontFamily: 'Roboto-Regular',
                        fontSize: 15.sp,
                        height: 0.h,
                      )),
                  controller: _otpController,
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 16.0),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: const MaterialStatePropertyAll(
                      AppConstant.btnColor,
                    ),
                    overlayColor: MaterialStateProperty.all(
                        AppConstant.btnColor),
                    shape: MaterialStatePropertyAll(
                        RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.circular(9.r))),
                  ),
                  onPressed: () {
                    // Call your verification function from the controller
                    // Pass the entered OTP and verification ID
                    _sentOtpController.verifyOtp(_otpController.text, widget.verificationId);
                  },
                  child: Text("Verify OTP", style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.sp,
                    fontFamily: 'Roboto-Bold',
                  )),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}