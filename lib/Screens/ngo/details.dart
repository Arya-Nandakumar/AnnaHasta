import 'package:annahasta/Screens/ngo/home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:annahasta/models/cont_model.dart';
import 'package:annahasta/models/remote_data_source/firestore_helper.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp();
  runApp(
    MaterialApp(
      home: ReadPage(),
    ),
  );
}

var caseID, contents, vname, boxID;
TextEditingController _boxIDController = TextEditingController();
Future getDetails() async {
  var collection = FirebaseFirestore.instance.collection('boxes');
  var docSnapshot = await collection.doc(_boxIDController.text).get();
  if (docSnapshot.exists) {
    Map<String, dynamic>? data = docSnapshot.data();
    contents = data?['contents'];
    caseID = data?['caseID'];
    vname = data?['vname'];
    boxID = _boxIDController.text;
  }
}

class ReadPage extends StatelessWidget {
  ReadPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Search'),
          backgroundColor: Color.fromARGB(255, 87, 38, 20),
        ),
        body: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(16.0),
              child: TextFormField(
                controller: _boxIDController,
                decoration: const InputDecoration(
                  labelText: "Box ID",
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Color.fromARGB(255, 87, 38, 20), width: 2.0),
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                ElevatedButton(
                  onPressed: () {
                    getDetails();
                  },
                  child: const Text('Fetch Details'),
                ),
                ElevatedButton(
                  onPressed: () {
                    _navigateToNextScreen(context);
                  },
                  child: const Text('Show Details'),
                ),
              ],
            ),
          ],
        ));
  }

  void _navigateToNextScreen(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => NewScreen()));
  }
}

class NewScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Box " + boxID)),
        body: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Text("Case ID: " + caseID),
            ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Text("Contents: " + contents),
            ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Text("Modified By: " + vname),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                ElevatedButton(
                  onPressed: () {
                    HomePage();
                  },
                  child: const Text('Close'),
                ),
              ],
            ),
          ],
        ));
  }
}
