import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gg/pages/home_page.dart';
import 'package:gg/pages/post.dart';
class CoummityPage extends StatelessWidget {
  static String id = 'Coummity_page';
  

   const CoummityPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 221, 241, 224),
        title:  Text(
          context.tr('Community'),
          style: TextStyle(fontSize: 36),
          selectionColor: Colors.black,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.blue),
          onPressed: () {
            Navigator.pushNamed(context, MyHomePage.id);
          },
        ),
      ),
      body: FutureBuilder(future:FirebaseFirestore.instance.collection('posts').get() ,builder: ((context, snapshot){
        if(snapshot.connectionState == ConnectionState.waiting){
          return const Center(child: CircularProgressIndicator(),);
        }
        final documents = snapshot.data as QuerySnapshot;
        return ListView.builder(itemBuilder: (context, index){

          return Column(
            children: [
     Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Column(
                children: [
                  Text(documents.docs[index]['sender']),
                  const SizedBox(
                    height: 6,
                  ),
                
                ],
              ),
              const SizedBox(
                width: 6,
              ),
              const Icon(Icons.account_circle_outlined)
            ],
          ),
          const SizedBox(
            height: 6,
          ),
          Center(
            child: Image.network(
              documents.docs[index]['photo'], // Replace with your image path
              height: 180,
              width: 300,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(
            height: 6,
          ),
          Align(
            alignment: context.locale == const Locale('en')
                ? Alignment.centerRight
                : Alignment.centerLeft,
            child: IconButton(
              icon: const Icon(Icons.message),
              onPressed: () {
                
                Navigator.pushNamed(context, Post.id, arguments: documents.docs[index]);
              },
            ),
          ),
          const SizedBox(
            height: 32,
          ),
  ],);
        }
        , itemCount: documents.size,);
      }),)
    );
  }
}


/*class PostItem extends StatelessWidget {
  final String username;
  final String timeAgo;
  final String imageUrl;

  const PostItem({
    Key? key,
    required this.username,
    required this.timeAgo,
    required this.imageUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: <Widget>[
          Image.asset(imageUrl),
          ListTile(
            leading: CircleAvatar(
              // Display the user's initial by taking the first letter of their username
              child: Text(username[0].toUpperCase()),
            ),
            title: Text(username),
            subtitle: Text(timeAgo),
          ),
        ],
      ),
    );
  }
}
*/