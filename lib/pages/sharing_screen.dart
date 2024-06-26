import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as p;
import 'package:flutter/material.dart';
import 'package:gg/pages/coummity_page.dart';
import 'package:gg/pages/home_page.dart';

class SharingScreen extends StatelessWidget {
  static String id = 'sharing_screen';
  final messageController = TextEditingController();

   SharingScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 221, 241, 224),
        title:  Text(context.tr('Share')),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushNamed(context, MyHomePage.id);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Image.file(
                ModalRoute.of(context)!.settings.arguments
                    as File, // Replace with your image path
                height: 300,
                width: 300,
                fit: BoxFit.cover,
              ),
            ),
             Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  context.tr('Add a message'),
                  style: const TextStyle(color: Colors.black, fontSize: 18),
                )
              ],
            ),
             Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              child: TextField(
                controller: messageController,
                decoration:  InputDecoration(
                  hintText: context.tr("message"),
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              child: ElevatedButton(
                onPressed: () async{
                   // handle sending photo to community

            final storageRef = FirebaseStorage.instance.ref();
            final imgFile =ModalRoute.of(context)!.settings.arguments as File;
            
            final fileRef = storageRef.child(p.basename(imgFile.path));
            try {
              await fileRef.putFile(imgFile);
            } catch (e) {
              print(e);
            }
            final url = await fileRef.getDownloadURL();
            String sender = (await FirebaseFirestore.instance.collection('users').where('Email',isEqualTo:FirebaseAuth.instance.currentUser!.email).get()).docs[0]['FirstName'];
           
            
            CollectionReference posts = FirebaseFirestore.instance.collection('posts');
            posts.add({
              'message': messageController.text ,
              'photo': url,
              'sender': sender,
              'comments':[]

            });


                  Navigator.pushNamed(context, CoummityPage.id);



                },
                style: ButtonStyle(
                  minimumSize: MaterialStateProperty.all(const Size(400, 60)),
                  backgroundColor: MaterialStateProperty.all(Colors.green),
                  // Adjust other properties as needed
                ),
                child:
                     Text(context.tr("Send"), style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
