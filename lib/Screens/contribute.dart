import 'package:flutter/material.dart';
import 'package:annahasta/main.dart';
import 'package:annahasta/Functions/bottomnav.dart';

class ContributePage extends StatelessWidget {
  TextEditingController _locationController = TextEditingController();
  TextEditingController _quantityController = TextEditingController();
  TextEditingController _contentsController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Contribute'),
          automaticallyImplyLeading: false,
        ),
        bottomNavigationBar: BottomNav(selectedIndex: 1),
        body: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(16.0),
              child: TextFormField(
                controller: _locationController,
                decoration: const InputDecoration(
                  labelText: "Location",
                  focusedBorder: OutlineInputBorder(),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: TextFormField(
                controller: _quantityController,
                decoration: const InputDecoration(
                  labelText: "Quantity",
                  focusedBorder: OutlineInputBorder(),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: TextFormField(
                controller: _contentsController,
                decoration: const InputDecoration(
                  labelText: "Date and Time",
                  focusedBorder: OutlineInputBorder(),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(
                  labelText: "Phone Number",
                  focusedBorder: OutlineInputBorder(),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                ElevatedButton(
                  onPressed: () {},
                  child: const Text('Create'),
                ),
              ],
            ),
          ],
        ));
  }
}
