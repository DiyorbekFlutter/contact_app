import 'package:flutter/material.dart';

void snackBar(BuildContext context, String text){
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(text),
      behavior: SnackBarBehavior.floating,
      dismissDirection: DismissDirection.horizontal,
      margin: EdgeInsets.only(
        left: 20,
        right: 20,
        bottom: MediaQuery.of(context).size.height - 200
      )
    )
  );
}