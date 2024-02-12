import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
class Utilis{

  void toastMessage(String message){
         Fluttertoast.showToast(
             msg: message,
             toastLength: Toast.LENGTH_SHORT,
             gravity: ToastGravity.BOTTOM,
             timeInSecForIosWeb: 1,
             backgroundColor: Colors.green,
             textColor: Colors.white,
             fontSize: 15,
         );
  }





}