import 'package:contact_app/pages/main_page.dart';
import 'package:contact_app/pages/register/register.dart';
import 'package:contact_app/services/shared_prereferences_service.dart';
import 'package:contact_app/setup.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  // exampleApp();
  await setup();
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    String registered = SharedPreferencesService.getString(SharedPreferencesStorageKey.registered) ?? 'false';
    return MaterialApp(
      debugShowCheckedModeBanner: true,
      theme: ThemeData(textTheme: GoogleFonts.poppinsTextTheme()),
      home: registered == 'true' ? const MainPage() : const Register(),
    );
  }
}
