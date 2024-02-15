import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/product-model.dart';

class GetWhatsappMsg extends GetxController {
  sendWhatsappMsg() async {
    String phone = "919400377390";
    var message = "hai";
    var whatsappUrl =
        "whatsapp://send?phone=$phone&text=${Uri.encodeComponent(message)}";
    var uri = Uri.parse(whatsappUrl);

    await launchUrl(uri)
        ? launchUrl(uri)
        : print(
            "Open WhatsApp app link or show a snackbar with a notification that WhatsApp is not installed");
  }

  sendMessageOnWhatsApp({required ProductModel productModel}) async {
    String phone = "919400377390";
    var message =
        "\nI want to know about this product\nName :${productModel.productName}\nPrice :${productModel.fullPrice}";
    var whatsappUrl =
        "whatsapp://send?phone=$phone&text=${Uri.encodeComponent(message)}";
    var uri = Uri.parse(whatsappUrl);

    await launchUrl(uri)
        ? launchUrl(uri)
        : print(
            "Open WhatsApp app link or show a snackbar with a notification that WhatsApp is not installed");
  }
}
