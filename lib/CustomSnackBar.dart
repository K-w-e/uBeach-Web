import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomSnackBar {
  CustomSnackBar._();
  static buildErrorSnackbar(BuildContext context, String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        message,
        style: TextStyle(color: Colors.white),
      ),
      backgroundColor: color,
      //behavior: SnackBarBehavior.floating,
      /*shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
        )*/
    ));
  }
}
