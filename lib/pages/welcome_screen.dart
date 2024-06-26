import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gg/pages/login_screen.dart';
import 'package:gg/pages/signup_screen.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});
  static String id = 'welcome_page';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          ElevatedButton(
            onPressed: () {
              context.locale == const Locale('ar')
                  ? context.setLocale(const Locale('en'))
                  : context.setLocale(const Locale('ar'));
            },
            child: Text(
              context.tr('Language'),
              style: const TextStyle(color: Colors.green),
            ),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Cucare',
              style: TextStyle(
                  color: Colors.green,
                  fontSize: 42,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 32), // Add some spacing
            Image.asset(
              'photos/20.png', // Replace with your image path
              height: 300,
              width: 300,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 24), // Add more spacing
            ElevatedButton(
              style: ButtonStyle(
                minimumSize: MaterialStateProperty.all(const Size(400, 60)),
                backgroundColor: MaterialStateProperty.all(Colors.green),
                // Adjust other properties as needed
              ),
              onPressed: () {
                Navigator.pushNamed(context, LoginPage.id);
              },
              child: Text(
                context.tr('Login'),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                ),
              ),
            ),
            const SizedBox(
              height: 32,
            ),
            ElevatedButton(
              style: ButtonStyle(
                minimumSize: MaterialStateProperty.all(const Size(400, 60)),
                backgroundColor: MaterialStateProperty.all(Colors.green),
                // Adjust other properties as needed
              ),
              onPressed: () {
                Navigator.pushNamed(context, SignupPage.id);
              },
              child: Text(
                context.tr('Signup'),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
