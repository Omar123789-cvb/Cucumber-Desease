import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gg/pages/coummity_page.dart';

class Post extends StatefulWidget {
  static String id = 'Post';
  const Post({super.key});
  @override
  State<Post> createState() => _PostState();
}

class _PostState extends State<Post> {
  DocumentSnapshot? _doc;
  final commentController = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _doc = ModalRoute.of(context)!.settings.arguments as DocumentSnapshot;
    
  }

  Future<void> addComment() async{
    final comment = commentController.text;
    final sender =(await FirebaseFirestore.instance.collection('users').where('Email',isEqualTo:FirebaseAuth.instance.currentUser!.email).get()).docs[0]['FirstName'];    
    final newComment = {'comment': comment, 'sender': sender};
    final comments = List.from(_doc!['comments']);
    comments.add(newComment);
    FirebaseFirestore.instance
        .collection('posts')
        .doc(_doc!.id)
        .update({'comments': comments});
    commentController.clear();
    _doc = (await FirebaseFirestore.instance.collection('posts').doc(_doc!.id).get());    

    setState((){});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 221, 241, 224),
          title: const Text(
            'Post',
            style: TextStyle(fontSize: 36),
            selectionColor: Colors.black,
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.blue),
            onPressed: () {
              Navigator.pushNamed(context, CoummityPage.id);
            },
          ),
        ),
        body: SafeArea(
          child: _doc != null
              ? Center(
                  child: Column(
                    children: [
                      Image.network(
                        _doc!['photo'],
                        height: 180,
                        width: 300,
                        fit: BoxFit.contain,
                      ),
                      Text(
                        _doc!['message'],
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 6,
                      ),
                      Expanded(
                        child: ListView.builder(
                            itemCount: _doc!['comments'].length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                title:
                                    Text(_doc!['comments'][index]['comment']),
                                subtitle:
                                    Text(_doc!['comments'][index]['sender']),
                              );
                            }),
                      ),
                      Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                 Expanded(
                  child: TextField(
                    controller: commentController,
                    decoration:  InputDecoration(
                      labelText: context.tr('Add a comment'),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: ()async{
                   
                    await addComment();
                     
                  },
                ),
              ],
            ),
          ),
                    ],
                  ),
                )
              : const Center(
                  child: CircularProgressIndicator(),
                ),
        ));
  }
}
