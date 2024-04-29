import 'dart:ui';

import 'package:contact_app/functions/snack_bar.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:email_otp/email_otp.dart';

import 'confirmation.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  Country country = CountryParser.parseCountryCode("uz");
  final TextEditingController phoneNumber = TextEditingController();
  final TextEditingController email = TextEditingController();
  EmailOTP emailOTP = EmailOTP();
  bool inProgress = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Register", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),),
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),
      body: ListView(
        children: [
          const SizedBox(height: 50),
          const Center(
            child: CircleAvatar(
              radius: 50,
              foregroundImage: AssetImage('assets/images/logo.png'),
            ),
          ),
          const SizedBox(height: 60),
          const Center(
            child: Text(
              "Emailingizni tasdiqlang",
              style: TextStyle(fontWeight: FontWeight.bold),
            )
          ),
          const SizedBox(height: 10),
          const Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 50),
              child: Text(
                "Ro'yhatdan o'tish uchun emailingizni kiriting va tasdiqlash kodini kuting !",
                style: TextStyle(fontSize: 12),
                textAlign: TextAlign.center,
              ),
            )
          ),
          const SizedBox(height: 40),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: TextField(
              controller: email,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                hintText: 'example@gmail.com',
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.blue, width: 2),
                  borderRadius: BorderRadius.circular(10)
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.blue, width: 2),
                  borderRadius: BorderRadius.circular(10)
                )
              ),
            ),
          )
          // Stack(
          //   children: [
          //     Column(
          //       mainAxisSize: MainAxisSize.min,
          //       children: [
          //         const SizedBox(height: 10),
          //         GestureDetector(
          //           onTap: customCountryPicker,
          //           child: Container(
          //             height: 50,
          //             margin: const EdgeInsets.symmetric(horizontal: 20),
          //             padding: const EdgeInsets.symmetric(horizontal: 10),
          //             decoration: BoxDecoration(
          //               borderRadius: BorderRadius.circular(8.0),
          //               border: Border.all(color: Colors.blue, width: 2)
          //             ),
          //             child: Row(
          //               children: [
          //                 Text(
          //                   "${country.flagEmoji}"
          //                   " +${country.phoneCode}"
          //                   " ${country.displayNameNoCountryCode}"
          //                 ),
          //                 const Spacer(),
          //                 const Icon(Icons.arrow_forward_ios_rounded, color: Colors.grey)
          //               ],
          //             ),
          //           ),
          //         ),
          //       ],
          //     ),
          //     Align(
          //       alignment: const Alignment(-0.75, -1),
          //       child: Container(
          //         width: 76,
          //         color: Colors.white,
          //         alignment: Alignment.center,
          //         child: const Text("Country", style: TextStyle(color: Colors.grey)),
          //       ),
          //     )
          //   ],
          // ),
          // const SizedBox(height: 20),
          // Container(
          //   height: 50,
          //   alignment: Alignment.center,
          //   margin: const EdgeInsets.symmetric(horizontal: 20),
          //   padding: const EdgeInsets.symmetric(horizontal: 10),
          //   decoration: BoxDecoration(
          //     borderRadius: BorderRadius.circular(8.0),
          //     border: Border.all(color: Colors.blue, width: 2)
          //   ),
          //   child: Row(
          //     crossAxisAlignment: CrossAxisAlignment.center,
          //     children: [
          //       const SizedBox(width: 5),
          //       SizedBox(
          //         width: 46,
          //         child: TextField(
          //           cursorColor: Colors.blue,
          //           readOnly: true,
          //           controller: TextEditingController(text: "+${country.phoneCode}"),
          //           decoration: const InputDecoration(
          //             contentPadding: EdgeInsets.zero,
          //             border: InputBorder.none,
          //           ),
          //         ),
          //       ),
          //       const SizedBox(width: 10),
          //       const Text("|", style: TextStyle(color: Colors.grey, fontSize: 18)),
          //       const SizedBox(width: 10),
          //       Expanded(
          //         child: TextField(
          //           controller: phoneNumber,
          //           cursorColor: Colors.blue,
          //           keyboardType: TextInputType.phone,
          //           inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          //           decoration: InputDecoration(
          //             contentPadding: EdgeInsets.zero,
          //             border: InputBorder.none,
          //             hintText: country.example
          //           ),
          //         ),
          //       )
          //     ],
          //   ),
          // ),
        ],
      ),
      floatingActionButton: GestureDetector(
        onTap: (){
          if(inProgress) return;
          if(email.text.trim().isEmpty){
            snackBar(context, "Emailni kiritmadingiz");
            return;
          }

          customAlertDialog();
        },
        child: CircleAvatar(
          radius: 30,
          backgroundColor: Colors.blue,
          child: inProgress
              ? const Padding(
                  padding: EdgeInsets.all(5.0),
                  child: CircularProgressIndicator(color: Colors.white),
                )
              : const Icon(Icons.arrow_forward, size: 30, color: Colors.white),
        ),
      ),
    );
  }


  @override
  void dispose() {
    super.dispose();
    email.dispose();
  }

  void customCountryPicker() => showCountryPicker(
    context: context,
    favorite: ['uz', 'us', 'ru'],
    countryListTheme: const CountryListThemeData(
      bottomSheetHeight: 600,
      borderRadius: BorderRadius.only(topRight: Radius.circular(20), topLeft: Radius.circular(20)),
      inputDecoration: InputDecoration(
        prefixIcon: Icon(Icons.search, color: Colors.black),
        hintText: 'Search your country here...',
        border: InputBorder.none
      )
    ),
    onSelect: (_) => setState(() => country = _)
  );

  Future customAlertDialog() => showDialog(
    barrierColor: Colors.white.withOpacity(0.8),
    context: context,
    builder: (context) => Stack(
      children: [
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Container(
            color: Colors.black.withOpacity(0.3),
            width: double.infinity,
            height: double.infinity,
          ),
        ),
        AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          title: Text("Email to'g'rimi?", style: TextStyle(color: Colors.black.withOpacity(0.6), fontSize: 15)),
          content: SizedBox(
            height: 65,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  email.text.trim(),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () => Navigator.of(context).pop(),
                      child: const Text('Edit', style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
                    ),
                    InkWell(
                      onTap: sendCode,
                      child: const Text('Yes', style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ],
    ),
  );

  Future<void> sendCode() async {
    Navigator.pop(context);
    inProgress = true;
    setState((){});

    emailOTP.setConfig(
      appEmail: "me@rohitchouhan.com",
      appName: "Tasdiqlash kodi",
      userEmail: email.text.trim(),
      otpLength: 5,
      otpType: OTPType.digitsOnly
    );

    if(await emailOTP.sendOTP()){
      if(!mounted) return;
      Navigator.push(context, CupertinoPageRoute(builder: (context) => Confirmation(emailOTP: emailOTP, email: email.text.trim())));
    } else {
      if(!mounted) return;
      snackBar(context, "Xatolik yuz berdi");
    }

    inProgress = false;
    setState((){});
  }
}
