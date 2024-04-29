import 'dart:io';
import 'dart:math';

import 'package:contact_app/functions/delete_dialog.dart';
import 'package:contact_app/functions/open_sms.dart';
import 'package:contact_app/models/contact_model.dart';
import 'package:contact_app/pages/add_contact.dart';
import 'package:contact_app/pages/contact_details.dart';
import 'package:contact_app/services/path_provider_service.dart';
import 'package:contact_app/services/translate/return_text.dart';
import 'package:contact_app/setup.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';

import '../../colors.dart';
import '../../services/shared_prereferences_service.dart';

class Contacts extends StatefulWidget {
  const Contacts({super.key});

  @override
  State<Contacts> createState() => _ContactsState();
}

class _ContactsState extends State<Contacts> {
  List<int> selected = [];
  int? extendedContact;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: selected.isEmpty,
      onPopInvoked: (_){
        selected.clear();
        setState((){});
      },
      child: Scaffold(
        backgroundColor: const Color(0xfff6f6f8),
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: true,
              expandedHeight: 350,
              surfaceTintColor: Colors.transparent,
              title: selected.isEmpty ? Row(
                children: [
                  const SizedBox(width: 10),
                  Text('phone'.translate),
                  const Spacer(),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context,
                        CupertinoPageRoute(builder: (context) => const AddContact())
                      ).then((value) => setState((){}));
                    },
                    child: const Icon(Icons.add),
                  ),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: (){},
                    child: const Icon(Icons.search),
                  ),
                  const SizedBox(width: 10),
                  PopupMenuButton(
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        onTap: chooseLanguage,
                        child: Text('change_language'.translate),
                      ),
                      PopupMenuItem(
                        child: Text("voice_assistant".translate),
                      )
                    ],
                  ),
                  const SizedBox(width: 10),
                ],
              ) : Row(
                children: [
                  const SizedBox(width: 10),
                  IconButton(
                    onPressed: (){
                      if(selected.length == contacts.length){
                        selected.clear();
                      } else {
                        selected.clear();
                        for(int i=0; i<contacts.length; i++){
                          selected.add(i);
                        }
                      }
                      setState(() {});
                    },
                    icon: Icon(selected.length == contacts.length ? Icons.check_circle_rounded : Icons.circle_outlined),
                  ),
                  Text("${selected.length} ta tanlandi"),
                  const Spacer(),
                  IconButton(
                    onPressed: delete,
                    icon: const Icon(Icons.delete),
                  ),
                ],
              ),
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  color: const Color(0xfff6f6f8),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text("phone".translate, style: const TextStyle(color: Colors.black, fontSize: 30)),
                        if(selected.isEmpty) Text(
                          "Telefon raqamiga ega ${contacts.length} ta contact",
                          style: const TextStyle(color: Colors.black)
                        ),
                        if(selected.isNotEmpty) Text(
                          "Tanlangan contactlar ${selected.length} ta",
                          style: const TextStyle(color: Colors.black)
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                childCount: contacts.length,
                (context, index) {
                  ContactModel contactModel = contacts[index];
                  return GestureDetector(
                    onTap: (){
                      if(selected.isNotEmpty){
                        if(!selected.contains(index)){
                          selected.add(index);
                        } else {
                          selected.remove(index);
                        }
                        setState(() {});
                        return;
                      }

                      if(extendedContact == null || extendedContact != index){
                        extendedContact = index;
                      } else {
                        extendedContact = null;
                      }
                      setState(() {});
                    },
                    onLongPress: (){
                      if(selected.isEmpty){
                        selected.add(index);
                        setState(() {});
                      }
                    },
                    onHorizontalDragUpdate: (details){
                      if(details.delta.dx > 10){
                        FlutterPhoneDirectCaller.callNumber(contactModel.phoneNumber);
                      }
                    },
                    child: Container(
                      height: extendedContact != null && extendedContact == index ? 160 : 60,
                      margin: index == contacts.length-1 ? const EdgeInsets.only(bottom: 30) : null,
                      decoration: BoxDecoration(
                        color: selected.contains(index) ? Colors.grey.withOpacity(0.3) : Colors.white,
                        borderRadius: BorderRadius.vertical(
                          top: index == 0 ? const Radius.circular(30) : Radius.zero,
                          bottom: index == contacts.length-1 ? const Radius.circular(30) : Radius.zero,
                        )
                      ),
                      child: Column(
                        children: [
                          if(index != 0) const Padding(
                            padding: EdgeInsets.only(left: 80, right: 20),
                            child: Divider(height: 0),
                          ),
                          Expanded(
                            child: Row(
                              children: [
                                const SizedBox(width: 20),
                                CircleAvatar(
                                  radius: 20,
                                  backgroundColor: selected.contains(index) ? Colors.green : colors[Random().nextInt(23)],
                                  backgroundImage: contactModel.imagePath != null && !selected.contains(index)
                                      ? Image.file(File(contactModel.imagePath!)).image
                                      : null,
                                  child: selected.contains(index)
                                      ? const Icon(Icons.done, color: Colors.white)
                                      : contactModel.imagePath == null
                                      ? Text(contactModel.name[0], style: const TextStyle(fontWeight: FontWeight.bold))
                                      : null,
                                ),
                                const SizedBox(width: 20),
                                Expanded(
                                  child: Text(
                                    contactModel.name,
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  )
                                ),
                              ],
                            ),
                          ),
                          if(extendedContact != null && extendedContact == index) SizedBox(
                            height: 100,
                            child: Column(
                              children: [
                                Text("Telefon: ${contactModel.phoneNumber}"),
                                const SizedBox(height: 15),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.12),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      GestureDetector(
                                        onTap: () => FlutterPhoneDirectCaller.callNumber(contactModel.phoneNumber),
                                        child: const CircleAvatar(
                                          radius: 22,
                                          backgroundColor: Colors.green,
                                          child: Icon(Icons.phone, color: Colors.white),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () => openSMS(context, contactModel.phoneNumber),
                                        child: const CircleAvatar(
                                          radius: 22,
                                          backgroundColor: Colors.blue,
                                          child: Icon(Icons.sms, color: Colors.white),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () => Clipboard.setData(ClipboardData(text: contactModel.phoneNumber)),
                                        child: const CircleAvatar(
                                          radius: 22,
                                          backgroundColor: Colors.green,
                                          child: Icon(Icons.copy_rounded, color: Colors.white),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.push(context,
                                              CupertinoPageRoute(builder: (context) => ContactDetails(contactModel: contactModel))
                                          ).then((value) => setState((){}));
                                        },
                                        child: const CircleAvatar(
                                          radius: 22,
                                          backgroundColor: Colors.grey,
                                          child: Icon(Icons.info_outline, color: Colors.white),
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void delete(){
    deleteDialog(
      context: context,
      selectedCount: selected.length,
      delete: () async {
        for (var i in selected) {
          PathProviderService.deleteFile(contacts[i].path);
        }

        await setupContacts();
        selected.clear();
        setState((){});
        if(!mounted) return;
        Navigator.pop(context);
      }
    );
  }

  chooseLanguage(){
    String language = SharedPreferencesService.getString(SharedPreferencesStorageKey.language) ?? 'uz';
    showDialog(
        context: context,
        builder: (context) => StatefulBuilder(
            builder: (context, setState) => AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              contentPadding: const EdgeInsets.all(0),
              content: SizedBox(
                height: 160,
                child: Column(
                  children: [
                    RadioListTile(
                        title: const Text("Uzbek"),
                        value: "uz",
                        groupValue: language,
                        activeColor: Colors.blue,
                        onChanged: (value) => setState(() => language = 'uz')
                    ),
                    RadioListTile(
                        title: const Text("English"),
                        value: "en",
                        groupValue: language,
                        activeColor: Colors.blue,
                        onChanged: (value) => setState(() => language = 'en')
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text("cancel".translate),
                        ),
                        TextButton(
                          onPressed: (){
                            SharedPreferencesService.storageString(SharedPreferencesStorageKey.language, language);
                            setState((){});
                            Navigator.pop(context);
                          },
                          child: Text("perform".translate),
                        ),
                        const SizedBox(height: 10)
                      ],
                    )
                  ],
                ),
              ),
            )
        )
    );
  }
}
