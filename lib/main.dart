import 'package:annahasta/Screens/login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:annahasta/Functions/colorhex.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login',
      theme: ThemeData(
          brightness: Brightness.light,
          colorSchemeSeed: buildMaterialColor(Color(0xFF7A01FF)),
          scaffoldBackgroundColor: buildMaterialColor(Color(0xFFFDF7FF))),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        colorSchemeSeed: buildMaterialColor(Color(0xFF7A01FF)),
      ),
      themeMode: ThemeMode.system,
      home: SignInPage(),
    );
  }
}
