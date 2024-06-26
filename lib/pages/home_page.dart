// ignore_for_file: library_private_types_in_public_api, prefer_const_constructors, duplicate_ignore, deprecated_member_use

import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gg/pages/coummity_page.dart';
import 'package:gg/pages/result_page.dart';
//import 'package:gg/pages/coummity_page.dart';
import 'package:gg/pages/stages_screen.dart';
//import 'package:gg/pages/result_page.dart';
import 'package:gg/pages/welcome_screen.dart';
import 'package:image_picker/image_picker.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  static String id = 'home_page';

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  File? _image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 221, 241, 224),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.blue),
            onPressed: () {
              Navigator.pushNamed(context, WelcomePage.id);
            },
          ),
          actions: [
          ElevatedButton(
            onPressed: () {
              context.locale == const Locale('ar')
                  ? context.setLocale(const Locale('en'))
                  : context.setLocale(const Locale('ar'));
            },
            child:  Text(
              context.tr('Language'),
              style: const TextStyle(color: Colors.green),
            ),
          ),
        ],
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Cucure',
                style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              SizedBox(
                height: 32,
              ),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          // ignore: unnecessary_null_comparison
                          backgroundImage:
                              // ignore: unnecessary_null_comparison
                              (_image == null)
                                  ? AssetImage(
                                      'photos/p.png',
                                    )
                                  : FileImage(_image!) as ImageProvider,
          
                          radius: 100,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 36,
                    ),
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                            Colors.green), // Corrected line
                        minimumSize:
                            MaterialStateProperty.all(const Size(300, 60)),
                      ),
                      onPressed: _getImageFromGallery,
                      child: Text(
                        context.tr('Gallery'),
                        style: TextStyle(fontSize: 36, color: Colors.black),
                      ),
                    ),
                    SizedBox(
                      height: 36,
                    ),
                    ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              Colors.green), // Corrected line
                          minimumSize:
                              MaterialStateProperty.all(const Size(300, 60)),
                        ),
                        onPressed: _getImageFromCamera,
                        child: Text(
                          context.tr('Camera'),
                          style: TextStyle(fontSize: 36, color: Colors.black),
                        )),
                    SizedBox(
                      height: 36,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, StagesScreen.id);
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                            Colors.green), // Corrected line
                        minimumSize:
                            MaterialStateProperty.all(const Size(300, 60)),
                      ),
                      child: Text(
                       context.tr('Stages'),
                        style: TextStyle(fontSize: 36, color: Colors.black),
                      ),
                    ),
                    SizedBox(
                      height: 36,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, CoummityPage.id);
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                            Colors.green), // Corrected line
                        minimumSize:
                            MaterialStateProperty.all(const Size(300, 60)),
                      ),
                      child: Text(
                        context.tr('Community'),
                        style: TextStyle(fontSize: 36, color: Colors.black),
                      ),
                    ),
                  ],
                )
              ]),
            ],
          ),
        ));
  }

  void _getImageFromGallery() async {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
        // Reset the info visibility when selecting a new image
      });
      await Future.delayed(Duration(seconds: 1));
      Navigator.pushNamed(context, ResultPage.id, arguments: _image);
    }
  }

  void _getImageFromCamera() async {
    final pickedImage =
        await ImagePicker().getImage(source: ImageSource.camera, imageQuality: 100);
    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
        // Reset the info visibility when selecting a new image
      });
      await Future.delayed(Duration(seconds: 1));
      Navigator.pushNamed(context, ResultPage.id, arguments: _image);
    }
  }
}
