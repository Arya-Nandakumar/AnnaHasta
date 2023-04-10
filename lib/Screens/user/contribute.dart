import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:annahasta/models/cont_model.dart';
import 'package:annahasta/models/remote_data_source/firestore_helper.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:annahasta/Screens/ngo/home.dart';
import 'package:annahasta/Functions/userbottomnav.dart';

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

  Future<void> _selectDateAndTime(BuildContext context) async {
    final now = DateTime.now();
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDateTime,
      firstDate: now,
      lastDate: DateTime(2101),
      selectableDayPredicate: (date) =>
          date.isAfter(now.subtract(Duration(days: 1))),
    );
    if (pickedDate == null) return;
    final pickedDateTime =
        DateTime(pickedDate.year, pickedDate.month, pickedDate.day);
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(selectedDateTime),
    );
    if (pickedTime == null) return;
    final pickedDateTimeWithTime = pickedDateTime
        .add(Duration(hours: pickedTime.hour, minutes: pickedTime.minute));
    if (pickedDateTimeWithTime.isBefore(DateTime.now())) return;
    setState(() {
      selectedDateTime = pickedDateTimeWithTime;
      _dateTimeController.text =
          DateFormat('dd/MM/yyyy HH:mm').format(selectedDateTime);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 4,
          centerTitle: true,
          title: Text('Contribute'),
        ),
        bottomNavigationBar: UserBottomNav(selectedIndex: 1),
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
              child: Form(
                key: _formKey,
                child: TextFormField(
                  controller: _quantityController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: "Quantity",
                    focusedBorder: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter a value greater than 10';
                    }
                    final intValue = int.tryParse(value);
                    if (intValue == null) {
                      return 'Please enter a valid integer value greater than 10';
                    }
                    if (intValue <= 10) {
                      return 'Please enter a value greater than 10';
                    }
                    if (value.contains("-")) {
                      return 'Please enter a value that is not negative';
                    }
                    return null;
                  },
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
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(Duration(days: 7)),
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
