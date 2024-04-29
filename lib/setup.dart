import 'dart:convert';
import 'dart:io';

import 'package:contact_app/models/contact_model.dart';
import 'package:contact_app/services/path_provider_service.dart';
import 'package:contact_app/services/shared_prereferences_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'firebase_options.dart';

Future<void> setup() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  SharedPreferencesService.prefs = await SharedPreferences.getInstance();

  // final Directory appDocumentDirectory = await getApplicationDocumentsDirectory();
  // Hive.init(appDocumentDirectory.path);
  // await Hive.openBox('data');

  // final appDocumentDirectory = await getApplicationDocumentsDirectory();
  // Hive.init(appDocumentDirectory.path);
  // await Hive.openBox('data');

  await setupContacts();
  await setupLastContacts();
}

Future<void> setupContacts() async {
  contacts = [];
  List<String> contactsList = await PathProviderService.getAllFiles(PathProviderKey.contacts);
  contactsList.map((e) => contacts.add(ContactModel.fromJson(jsonDecode(PathProviderService.readFile(e)), e))).toList();
}

Future<void> setupLastContacts() async {
  lastContacts = [];
  List<String> contactsList = await PathProviderService.getAllFiles(PathProviderKey.last);
  contactsList.map((e) => lastContacts.add(ContactModel.fromJson(jsonDecode(PathProviderService.readFile(e)), e))).toList();
  lastContacts.reversed;

}
