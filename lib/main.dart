import 'package:flight_res_system/pages/home_page.dart';
import 'package:flight_res_system/pages/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:flight_res_system/pages/login_screen.dart';
import 'package:flight_res_system/pages/registration_screen.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flight Res',
      theme: ThemeData(
        primaryColor: Color(0xffFE2E2E),
        colorScheme: ColorScheme.dark(),
      ),
      initialRoute: "/",
      routes: {
        "/": (context) => const LoginScreen(),
        "/first": (context) => const RegistrationScreen(),
        "/second": (context) => const HomePage(),
        "/third": (context) => const ProfilePage(), },
    );
  }
}
