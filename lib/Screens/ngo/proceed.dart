import 'package:annahasta/Screens/ngo/confirmgif.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ProceedPage extends StatefulWidget {
  @override
  _ProceedPageState createState() => _ProceedPageState();
}

class _ProceedPageState extends State<ProceedPage> {
  late GoogleMapController mapController;
    final LatLng markerCoordinates = LatLng(9.510009599999998, 76.5513594);
      bool agree = false;
  void _doSomething() {
    Navigator.pushReplacement(

      context, 
      MaterialPageRoute(builder: (context) => Donategif()));
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Proceed"),
          centerTitle: true,
          elevation: 4,
        ),
        body: 
        Padding(
      padding: EdgeInsets.all(20),
      child:Column(
         crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
      width: double.infinity,
      height: 300,
      child: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: markerCoordinates,
          zoom: 15.0,
        ),
        markers: Set<Marker>.from([
          Marker(
            markerId: MarkerId('markerId'),
            position: markerCoordinates,
          ),
        ]),
        zoomGesturesEnabled: false,
        scrollGesturesEnabled: false,
        tiltGesturesEnabled: false,
        rotateGesturesEnabled: false,
        myLocationButtonEnabled: false,
        onMapCreated: (GoogleMapController controller) {
        },
      ),
    ),
    SizedBox(height: 20,),
    Center(
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
        )
      ]
      ),
        ),
      );
  }
}
