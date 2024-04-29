import 'package:contact_app/functions/snack_bar.dart';
import 'package:contact_app/pages/main_page.dart';
import 'package:contact_app/services/hive_service.dart';
import 'package:contact_app/services/shared_prereferences_service.dart';
import 'package:email_otp/email_otp.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pinput/pinput.dart';

class Confirmation extends StatefulWidget {
  final String email;
  final EmailOTP emailOTP;
  const Confirmation({super.key, required this.emailOTP, required this.email});

  @override
  State<Confirmation> createState() => _ConfirmationState();
}
class _ConfirmationState extends State<Confirmation> {
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Confirmation', style: TextStyle(fontWeight: FontWeight.bold)),
        foregroundColor: Colors.white,
        backgroundColor: Colors.blue,
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Verification', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text('Emailingizga tasdiqlash kodini yubordik. Email: ${widget.email}', textAlign: TextAlign.center),
          ),
          const SizedBox(height: 20),
          Center(
            child: Pinput(
              length: 5,
              inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[0-9]'))],
              controller: controller,
            ),
          ),
          const SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ElevatedButton(
              onPressed: () async {
                if(await widget.emailOTP.verifyOTP(otp: controller.text.trim())){


                  // HiveService.storage(HiveStorageKey.registered, true);
                  SharedPreferencesService.storageString(SharedPreferencesStorageKey.registered, "true");

                  if(!context.mounted) return;
                  Navigator.push(context, CupertinoPageRoute(builder: (context) => const MainPage()));
                } else {
                  if(!context.mounted) return;
                  snackBar(context, "Invalid OTP");
                }
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 55),
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              ),
              child: const Text('Tasdiqlash', style: TextStyle(color: Colors.white, fontSize: 20)),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(width: 40),
              InkWell(
                onTap: () {
                  Future.delayed(const Duration(milliseconds: 200)).then((value) => Navigator.of(context).pop());
                },
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                child: const Text('Emailni o\'zgartirish', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey)),
              )
            ],
          )
        ],
      ),
    );
  }
}
