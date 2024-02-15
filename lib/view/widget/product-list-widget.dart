import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../../controller/get-cart-product-controller.dart';
import '../../controller/get-product-data-controller.dart';
import '../../models/product-model.dart';
import '../screens/product-deatils-screen.dart';

class GetProductWidget extends StatefulWidget {
  const GetProductWidget({super.key});

  @override
  State<GetProductWidget> createState() => _GetProductWidgetState();
}

class _GetProductWidgetState extends State<GetProductWidget> {
  final GetProductDataController _getProductDataController =
  Get.put(GetProductDataController());
  User? user = FirebaseAuth.instance.currentUser;
  final CartItemController _CartItemController = Get.put(CartItemController());
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<QueryDocumentSnapshot<Object?>>>(
      future: _getProductDataController.getProductData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Return a loading indicator or placeholder widget
          return SizedBox(
              width: 20.w,
              height: 20.h,
              child: const Center(child: CupertinoActivityIndicator()));
        } else if (snapshot.hasError) {
          // Handle error
          return Text('Error: ${snapshot.error}');
        } else {
          // Data has been loaded successfully
          List<QueryDocumentSnapshot<Object?>> data = snapshot.data!;
          int dataLength = data.length;

          // Rest of your widget tree using the 'data'

          return GridView.builder(
            itemCount: dataLength,
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
                        Get.to(()=>ProductDetailsScreen(productModel: productModel));
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                              backgroundColor: const Color(0xFF660018),
                              child: IconButton(
                                  icon: const Icon(Icons.add_shopping_cart,
                                      color: Colors.white),
                                  onPressed: () async {
                                    await _CartItemController
                                        .checkProductExistence(
                                        uId: user!.uid,
                                        productModel: productModel);
                                  }),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        }
      },
    );
  }
}