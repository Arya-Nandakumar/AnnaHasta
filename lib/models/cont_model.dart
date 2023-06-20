import 'package:cloud_firestore/cloud_firestore.dart';

class ContModel {
  final String? locationData;
  final String? quantityCount;
  final String? phoneNumber;
  final String? dateAndTime;
  final String? isveg;
  final String? itemtype;
  final String? userid;
  String? documentID;
  double? lat;
  double? lng;

  ContModel(
      {this.locationData,
      this.quantityCount,
      this.phoneNumber,
      this.dateAndTime,
      this.isveg,
      this.itemtype,
      this.userid,
      this.documentID,
      this.lat,
      this.lng});

  factory ContModel.fromSnapshot(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return ContModel(
      phoneNumber: snapshot['phoneNumber'],
      locationData: snapshot['locationData'],
      quantityCount: snapshot['quantityCount'],
      dateAndTime: snapshot['dateAndTime'],
      isveg: snapshot['isveg'],
      itemtype: snapshot['itemtype'],
      userid: snapshot['userid'],
      documentID: snap.id,
      lat: snapshot['lat'],
      lng: snapshot['lng'],
    );
  }

  Map<String, dynamic> toJson() => {
        "phoneNumber": phoneNumber,
        "locationData": locationData,
        "quantityCount": quantityCount,
        "dateAndTime": dateAndTime,
        "isveg": isveg,
        "itemtype": itemtype,
        "userid": userid,
        "lat": lat,
        "lng": lng,
      };
}
