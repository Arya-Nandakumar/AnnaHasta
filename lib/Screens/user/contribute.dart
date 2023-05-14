import 'package:annahasta/Screens/user/address.dart';
import 'package:annahasta/Screens/user/home.dart';
import 'package:flutter/material.dart';
import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Functions/colorhex.dart';
import '../../Functions/newnavbar.dart';
import '../../models/cont_model.dart';
import '../../models/remote_data_source/firestore_helper.dart';

class ContributePage extends StatefulWidget {
  const ContributePage({super.key});

  @override
  _ContributePageState createState() => _ContributePageState();
}

enum FoodType { veg, nonVeg }

final List<String> _tabs = ['Food', 'Things'];

class _ContributePageState extends State<ContributePage> {
  FoodType _foodType = FoodType.veg;
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _dateTimeController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _menuController = TextEditingController();
  final TextEditingController _itemnameController = TextEditingController();
  late DateTime selectedDateTime;
  String? userID;
  String buttonText = 'Select Location'; // The initial text on the button
  String result = '';
  late Map locationMap;
  late double lat;
  late double lng;
  List<GlobalKey<FormState>> formKeys = [
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
    GlobalKey<FormState>()
  ];

  @override
  void initState() {
    super.initState();
    _fetchUserID();
  }

  void _fetchUserID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userID = (prefs.getString('userid') ?? '');
    });
  }

  Future<void> _selectDateAndTime(BuildContext context) async {
    final now = DateTime.now();
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDateTime,
      firstDate: now,
      lastDate: DateTime(2101),
      selectableDayPredicate: (date) =>
          date.isAfter(now.subtract(const Duration(days: 1))),
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
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final Color color = isDarkMode ? Colors.white : Colors.black;
    return DefaultTabController(
      length: 2, // Number of tabs
      child: Scaffold(
        bottomNavigationBar: SpotifyBottomNavigationBar(
          initialIndex: 1,
          onItemTapped: (index) {
            // Do something when an item in the navigation bar is tapped
          },
        ),
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(120.0), // here the desired height
          child: SafeArea(
            top: true, // Add top padding
            minimum: EdgeInsets.only(top: 60), // Set the top padding value
            child: AppBar(
              title: Text(
                "Contribute",
                style: TextStyle(fontSize: 30),
              ),
              bottom: PreferredSize(
                preferredSize: Size.fromHeight(40),
                child: Padding(
                  padding: EdgeInsets.only(left: 10), // Add left padding
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: TabBar(
                        indicatorSize: TabBarIndicatorSize.tab,
                        indicator: new BubbleTabIndicator(
                          indicatorHeight: 25.0,
                          indicatorColor:
                              buildMaterialColor(const Color(0xFF5823f9)),
                          tabBarIndicatorSize: TabBarIndicatorSize.tab,
                        ),
                        isScrollable: true,
                        tabs: _tabs
                            .map((label) => Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 0, vertical: 0),
                                child: Tab(
                                  child: Text(
                                    "$label",
                                    style: TextStyle(
                                      color: color,
                                    ),
                                  ),
                                )))
                            .toList(),
                        dividerColor: Colors.transparent),
                  ),
                ),
              ),
            ),
          ),
        ),
        body: TabBarView(
          physics: const NeverScrollableScrollPhysics(),
          children: [
            Container(
                child: Column(
              children: <Widget>[
                const SizedBox(height: 15.0),
                Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () async {
                          locationMap = await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const AddressPage()),
                          );
                          result = locationMap['location'];
                          lat = locationMap['lat'];
                          lng = locationMap['lng'];
                          changeText();
                        },
                        child: Text(buttonText),
                      ),
                    )),
                Padding(
                  padding: const EdgeInsets.all(16.0),
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
                  padding: const EdgeInsets.all(16.0),
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
                            lastDate:
                                DateTime.now().add(const Duration(days: 7)),
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
                          return null;
                        }),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
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
                const SizedBox(height: 20.0),
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
                    const Text('Veg'),
                    Radio(
                      value: FoodType.nonVeg,
                      groupValue: _foodType,
                      onChanged: (FoodType? value) {
                        setState(() {
                          _foodType = value!;
                        });
                      },
                    ),
                    const Text('Non Veg'),
                  ],
                ),
                const SizedBox(height: 20.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(150, 50),
                      ),
                      onPressed: () {
                        if ((formKeys[0].currentState!.validate()) &&
                            (formKeys[1].currentState!.validate()) &&
                            (formKeys[2].currentState!.validate())) {
                          FirestoreHelper.create(
                            ContModel(
                                boxID: result,
                                caseID: _quantityController.text,
                                contents: _dateTimeController.text,
                                vname: _phoneController.text,
                                isveg: _foodType.toString(),
                                userid: userID,
                                itemtype: 'food',
                                lat: lat,
                                lng: lng),
                          ).then((value) {
                            Fluttertoast.showToast(msg: 'Posted!');
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const UserHomePage()),
                            );
                          });
                        }
                      },
                      child: const Text('Create'),
                    ),
                  ],
                ),
              ],
            )),
            //SECOND TAB CODE BEGINS
            Container(
              child: Column(children: <Widget>[
                const SizedBox(height: 15.0),
                Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () async {
                          locationMap = await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const AddressPage()),
                          );
                          result = locationMap['location'];
                          lat = locationMap['lat'];
                          lng = locationMap['lng'];
                          changeText();
                        },
                        child: Text(buttonText),
                      ),
                    )),
                Padding(
                    padding: const EdgeInsets.all(16),
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
                            return null;
                          }),
                    )),
                Padding(
                  padding: const EdgeInsets.all(16.0),
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
                  padding: const EdgeInsets.all(16.0),
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
                            lastDate:
                                DateTime.now().add(const Duration(days: 7)),
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
                          return null;
                        }),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
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
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          minimumSize: const Size(150, 50)),
                      onPressed: () {
                        if ((formKeys[0].currentState!.validate()) &&
                            (formKeys[1].currentState!.validate()) &&
                            (formKeys[2].currentState!.validate()) &&
                            (formKeys[3].currentState!.validate())) {
                          FirestoreHelper.create(ContModel(
                                  boxID: result,
                                  caseID: _quantityController.text,
                                  vname: _phoneController.text,
                                  contents: _dateTimeController.text,
                                  itemtype: _itemnameController.text,
                                  isveg: "thing",
                                  userid: userID,
                                  lat: lat,
                                  lng: lng))
                              .then((value) {
                            Fluttertoast.showToast(msg: "Item Added!");
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const UserHomePage()),
                            );
                          });
                        }
                      },
                      child: const Text("Add Item"),
                    )
                  ],
                ),
              ]),
            )
          ],
        ),
      ),
    );
  }
}
