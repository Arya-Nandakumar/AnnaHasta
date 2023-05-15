import 'package:annahasta/Screens/ngo/confirmgif.dart';
import 'package:annahasta/Screens/user/contribute.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/cont_model.dart';
import '../../models/remote_data_source/distributer_helper.dart';
import '../../models/remote_data_source/firestore_helper.dart';

class ProceedPage extends StatefulWidget {
  const ProceedPage({super.key, required this.documentId});

  final String documentId;
  @override
  _ProceedPageState createState() => _ProceedPageState();
}

class _ProceedPageState extends State<ProceedPage> {
  @override
  void initState() {
    super.initState();
    _fetchUserID();
  }

  void _fetchUserID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userID = (prefs.getString('userid') ?? '');
      final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
      if (isDarkMode == true) {
        DefaultAssetBundle.of(context)
            .loadString('assets/mapDarkTheme.json')
            .then((string) {
          mapStyle = string;
        }).catchError((error) {
          print(error.toString());
        });
      } else {
        DefaultAssetBundle.of(context)
            .loadString('assets/mapLightTheme.json')
            .then((string) {
          mapStyle = string;
        }).catchError((error) {
          print(error.toString());
        });
      }
    });
  }

  late String mapStyle;
  late String documentId;
  String? userID;
  late GoogleMapController mapController;
  bool agree = false;
  late String location;
  late String quantity;
  late String date;
  late String phone;
  late String type;
  late double lat;
  late double lng;
  late String itemtype;

  void _doSomething() {
    DistributedHelper.create(
      ContModel(
        boxID: location,
        caseID: quantity,
        vname: phone,
        contents: date,
        itemtype: itemtype,
        isveg: type,
        lat: lat,
        lng: lng,
        userid: userID,
      ),
    ).then((value) {
      FirestoreHelper.delete(documentId).then(
        (value) {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const Donategif()));
        },
      );
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final Color color = isDarkMode ? Colors.white : Colors.black;
    documentId = ModalRoute.of(context)!.settings.arguments as String;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Proceed"),
        centerTitle: true,
        elevation: 4,
      ),
      body: Column(children: [
        StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('listings')
              .doc(documentId)
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData) {
              return const Center(child: Text('No data found'));
            } else {
              Map<String, dynamic> data =
                  snapshot.data!.data() as Map<String, dynamic>;
              location = data['boxID'] ?? '';
              quantity = data['caseID'] ?? '';
              date = data['contents'] ?? '';
              phone = data['vname'] ?? '';
              type = data['isveg'] ?? '';
              lat = data['lat'] ?? '';
              lng = data['lng'] ?? '';
              itemtype = data['itemtype'] ?? '';

              return Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(20),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: color,
                          width: 1,
                        ),
                      ),
                      padding: EdgeInsets.all(8),
                      child: Container(
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10.0),
                                child: SizedBox(
                                  width: double.infinity,
                                  height: 200,
                                  child: GoogleMap(
                                    initialCameraPosition: CameraPosition(
                                      target: LatLng(lat, lng),
                                      zoom: 15.0,
                                    ),
                                    markers: <Marker>{
                                      Marker(
                                        markerId: const MarkerId('markerId'),
                                        position: LatLng(lat, lng),
                                      ),
                                    },
                                    mapType: MapType.normal,
                                    zoomGesturesEnabled: false,
                                    scrollGesturesEnabled: false,
                                    tiltGesturesEnabled: false,
                                    rotateGesturesEnabled: false,
                                    myLocationButtonEnabled: false,
                                    onMapCreated:
                                        (GoogleMapController controller) {
                                      controller.setMapStyle(mapStyle);
                                    },
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                "$location",
                                style: const TextStyle(fontSize: 20),
                              ),
                              if (type == "FoodType.veg")
                                Text(
                                  'Food Type: Veg',
                                  style: TextStyle(fontSize: 15),
                                ),
                              if (type == "FoodType.nonVeg")
                                Text(
                                  'Food Type: Non Veg',
                                  style: TextStyle(fontSize: 15),
                                ),
                              if (type == "thing")
                                Text(
                                  'Item: $itemtype',
                                  style: TextStyle(fontSize: 15),
                                ),
                              Text(
                                "Quantity: $quantity",
                                style: const TextStyle(fontSize: 15),
                              ),
                              Text(
                                "Date: $date",
                                style: const TextStyle(fontSize: 15),
                              ),
                              Text(
                                "Phone Number: $phone",
                                style: const TextStyle(fontSize: 15),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }
          },
        ),
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
            const Text(
              'I am ready to distribute',
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
        const SizedBox(height: 15),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(150, 50),
          ),
          onPressed: agree ? _doSomething : null,
          child: const Text('Confirm'),
        ),
      ]),
    );
  }
}
