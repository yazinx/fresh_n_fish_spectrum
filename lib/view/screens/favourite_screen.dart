import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_swipe_action_cell/core/cell.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../../controller/get-favourite-products.dart';
import '../../models/favorite_model.dart';
import '../../utils/app-constant.dart';
import '../main-page.dart';

class FavouriteScreen extends StatefulWidget {
  const FavouriteScreen({super.key});

  @override
  State<FavouriteScreen> createState() => _FavouriteScreenState();
}

class _FavouriteScreenState extends State<FavouriteScreen> {
  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppConstant.appMainColor,
          elevation: 2,
          leading: IconButton(
              onPressed: () => Get.offAll(() => const MainPage(),
                  transition: Transition.leftToRightWithFade),
              icon: const Icon(CupertinoIcons.back, color: Colors.white)),
          centerTitle: true,
          title: Text("Favourite Page",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.sp,
                fontFamily: 'Roboto-Regular',
              )),
        ),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('favorite')
              .doc(user!.uid)
              .collection('favoriteItems')
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text("Error"),
              );
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Container(
                height: Get.height / 5,
                child: const Center(
                  child: CupertinoActivityIndicator(),
                ),
              );
            }
      
            if (snapshot.data!.docs.isEmpty) {
              return Center(
                child: Text("No products found!"),
              );
            }
      
            if (snapshot.data != null) {
              return Container(
                child: ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  shrinkWrap: true,
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    final productData = snapshot.data!.docs[index];
                    FavoriteModel favoriteModel = FavoriteModel(
                      productId: productData['productId'],
                      categoryId: productData['categoryId'],
                      productName: productData['productName'],
                      categoryName: productData['categoryName'],
                      salePrice: productData['salePrice'],
                      fullPrice: productData['fullPrice'],
                      productImages: productData['productImages'],
                      deliveryTime: productData['deliveryTime'],
                      isSale: productData['isSale'],
                      productDescription: productData['productDescription'],
                      createdAt: productData['createdAt'],
                      updatedAt: productData['updatedAt'],
                      productQuantity: productData['productQuantity'],
                      productTotalPrice: double.parse(
                          productData['productTotalPrice'].toString()),
                    );
                    return SwipeActionCell(
                      key: ObjectKey(favoriteModel.productId),
                      trailingActions: [
                        SwipeAction(
                          title: "Delete",
                          forceAlignmentToBoundary: true,
                          performsFirstActionWithFullSwipe: true,
                          onTap: (CompletionHandler handler) async {
                            print('deleted');
      
                            await FirebaseFirestore.instance
                                .collection('favorite')
                                .doc(user!.uid)
                                .collection('favoriteItems')
                                .doc(favoriteModel.productId)
                                .delete();
                          },
                        )
                      ],
                      child: Card(
                        elevation: 5,
                        color: AppConstant.appTextColor,
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: AppConstant.appMainColor,
                            backgroundImage:
                            NetworkImage(favoriteModel.productImages[0]),
                          ),
                          title: Text(favoriteModel.productName),
                          subtitle: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(favoriteModel.productTotalPrice.toString()),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            }
      
            return Container();
          },
        ),
      ),
    );
  }
}