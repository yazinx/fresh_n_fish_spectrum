import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../models/favorite_model.dart';
import '../models/product-model.dart';

class FavouriteProduct extends GetxController {
  RxBool loading = false.obs;
  void updateLoading(){
    loading.toggle();
  }
  Future<void> checkFavouriteItemExistence(
      {required String uId,
      int quantityIncrement = 1,
      required ProductModel productModel}) async {
    final DocumentReference documentReference = FirebaseFirestore.instance
        .collection('favorite')
        .doc(uId)
        .collection('favoriteItems')
        .doc(productModel.productId.toString());

    DocumentSnapshot snapshot = await documentReference.get();

    if (snapshot.exists) {
      int currentQuantity = snapshot['productQuantity'];
      int updatedQuantity = currentQuantity + quantityIncrement;
      double totalPrice = double.parse(productModel.isSale
              ? productModel.salePrice
              : productModel.fullPrice) *
          updatedQuantity;

      await documentReference.update({
        'productQuantity': updatedQuantity,
        'productTotalPrice': totalPrice
      });
      Get.snackbar("product exists", "update quantity");
      print("product exists");
    } else {
      await FirebaseFirestore.instance.collection('cart').doc(uId).set(
        {
          'uId': uId,
          'createdAt': DateTime.now(),
        },
      );

      FavoriteModel favoriteModel = FavoriteModel(
        productId: productModel.productId,
        categoryId: productModel.categoryId,
        productName: productModel.productName,
        categoryName: productModel.categoryName,
        salePrice: productModel.salePrice,
        fullPrice: productModel.fullPrice,
        productImages: productModel.productImages,
        deliveryTime: productModel.deliveryTime,
        isSale: productModel.isSale,
        productDescription: productModel.productDescription,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        productQuantity: 1,
        productTotalPrice: double.parse(productModel.isSale
            ? productModel.salePrice
            : productModel.fullPrice),
      );

      await documentReference.set(favoriteModel.toMap());

      print("product added");
      Get.snackbar("Success", "product added");
    }
  }
}
