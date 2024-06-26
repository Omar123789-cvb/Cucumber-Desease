import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:gg/pages/coummity_page.dart';
import 'package:gg/pages/home_page.dart';
import 'package:gg/pages/login_screen.dart';
import 'package:gg/pages/post.dart';
import 'package:gg/pages/result_page.dart';
import 'package:gg/pages/sharing_screen.dart';
import 'package:gg/pages/signup_screen.dart';
import 'package:gg/pages/stages_screen.dart';
import 'package:gg/pages/welcome_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
    await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('ar')],
      path: 'assets/translations', 
      fallbackLocale: const Locale('en'),
      startLocale: const Locale('en'),
      child: const MyApp()
    ),);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    
    return MaterialApp(
      debugShowCheckedModeBanner: false,
           localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      title: 'Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        scaffoldBackgroundColor: const Color.fromARGB(255, 221, 241, 224),
        useMaterial3: true,
      ),
      routes: {
        LoginPage.id: (context) => const LoginPage(),
        SignupPage.id: (context) => const SignupPage(),
        WelcomePage.id: (context) => const WelcomePage(),
        MyHomePage.id: (context) => const MyHomePage(),
        ResultPage.id: (context) => const ResultPage(),
        CoummityPage.id: (context) =>  const CoummityPage(),
        StagesScreen.id: (context) => const StagesScreen(),
        SharingScreen.id: (context) =>  SharingScreen(),
        Post.id: (context) =>  Post(),
      },
      home: FirebaseAuth.instance.currentUser != null
          ? const MyHomePage()
          : const WelcomePage(),
    );
  }
}
