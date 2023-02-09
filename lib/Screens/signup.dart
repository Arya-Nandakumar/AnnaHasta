import 'package:annahasta/Screens/login.dart';
import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _fssaiController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: "Email"),
                validator: (value) {
                  if(value!.isEmpty) {
                    return "Please enter a valid email";
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(labelText: "Password"),
                validator: (value) {
                  if (value!.length < 6) {
                    return "Password must be at least 6 characters";
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: "Full Name"),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Please enter your full name";
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _fssaiController,
                decoration: InputDecoration(labelText: "FSSAI Number"),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Please enter your FSSAI number";
                  }
                  return null;
                },
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      print("Email: ${_emailController.text}");
                      print("Password: ${_passwordController.text}");
                      print("Full Name: ${_nameController.text}");
                      print("FSSAI Number: ${_fssaiController.text}");
                    }
                  },
                  child: Text("Sign Up"),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation1, animation2) => LoginPage(),
                transitionDuration: Duration.zero,
                reverseTransitionDuration: Duration.zero,
              ),
            );
                },
                child: Text('Already has an account? Login'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
