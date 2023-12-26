import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sales_app/Core/utils/my_colors.dart';

void showToast({required String message,  Color? backgroundColor }) {
  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.CENTER_LEFT,
    timeInSecForIosWeb: 1,
    backgroundColor: backgroundColor ?? MyColors.myBlack,
    textColor: Colors.white,
    fontSize: 16.0,
    webPosition: 'center',
  );
}
