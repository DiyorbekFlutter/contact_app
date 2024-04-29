import 'dart:convert';
import 'dart:io';

import 'package:contact_app/functions/snack_bar.dart';
import 'package:contact_app/models/contact_model.dart';
import 'package:contact_app/services/path_provider_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../setup.dart';

class AddContact extends StatefulWidget {
  const AddContact({super.key});

  @override
  State<AddContact> createState() => _AddContactState();
}

class _AddContactState extends State<AddContact> {
  final TextEditingController name = TextEditingController();
  final TextEditingController phoneNumber = TextEditingController();
  String? imagePath;

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
          GestureDetector(
            child: CircleAvatar(
              radius: 60,
              backgroundImage: imagePath != null ? Image.file(File(imagePath!)).image : null,
              child: imagePath == null ? const Icon(CupertinoIcons.camera, size: 30) : null,
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
                hintText: 'Name',
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
                hintText: 'Phone number',
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
    if(name.text.trim().isNotEmpty && phoneNumber.text.trim().isNotEmpty){
      PathProviderService.createFile(
        key: PathProviderKey.contacts,
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
  }
}
