import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gg/pages/home_page.dart';
import 'package:gg/pages/welcome_screen.dart';
import 'package:gg/utils.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  static String id = 'login_page';

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

    final formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 221, 241, 224),
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
            key:formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                 Text(
                  context.tr('Login'),
                  style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  validator: (value) => value!.isEmpty ? 'Please enter your email' : null,
                  controller: emailController,
                  decoration:  InputDecoration(
                    fillColor: Color.fromRGBO(239, 173, 173, 1),
                    labelText: context.tr('Email Address'),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  validator: (value) => value!.isEmpty ? 'Please enter your password' : null,
                  controller: passwordController,
                  obscureText: true,
                  decoration:  InputDecoration(
                    fillColor: Color.fromRGBO(239, 173, 173, 1),
                    labelText: context.tr('Password'),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 80),
                ElevatedButton(
                  onPressed: () async{
                     final isValid = formKey.currentState!.validate();
          
                                if (!isValid) {
                                  Utils.showSnackBar(
                                      context, "Please fill all fields");
                                  return;
                                }
                                try {
                                  final crd = await FirebaseAuth.instance
                                      .signInWithEmailAndPassword(
                                          email: emailController.text,
                                          password: passwordController.text);
          
                                  if (crd.user != null && context.mounted) {
                                    Navigator.pushNamed(context, MyHomePage.id);
                                  }
          
                                  if (context.mounted) {
                                    Utils.showSnackBar(context, 'Success');
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
                  child:  Text(context.tr('Login'),
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
