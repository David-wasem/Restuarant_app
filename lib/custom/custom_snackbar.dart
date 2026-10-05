
import 'package:flutter/material.dart';

SnackBar CustomSnackBar({required String message,required Color backgroundColor}) {
  return SnackBar(
    content: Text(message),
    backgroundColor: backgroundColor,
    behavior: SnackBarBehavior.floating,
    margin: EdgeInsets.only(bottom: 20, left: 20, right: 20),
    duration: Duration(seconds: 3),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
    showCloseIcon: true,
  );
}