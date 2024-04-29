import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:contact_app/models/contact_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';

import '../colors.dart';
import '../functions/open_sms.dart';
import '../functions/snack_bar.dart';
import '../services/path_provider_service.dart';
import '../setup.dart';

class ContactDetails extends StatefulWidget {
  final ContactModel contactModel;
  const ContactDetails({required this.contactModel, super.key});

  @override
  State<ContactDetails> createState() => _ContactDetailsState();
}

class _ContactDetailsState extends State<ContactDetails> {
  late final TextEditingController name;
  late final TextEditingController phoneNumber;

  @override
  void initState() {
    super.initState();
    name = TextEditingController(text: widget.contactModel.name);
    phoneNumber = TextEditingController(text: widget.contactModel.phoneNumber);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff6f6f8),
      appBar: AppBar(
        title: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_rounded),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xfff6f6f8),
      ),
      body: ListView(
        children: [
          const SizedBox(height: 100),
          Container(
            height: 200,
            width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30)
            ),
            child: Stack(
              children: [
                Align(
                  alignment: const Alignment(0, -2),
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: colors[Random().nextInt(23)],
                    backgroundImage: widget.contactModel.imagePath != null
                        ? Image.file(File(widget.contactModel.imagePath!)).image
                        : null,
                    child: widget.contactModel.imagePath == null
                        ? Text(widget.contactModel.name[0], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 30))
                        : null,
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        widget.contactModel.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20
                        ),
                      ),
                      const SizedBox(height: 10),
                      RichText(
                        text: TextSpan(
                          children: [
                            const TextSpan(
                              text: 'Telefon:  ',
                              style: TextStyle(color: Colors.grey)
                            ),
                            TextSpan(
                              text: widget.contactModel.phoneNumber,
                              style: const TextStyle(color: Colors.black)
                            )
                          ]
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          GestureDetector(
                            onTap: () => FlutterPhoneDirectCaller.callNumber(widget.contactModel.phoneNumber),
                            child: const CircleAvatar(
                              radius: 22,
                              backgroundColor: Colors.green,
                              child: Icon(Icons.phone, color: Colors.white),
                            ),
                          ),
                          GestureDetector(
                            onTap: () => openSMS(context, widget.contactModel.phoneNumber),
                            child: const CircleAvatar(
                              radius: 22,
                              backgroundColor: Colors.blue,
                              child: Icon(Icons.sms, color: Colors.white),
                            ),
                          ),
                          GestureDetector(
                            onTap: () => Clipboard.setData(ClipboardData(text: widget.contactModel.phoneNumber)),
                            child: const CircleAvatar(
                              radius: 22,
                              backgroundColor: Colors.green,
                              child: Icon(Icons.copy_rounded, color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20)
                    ],
                  ),
                )
              ],
            ),
          ),
          const SizedBox(height: 50),
          Container(
            height: 60,
            width: double.infinity,
            alignment: Alignment.center,
            margin: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20)
            ),
            child: TextField(
              controller: name,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                border: InputBorder.none,
                prefixIcon: Icon(CupertinoIcons.person, color: Colors.blue)
              ),
            ),
          ),
          const SizedBox(height: 20),
          Container(
            height: 60,
            width: double.infinity,
            alignment: Alignment.center,
            margin: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20)
            ),
            child: TextField(
              controller: phoneNumber,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                border: InputBorder.none,
                prefixIcon: Icon(CupertinoIcons.phone, color: Colors.blue)
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: SizedBox(
        height: 50,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                "Bekor qilish",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 16
                )
              ),
            ),
            TextButton(
              onPressed: storage,
              child: const Text(
                "Saqlash",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 16
                )
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> storage() async {
    if(widget.contactModel.name != name.text.trim() || widget.contactModel.phoneNumber != phoneNumber.text.trim()){
      if(name.text.trim().isNotEmpty && phoneNumber.text.trim().isNotEmpty){
        PathProviderService.updateFile(
            path: widget.contactModel.path,
            text: jsonEncode(ContactModel(
                name: name.text.trim(),
                phoneNumber: phoneNumber.text.trim(),
                lastConnecting: '',
                path: ''
            ).toJson())
        );
        await setupContacts();
        if(!mounted) return;
        snackBar(context, "Contact saqlandi");
        Navigator.pop(context);
      } else {
        snackBar(context, "Ism va telefon raqami yozilishi shart");
      }
    } else {
      snackBar(context, "O'zgarishlar aniqlanmadi");
    }
  }
}
