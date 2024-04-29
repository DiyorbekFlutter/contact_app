import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';

import '../../models/contact_model.dart';
import '../../services/path_provider_service.dart';
import '../../setup.dart';

class Keyboard extends StatefulWidget {
  const Keyboard({super.key});

  @override
  State<Keyboard> createState() => _KeyboardState();
}

class _KeyboardState extends State<Keyboard> {
  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff6f6f8),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: TextField(
              readOnly: true,
              controller: controller,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 25),
              decoration: const InputDecoration(
                border: InputBorder.none
              ),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 380,
            width: double.infinity,
            child: GridView.builder(
              itemCount: 12,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, childAspectRatio: 1.22, crossAxisSpacing: 5, mainAxisSpacing: 5),
              itemBuilder: (context, index){
                ButtonModel buttonModel = buttons[index];
                return InkWell(
                  onTap: (){
                    if(buttonModel.number != null){
                      controller.text += buttonModel.number!;
                    } else if(index == 9){
                      controller.text += '*';
                      setState(() {});
                    } else if(index == 11){
                      controller.text += '#';
                      setState(() {});
                    }

                    setState((){});
                  },
                  onLongPress: (){
                    if(index == 10){
                      controller.text += '+';
                      setState(() {});
                    }
                  },
                  splashColor: Colors.transparent,
                  child: Container(
                    alignment: Alignment.center,
                    child: buttonModel.child,
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.backspace, color: Colors.transparent, size: 35),
              const SizedBox(width: 55),
              InkWell(
                onTap: (){
                  if(controller.text.isNotEmpty){
                    storage();
                    FlutterPhoneDirectCaller.callNumber(controller.text);
                  }
                },
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                child: const CircleAvatar(
                  radius: 35,
                  foregroundImage: AssetImage('assets/images/logo.png'),
                ),
              ),
              const SizedBox(width: 55),
              InkWell(
                onTap: (){
                  String temp = controller.text;
                  controller.clear();
                  for(int i=0; i<temp.length-1; i++){
                    controller.text += temp[i];
                  }
                  setState(() {});
                },
                onLongPress: () => setState(() => controller.clear()),
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                child: Icon(Icons.backspace, size: 35, color: controller.text.isEmpty ? Colors.transparent : null),
              )
            ],
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Future<void> storage() async {
    DateTime dateTime = DateTime.now();
    String date = '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';

    PathProviderService.createFile(
        key: PathProviderKey.last,
        text: jsonEncode(ContactModel(
          name: controller.text,
          phoneNumber: controller.text,
          lastConnecting: date,
          path: ''
        ).toJson())
    );
    await setupLastContacts();
  }

  List<ButtonModel> buttons = [
    const ButtonModel(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('1', style: TextStyle(fontSize: 30)),
          Text('.'),
        ],
      ),
      number: '1'
    ),
    const ButtonModel(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('2', style: TextStyle(fontSize: 30)),
          Text('ABC'),
        ],
      ),
      number: '2'
    ),
    const ButtonModel(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('3', style: TextStyle(fontSize: 30)),
          Text('DEF'),
        ],
      ),
      number: '3'
    ),
    const ButtonModel(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('4', style: TextStyle(fontSize: 30)),
          Text('GHI'),
        ],
      ),
      number: '4'
    ),
    const ButtonModel(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('5', style: TextStyle(fontSize: 30)),
          Text('JKL'),
        ],
      ),
      number: '5'
    ),
    const ButtonModel(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('6', style: TextStyle(fontSize: 30)),
          Text('MNO'),
        ],
      ),
      number: '6'
    ),
    const ButtonModel(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('7', style: TextStyle(fontSize: 30)),
          Text('PQRS'),
        ],
      ),
      number: '7'
    ),
    const ButtonModel(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('8', style: TextStyle(fontSize: 30)),
          Text('TUV'),
        ],
      ),
      number: '8'
    ),
    const ButtonModel(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('9', style: TextStyle(fontSize: 30)),
          Text('WXYZ'),
        ],
      ),
      number: '9'
    ),
    const ButtonModel(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('*', style: TextStyle(fontSize: 50)),
        ],
      ),
    ),
    const ButtonModel(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('0', style: TextStyle(fontSize: 30)),
          Text('+'),
        ],
      ),
      number: '0'
    ),
    const ButtonModel(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('#', style: TextStyle(fontSize: 30)),
          Text(''),
        ],
      ),
    )
  ];
}

class ButtonModel {
  final Widget child;
  final String? number;

  const ButtonModel({
    required this.child,
    this.number
  });
}
