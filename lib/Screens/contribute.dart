import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:annahasta/models/cont_model.dart';
import 'package:annahasta/models/remote_data_source/firestore_helper.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:annahasta/Screens/home.dart';
import 'package:annahasta/Functions/bottomnav.dart';

class ContributePage extends StatefulWidget {
  @override
  _ContributePageState createState() => _ContributePageState();
}

enum FoodType { veg, nonVeg }

class _ContributePageState extends State<ContributePage> {
  FoodType _foodType = FoodType.veg;
  TextEditingController _locationController = TextEditingController();
  TextEditingController _quantityController = TextEditingController();
  TextEditingController _dateTimeController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _menuController = TextEditingController();
  late DateTime selectedDateTime;
  final _formKey = GlobalKey<FormState>();

  Future<Null> _selectDateAndTime(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDateTime,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDateTime)
      setState(() {
        selectedDateTime = picked;
        _dateTimeController.text =
            "${DateFormat('dd/MM/yyyy HH:mm').format(selectedDateTime)}";
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 4,
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
                controller: _dateTimeController,
                decoration: const InputDecoration(
                  labelText: "Date and Time",
                  focusedBorder: OutlineInputBorder(),
                ),
                onTap: () async {
                  final selectedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now().subtract(Duration(days: 365)),
                    lastDate: DateTime.now().add(Duration(days: 365)),
                  );
                  if (selectedDate != null) {
                    final selectedTime = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );
                    if (selectedTime != null) {
                      _dateTimeController.text =
                          "${DateFormat("dd-MM-yy").format(selectedDate)} ${selectedTime.format(context)}";
                    }
                  }
                },
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
            SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Radio(
                  value: FoodType.veg,
                  groupValue: _foodType,
                  onChanged: (FoodType? value) {
                    setState(() {
                      _foodType = value!;
                    });
                  },
                ),
                Text('Veg'),
                Radio(
                  value: FoodType.nonVeg,
                  groupValue: _foodType,
                  onChanged: (FoodType? value) {
                    setState(() {
                      _foodType = value!;
                    });
                  },
                ),
                Text('Non Veg'),
              ],
            ),
            SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(150, 50),
                  ),
                  onPressed: () {
                    FirestoreHelper.create(
                      ContModel(
                          boxID: _locationController.text,
                          caseID: _quantityController.text,
                          contents: _dateTimeController.text,
                          vname: _phoneController.text,
                          isveg: _foodType.toString()),
                    ).then((value) {
                      Fluttertoast.showToast(msg: 'Posted!');
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => HomePage()),
                      );
                    });
                  },
                  child: const Text('Create'),
                ),
              ],
            ),
          ],
        ));
  }
}
