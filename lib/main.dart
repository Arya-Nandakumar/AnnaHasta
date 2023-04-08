import 'package:annahasta/Screens/common/login.dart';
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
        useMaterial3: true,
        colorSchemeSeed: buildMaterialColor(Color(0xFF7A01FF)),
        appBarTheme: AppBarTheme(
          color: buildMaterialColor(Color(0xFF7A01FF)),
          foregroundColor: Colors.white,
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorSchemeSeed: buildMaterialColor(Color(0xFF7A01FF)),
        appBarTheme: AppBarTheme(),
      ),
      themeMode: ThemeMode.system,
      home: SignInPage(),
    );
  }
}
