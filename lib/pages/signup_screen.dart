import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gg/pages/home_page.dart';
import 'package:gg/pages/welcome_screen.dart';
import 'package:gg/utils.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});
  static String id = 'signup';

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final fNameController = TextEditingController();
  final lNamecontroller = TextEditingController();
  final phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 221, 241, 224),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.blue),
          onPressed: () {
            Navigator.pushNamed(context, WelcomePage.id);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                 Text(
                  context.tr('Signup'),
                  style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter your first name' : null,
                  controller: fNameController,
                  decoration:  InputDecoration(
                    fillColor: Color.fromRGBO(239, 173, 173, 1),
                    labelText: context.tr('FirstName'),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter your last name' : null,
                  controller: lNamecontroller,
                  decoration:  InputDecoration(
                    fillColor: Color.fromRGBO(239, 173, 173, 1),
                    labelText:  context.tr('LastName'),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter your email' : null,
                  controller: emailController,
                  decoration:  InputDecoration(
                    fillColor: Color.fromRGBO(239, 173, 173, 1),
                    labelText:  context.tr('Email'),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: phoneController,
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter your phone number' : null,
                  decoration:  InputDecoration(
                    fillColor: Color.fromRGBO(239, 173, 173, 1),
                    labelText:  context.tr('Telephonenumber'),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter your password' : null,
                  controller: passwordController,
                  obscureText: true,
                  decoration:  InputDecoration(
                    fillColor: Color.fromRGBO(239, 173, 173, 1),
                    labelText: context.tr('Password'),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    final isValid = formKey.currentState!.validate();
          
                    if (!isValid) {
                      Utils.showSnackBar(context, "Please fill all fields");
                      return;
                    }
                    try {
                      await FirebaseAuth.instance.createUserWithEmailAndPassword(
                          email: emailController.text,
                          password: passwordController.text);
          
                      users.add({
                        'Email': emailController.text,
                        'Mobilw': phoneController.text,
                        'FirstName': fNameController.text,
                        'LastName': lNamecontroller.text,
                       
                      });
          
                      if (context.mounted) {
                        Navigator.pushNamed(context, MyHomePage.id);
                      }
                    } on FirebaseAuthException catch (e) {
                      if (context.mounted) {
                        Utils.showSnackBar(context, e.message!);
                      }
                    } catch (e) {
                      if (context.mounted) {
                        Utils.showSnackBar(context, e.toString());
                      }
                    }
                  },
                  style: ButtonStyle(
                    minimumSize: MaterialStateProperty.all(const Size(400, 60)),
                    backgroundColor: MaterialStateProperty.all(Colors.green),
                    // Adjust other properties as needed
                  ),
                  child:  Text(context.tr('Signup'),
                      style: TextStyle(color: Colors.white, fontSize: 30)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
