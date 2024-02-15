import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:fresh_n_fish_spectrum/view/screens/cart-screen.dart';
import 'package:fresh_n_fish_spectrum/view/screens/favourite_screen.dart';
import 'package:fresh_n_fish_spectrum/view/search-bar/user-serach-delegate.dart';
import 'package:fresh_n_fish_spectrum/view/widget/banner-widget.dart';
import 'package:fresh_n_fish_spectrum/view/widget/category-widget.dart';
import 'package:fresh_n_fish_spectrum/view/widget/custom-drawer-widget.dart';
import 'package:fresh_n_fish_spectrum/view/widget/product-list-widget.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../controller/get-user-data-controller.dart';
import '../controller/google-sign-in-controller.dart';
import '../utils/app-constant.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final GoogleSignInController _googleSignInController =
      Get.put(GoogleSignInController());
  final GetUserDataController _getUserDataController =
      Get.put(GetUserDataController());
  User? user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          actions: [

            Padding(
              padding: const EdgeInsets.only(right: 15),
              child: IconButton(
                  onPressed: () => Get.offAll(() => const FavouriteScreen(),
                      transition: Transition.leftToRightWithFade),
                  icon: const Icon(
                    Icons.favorite,
                    color: Colors.white,
                    size: 30,
                  )),
            ),Padding(
              padding: const EdgeInsets.only(right: 8),
              child: IconButton(
                  onPressed: () => Get.offAll(() => const CartPage(),
                      transition: Transition.leftToRightWithFade),
                  icon: const Icon(
                    CupertinoIcons.cart,
                    color: Colors.white,
                    size: 30,
                  )),
            )
          ],
          backgroundColor: AppConstant.appMainColor,
          title: FutureBuilder<List<QueryDocumentSnapshot<Object?>>>(
            future: _getUserDataController.getUserData(user!.uid),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                // Return a loading indicator or placeholder widget
                return const CupertinoActivityIndicator();
              } else if (snapshot.hasError) {
                // Handle error
                return Text('Error: ${snapshot.error}');
              } else {
                // Data has been loaded successfully
                List<QueryDocumentSnapshot<Object?>> data = snapshot.data!;

                // Rest of your widget tree using the 'data'

                return Text(
                    "Hi, ${data.isNotEmpty ? data[0]['username'] : 'N/A'}",
                    style: TextStyle(
                      color: AppConstant.appTextColor,
                      fontFamily: 'Roboto-Regular',
                      fontSize: 15.sp,
                      height: 0.h,
                    ));
              }
            },
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(105),
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(20.0),
                bottomRight: Radius.circular(20.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: GestureDetector(
                  onTap: () =>  showSearch(context: context, delegate: UserSearch()),
                  child: Container(

                    alignment: Alignment.center,
                    height: 50,
                    width: Get.width * 0.9,
                    color: Colors.white,
                    child: Row(children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(
                          CupertinoIcons.search,
                          color: Colors.black54,
                        ),
                      ),
                      Text(
                        "Search",
                        style: TextStyle(
                          color: Colors.black54,
                          fontFamily: 'Roboto-Regular',
                          fontSize: 15.sp,
                          height: 0.h,
                        ),
                      ),
                    ]),
                  ),
                ),
              ),
            ),
          ),
        ),
        drawer: const DrawerWidget(),
        body: SingleChildScrollView(
          child: Container(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Trending deals',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: const Color(0xFF494949),
                      fontSize: 14.sp,
                      fontFamily: 'Roboto-bold',
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 12),
                  child: BannerWidget(),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'All category',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: const Color(0xFF494949),
                      fontSize: 14.sp,
                      fontFamily: 'Roboto-bold',
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: CategoryWidget(),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'All products',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: const Color(0xFF494949),
                      fontSize: 14.sp,
                      fontFamily: 'Roboto-bold',
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: GetProductWidget(),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
