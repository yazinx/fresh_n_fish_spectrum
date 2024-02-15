import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fresh_n_fish_spectrum/view/main-page.dart';
import 'package:fresh_n_fish_spectrum/view/screens/orders-screen.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../controller/get-user-data-controller.dart';
import '../../controller/get-whatsappmsg-controller.dart';
import '../../utils/app-constant.dart';
import '../auth_ui/welcome_screen.dart';
import 'contact-us.dart';


class DrawerWidget extends StatefulWidget {
  const DrawerWidget({super.key});

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  final GetUserDataController _getUserDataController =
      Get.put(GetUserDataController());
  final GetWhatsappMsg _getWhatsappMsg = Get.put(GetWhatsappMsg());
  User? user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return Drawer(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: const Radius.circular(20.0).r,
          bottomRight: const Radius.circular(20.0).r,
        ),
      ),
      child: Wrap(
        runSpacing: 10,
        children: [
          FutureBuilder<List<QueryDocumentSnapshot<Object?>>>(
            future: _getUserDataController.getUserData(user!.uid),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                // Return a loading indicator or placeholder widget
                return SizedBox(
                    width: 20.w,
                    height: 20.h,
                    child: Center(child: const CupertinoActivityIndicator()));
              } else if (snapshot.hasError) {
                // Handle error
                return Text('Error: ${snapshot.error}');
              } else {
                // Data has been loaded successfully
                List<QueryDocumentSnapshot<Object?>> data = snapshot.data!;

                // Rest of your widget tree using the 'data'

                return Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10.0, vertical: 20.0),
                  child: ListTile(
                    titleAlignment: ListTileTitleAlignment.center,
                    title: Text(
                      "${data.isNotEmpty ? data[0]['username'] : 'N/A'}",
                      style: TextStyle(
                        color: AppConstant.appTextColor,
                        fontFamily: 'Roboto-Regular',
                        fontSize: 15.sp,
                      ),
                    ),
                    subtitle: Text(
                      "${data.isNotEmpty ? data[0]['email'] : 'N/A'}",
                      style: TextStyle(
                          color: AppConstant.appTextColor,
                          fontFamily: 'Roboto-Regular',
                          fontSize: 10.sp),
                    ),
                    leading: CircleAvatar(
                        radius: 22.0,
                        backgroundColor: AppConstant.appMainColor,
                        child: Image.network("${data[0]['userImg']}")),
                  ),
                );
              }
            },
          ),
          Divider(
            indent: 10.0,
            endIndent: 10.0,
            thickness: 1.5,
            color: Colors.grey,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: ListTile(
              titleAlignment: ListTileTitleAlignment.center,
              title: Text(
                "Home",
                style: TextStyle(color: AppConstant.appTextColor),
              ),
              leading: Icon(
                Icons.home,
                color: AppConstant.appTextColor,
              ),
              trailing: Icon(
                Icons.arrow_forward,
                color: AppConstant.appTextColor,
              ),
              onTap: () {
                Get.off(() => MainPage());
                Navigator.of(context).pop();
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: ListTile(
              titleAlignment: ListTileTitleAlignment.center,
              title: Text(
                "Message",
                style: TextStyle(color: AppConstant.appTextColor),
              ),
              leading: Icon(
                Icons.message,
                color: AppConstant.appTextColor,
              ),
              trailing: Icon(
                Icons.arrow_forward,
                color: AppConstant.appTextColor,
              ),
              onTap: () {
                _getWhatsappMsg.sendWhatsappMsg();
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: ListTile(
              titleAlignment: ListTileTitleAlignment.center,
              title: Text(
                "Orders",
                style: TextStyle(color: AppConstant.appTextColor),
              ),
              leading: Icon(
                Icons.shopping_bag,
                color: AppConstant.appTextColor,
              ),
              trailing: Icon(
                Icons.arrow_forward,
                color: AppConstant.appTextColor,
              ),
              onTap: () {
                Get.off(() => OrdersPage());
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: ListTile(
              titleAlignment: ListTileTitleAlignment.center,
              title: Text(
                "Contact",
                style: TextStyle(color: AppConstant.appTextColor),
              ),
              leading: Icon(
                Icons.help,
                color: AppConstant.appTextColor,
              ),
              trailing: Icon(
                Icons.arrow_forward,
                color: AppConstant.appTextColor,
              ),
              onTap: () {
                ContactUsDialog.showContactUsDialog(context);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: ListTile(
              onTap: () async {
                GoogleSignIn googleSignIn = GoogleSignIn();
                FirebaseAuth _auth = FirebaseAuth.instance;
                await _auth.signOut();
                await googleSignIn.signOut();
                Get.offAll(() => WelcomeScreen());
              },
              titleAlignment: ListTileTitleAlignment.center,
              title: Text(
                "Logout",
                style: TextStyle(color: AppConstant.appTextColor),
              ),
              leading: Icon(
                Icons.logout,
                color: AppConstant.appTextColor,
              ),
              trailing: Icon(
                Icons.arrow_forward,
                color: AppConstant.appTextColor,
              ),
            ),
          ),
        ],
      ),
      backgroundColor: AppConstant.appScendoryColor,
    );
  }
}
