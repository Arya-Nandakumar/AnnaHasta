import 'package:annahasta/Functions/userbottomnav.dart';
import 'package:annahasta/Screens/user/address.dart';
import 'package:annahasta/Screens/user/home.dart';
import 'package:annahasta/models/cont_model.dart';
import 'package:annahasta/models/remote_data_source/firestore_helper.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

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
  TextEditingController _itemnameController = TextEditingController();
  late DateTime selectedDateTime;
  String? userID;
  String buttonText = 'Select Location'; // The initial text on the button
  String result = '';
  List<GlobalKey<FormState>> formKeys = [GlobalKey<FormState>(), GlobalKey<FormState>(), GlobalKey<FormState>(), GlobalKey<FormState>()];

  @override
  void initState() {
    super.initState();
    _fetchUserID();
    }
  void _fetchUserID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userID = (prefs.getString('userid') ?? '');
    }
    );
  }

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

  void changeText() {
    setState(() {
      buttonText = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
        elevation: 4,
        centerTitle: true,
        title: Text('Contribute'),
        automaticallyImplyLeading: false,
            bottom: const TabBar(
              tabs: [
                Tab(text: "Food",),
                Tab(text: "Things",),
              ],
            ),
          ),
                  bottomNavigationBar: UserBottomNav(selectedIndex: 1),
          body: TabBarView(
  children: [
    Container(
      child: Column(
          children: <Widget>[
            SizedBox(height: 15.0),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Container(
      width: double.infinity,
      child: OutlinedButton(
      onPressed: () async {
            result = await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddressPage()),
            );

            // Handle the returned result
            if (result != null) {
              changeText();
            }
          },
      child: Text(buttonText),
    ),
              )
            ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Form(
                key: formKeys[0],
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
              child: Form(
                key: formKeys[1],
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
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter a valid date and time';
                    }
                  }
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Form(
                key: formKeys[2],
                child: TextFormField(
                  controller: _phoneController,
                  decoration: const InputDecoration(
                    labelText: "Phone Number",
                    focusedBorder: OutlineInputBorder(),
                  ),
                  validator: (value) {
        if (value!.isEmpty) {
          return 'Please enter a phone number';
        }
        if (value.length != 10) {
          return 'Phone number should be exactly 10 digits';
        }
        return null;
      },
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
                    if ((formKeys[0].currentState!.validate())&&(formKeys[1].currentState!.validate())&&(formKeys[2].currentState!.validate())) {
                      FirestoreHelper.create(
                        ContModel(
                            boxID: result,
                            caseID: _quantityController.text,
                            contents: _dateTimeController.text,
                            vname: _phoneController.text,
                            isveg: _foodType.toString(),
                            userid: userID,
                             itemtype: 'food'),

                      ).then((value) {
                        Fluttertoast.showToast(msg: 'Posted!');
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => UserHomePage()),
                        );
                      });
                    }
                  },
                  child: const Text('Create'),
                ),
              ],
            ),
          ],
        )
    ),
    //SECOND TAB CODE BEGINS
    Container(
      child: Column(
        children: <Widget>[
        SizedBox(height: 15.0),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Container(
      width: double.infinity,
      child: OutlinedButton(
      onPressed: () async {
            result = await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddressPage()),
            );

            // Handle the returned result
            if (result != null) {
              changeText();
            }
          },
      child: Text(buttonText),
    ),
              )
            ),
        Padding(
            padding: EdgeInsets.all(16),
            child: Form(
              key: formKeys[3],
              child: TextFormField(
                controller: _itemnameController,
                decoration: const InputDecoration(
                  labelText: "Item name",
                  focusedBorder: OutlineInputBorder(),
                ),
                validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter the item name';
                    }
                  }
              ),
            )),
        Padding(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: formKeys[0],
            child: TextFormField(
              controller: _quantityController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Number of items",
                focusedBorder: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter a value';
                }
                final intValue = int.tryParse(value);
                if (intValue == null) {
                  return 'Please enter a valid integer value';
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
          child: Form(
            key: formKeys[1],
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
              validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter a valid date and time';
                    }
                  }
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(16),
          child: Form(
            key: formKeys[2],
            child: TextFormField(
              controller: _phoneController,
              decoration: const InputDecoration(
                labelText: "Phone Number",
                focusedBorder: OutlineInputBorder(),
              ),
              validator: (value) {
        if (value!.isEmpty) {
          return 'Please enter a phone number';
        }
        if (value.length != 10) {
          return 'Phone number should be exactly 10 digits';
        }
        return null;
      },
            ),
          ),
        ),
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            ElevatedButton(
              style: ElevatedButton.styleFrom(minimumSize: Size(150, 50)),
              onPressed: () {
                if ((formKeys[0].currentState!.validate())&&(formKeys[1].currentState!.validate())&&(formKeys[2].currentState!.validate())&&(formKeys[3].currentState!.validate())) {
                  FirestoreHelper.create(ContModel(
                    boxID: result,
                    caseID: _quantityController.text,
                    vname: _phoneController.text,
                    contents: _dateTimeController.text,
                    itemtype: _itemnameController.text,
                    isveg: "thing",
                    userid: userID,
                  )).then((value) {
                    Fluttertoast.showToast(msg: "Item Added!");
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => UserHomePage()),
                    );
                  });
                }
              },
              child: Text("Add Item"),
            )
          ],
        ),
      ]
      ),
    )
  ],
),

    ),
        );
  }
}

