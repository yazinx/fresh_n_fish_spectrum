import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../controller/get-category-products-controller.dart';
import '../../models/product-model.dart';
import '../../utils/app-constant.dart';
import '../main-page.dart';
import 'product-deatils-screen.dart';

class AllSingleCategoryProductsScreen extends StatefulWidget {
  String categoryId;
  AllSingleCategoryProductsScreen({super.key, required this.categoryId});

  @override
  State<AllSingleCategoryProductsScreen> createState() =>
      _AllSingleCategoryProductsScreenState();
}

class _AllSingleCategoryProductsScreenState
    extends State<AllSingleCategoryProductsScreen> {
  final GetCategoryProductDataController _getCategoryProductDataController =
      Get.put(GetCategoryProductDataController());
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppConstant.appMainColor,
          elevation: 2,
          leading: IconButton(
              onPressed: () => Get.offAll(() => const MainPage(),
                  transition: Transition.leftToRightWithFade),
              icon: Icon(CupertinoIcons.back, color: Colors.white)),
          centerTitle: true,
          title: Text("Category product screen",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.sp,
                fontFamily: 'Roboto-Regular',
              )),
        ),
        body: Container(
          width: Get.width,
          height: Get.height,
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FutureBuilder<List<QueryDocumentSnapshot<Object?>>>(
                future: _getCategoryProductDataController.getCategoryProductData(widget.categoryId),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    // Return a loading indicator or placeholder widget
                    return SizedBox(
                        width: 20.w,
                        height: 20.h,
                        child:
                            const Center(child: CircularProgressIndicator()));
                  } else if (snapshot.hasError) {
                    // Handle error
                    return Text('Error: ${snapshot.error}');
                  } else {
                    // Data has been loaded successfully
                    List<QueryDocumentSnapshot<Object?>> data = snapshot.data!;
                    int dataLength = data.length;

                    // Rest of your widget tree using the 'data'

                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GridView.builder(
                        itemCount: dataLength,
                        shrinkWrap: true,
                        physics: const BouncingScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 5,
                          crossAxisSpacing: 5,
                          childAspectRatio: 0.80,
                        ),
                        itemBuilder: (context, index) {
                          final productData = data[index];
                          ProductModel productModel = ProductModel(
                            productId: productData['productId'],
                            categoryId: productData['categoryId'],
                            productName: productData['productName'],
                            categoryName: productData['categoryName'],
                            salePrice: productData['salePrice'].toString(),
                            fullPrice: productData['fullPrice'].toString(),
                            productImages: productData['productImages'],
                            deliveryTime: productData['deliveryTime'],
                            isSale: productData['isSale'],
                            productDescription: productData['productDescription'],
                            createdAt: productData['createdAt'],
                            updatedAt: productData['updatedAt'],
                          );
                          return Container(
                            decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.black26,
                                  width: 2.0.w,
                                ),
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15.r),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.grey.withOpacity(.5),
                                      offset: const Offset(3, 2),
                                      blurRadius: 7.r)
                                ]),
                            child: Column(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Get.to(() => ProductDetailsScreen(
                                        productModel: productModel));
                                  },
                                  child: SizedBox(
                                    width: 150.w,
                                    height: 150.h,
                                    child: Padding(
                                      padding: EdgeInsets.all(13.0.w),
                                      child: Image.network(
                                        productModel.productImages[0],
                                        width: double.infinity,
                                      ),
                                    ),
                                  ),
                                ),
                                Flexible(
                                  child: Text(
                                    "${productModel.productName}",
                                    style: TextStyle(
                                        color: const Color(0xFF505050),
                                        fontFamily: 'Poppins',
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                                SizedBox(
                                  height: 10.h,
                                ),
                                Flexible(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(left: 13.0.w),
                                        child: Text(
                                          ' ₹ ${productModel.fullPrice}',
                                          style: TextStyle(
                                              color: const Color(0xFFCF1919),
                                              fontFamily: 'Poppins',
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.w400),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 30.w,
                                      ),
                                      Flexible(
                                        child: CircleAvatar(
                                          radius: 20.0,
                                          backgroundColor:
                                              const Color(0xFF660018),
                                          child: IconButton(
                                              icon: const Icon(
                                                  Icons.add_shopping_cart,
                                                  color: Colors.white),
                                              onPressed: () async {}),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
