import 'package:contact_app/pages/main_pages/contacts.dart';
import 'package:contact_app/pages/main_pages/keyboard.dart';
import 'package:contact_app/pages/main_pages/last.dart';
import 'package:contact_app/services/translate/return_text.dart';
import 'package:d_navigation_bar/d_navigation_bar.dart';
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPage();
}

class _MainPage extends State<MainPage> {
  final DNavigationBarController controller = DNavigationBarController(currentIndex: 1, pages: _pages);
  static const List<Widget> _pages = [Keyboard(), Last(), Contacts()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff6f6f8),
      body: controller.page,
      bottomNavigationBar: DNavigationBar(
        onChanged: (_) => setState(() {}),
        height: 50,
        useShadow: false,
        controller: controller,
        backgroundColor: Colors.transparent,
        items: [
          DNavigationBarItem(
            icon: Column(
              children: [
                Text('phone'.translate, style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 2),
                Container(height: 2.5, width: 70, color: Colors.transparent)
              ],
            ),
            activeIcon: Column(
              children: [
                Text('phone'.translate, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 2),
                Container(
                  height: 2.5,
                  width: 70,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(50)
                  ),
                )
              ],
            ),
          ),
          DNavigationBarItem(
            icon: Column(
              children: [
                Text("last".translate, style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 2),
                Container(height: 2.5, width: 75, color: Colors.transparent)
              ],
            ),
            activeIcon: Column(
              children: [
                Text("last".translate, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 2),
                Container(
                  height: 2.5,
                  width: 75,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(50)
                  ),
                )
              ],
            ),
          ),
          DNavigationBarItem(
            icon: Column(
              children: [
                const Text("Contact", style: TextStyle(fontSize: 16)),
                const SizedBox(height: 2),
                Container(height: 2.5, width: 75, color: Colors.transparent)
              ],
            ),
            activeIcon: Column(
              children: [
                const Text("Contact", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 2),
                Container(
                  height: 2.5,
                  width: 75,
                  decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(50)
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
