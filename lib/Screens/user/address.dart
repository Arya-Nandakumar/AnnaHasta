import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';

class AddressPage extends StatefulWidget {
  @override
  State<AddressPage> createState() => _AddressPageState();
}

class _AddressPageState extends State<AddressPage> {
  TextEditingController _locationController = TextEditingController();
  GoogleMapsPlaces _places =
      GoogleMapsPlaces(apiKey: 'AIzaSyAu4-37ES5w9oa7mgazzYRe07oOST101zU');
  List<Prediction> _predictions = [];

  void _onTextChanged(String value) async {
    if (value.isEmpty) {
      setState(() {
        _predictions = [];
      });
      return;
    }

    final result = await _places.autocomplete(value);
    if (result.isOkay) {
      setState(() {
        _predictions = result.predictions;
      });
    } else {
      setState(() {
        _predictions = [];
      });
    }
  }

  void _onPredictionSelected(Prediction prediction) async {
    if (prediction.placeId != null) {
      final result = await _places.getDetailsByPlaceId(prediction.placeId!);
      if (result.isOkay) {
        final lat = result.result.geometry!.location.lat;
        final lng = result.result.geometry!.location.lng;

       Navigator.pop(context, result.result.formattedAddress,
      );
      }
    }
  }

  @override
  void dispose() {
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 4,
        title: TextField(
          controller: _locationController,
          onChanged: _onTextChanged,
          decoration: InputDecoration(
            hintText: "Search Location",
            border: InputBorder.none,
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: _predictions.length,
        itemBuilder: (context, index) {
          final prediction = _predictions[index];
          return ListTile(
            title: Text(prediction.description ?? ''),
            onTap: () => _onPredictionSelected(prediction),
          );
        },
      ),
    );
  }
}
