import 'package:annahasta/Screens/ngo/confirmgif.dart';
import 'package:flutter/material.dart';

class ProceedPage extends StatefulWidget {
  @override
  _ProceedPageState createState() => _ProceedPageState();
}

class _ProceedPageState extends State<ProceedPage> {
  bool agree = false;
  void _doSomething() {
    Navigator.pushReplacement(

      context, 
      MaterialPageRoute(builder: (context) => Donategif()));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Proceed"),
          centerTitle: true,
        ),
        body: Center(
          child: Column(children: [
            Text("Location:"),
            SizedBox(height: 5),
            Text("Quantity: "),
            SizedBox(height: 5),
            Text("Vegetarian: "),
            SizedBox(height: 5),
            Text("Date & Time: "),
            SizedBox(height: 5),
            Text("Phone number:"),
            SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Checkbox(
                  value: agree,
                  onChanged: (value) {
                    setState(() {
                      agree = value ?? false;
                    });
                  },
                ),
                Text(
                  'I am ready to distribute',
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
            ElevatedButton(
              child: Text('Confirm'),
              onPressed: agree ? _doSomething : null,
            ),
          ]),
        ));
  }
}
