import 'package:flutter/material.dart';

class ContactUsDialog {
  static void showContactUsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Contact Us"),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("For any inquiries or assistance, please contact us:"),
              SizedBox(height: 10),
              Text("Email: support@spectrum.net.in"),
              Text("Phone: +0484 408 2000"),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text("Close"),
            ),
          ],
        );
      },
    );
  }
}
