import 'package:flutter/material.dart';
import 'package:mysql_notes_app/app/auth/login.dart';
import 'package:mysql_notes_app/app/auth/signup.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app/homepage.dart';

late SharedPreferences sharedPreferences;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  sharedPreferences = await SharedPreferences.getInstance();

  return runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        brightness: sharedPreferences.getBool("isLight") == true
            ? Brightness.light
            : Brightness.dark,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        useMaterial3: true,
        primarySwatch: Colors.red,
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          foregroundColor: Colors.white,
          backgroundColor: Colors.red,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.resolveWith<Color>(
                (states) => Colors.red),
            foregroundColor: MaterialStateProperty.resolveWith<Color>(
                (states) => Colors.white),
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: sharedPreferences.getString("id") != null ? "/" : "/login",
      routes: {
        "/": (context) => const HomePage(),
        "/login": (context) => const Login(),
        "/signUp": (context) => const SignUp()
      },
    );
  }
}
