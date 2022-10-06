import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hey_legend/Screens/DashBoard/HomePage.dart';
import 'package:hey_legend/Screens/OnBoarding/OnBoarding.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Screens/AuthScreen/LoginScreens.dart';
import 'Screens/SplashScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String? userId;

  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Hey Legend',
      theme: ThemeData(primarySwatch: Colors.blue),
      themeMode: ThemeMode.light,
      initialRoute: SplashScreen.route,
      getPages: [
        GetPage(
          name: SplashScreen.route,
          page: () => const SplashScreen(),
        ),
        GetPage(
          name: OnBoarding1.route,
          page: () => const OnBoarding1(),
        ),
        GetPage(
          name: HomePage.route,
          page: () => const HomePage(),
        ),
        GetPage(
            name: RegistrationScreen.route,
            page: () => RegistrationScreen(),
            binding: AuthBinding()),
        GetPage(
            name: LoginScreen.route,
            page: () => LoginScreen(),
            binding: AuthBinding()),
      ],
    );
  }
}
