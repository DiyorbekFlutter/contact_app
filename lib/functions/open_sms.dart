import 'package:contact_app/functions/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void openSMS(BuildContext context, String phoneNumber) async {
  String url = 'sms:$phoneNumber';
  // ignore: deprecated_member_use
  if (await canLaunch(url)) {
    // ignore: deprecated_member_use
    await launch(url);
  } else {
    if (!context.mounted) return;
    snackBar(context, "SMS ochish uchun URL ochilmadi: $url");
  }
}