import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:annahasta/models/cont_model.dart';

class DistributedHelper {
  static Stream<List<ContModel>> read() {
    final contCollection = FirebaseFirestore.instance.collection("distributed");
    return contCollection.snapshots().map((querySnapshot) =>
        querySnapshot.docs.map((e) => ContModel.fromSnapshot(e)).toList());
  }

  static Future create(ContModel posting) async {
    final contCollection = FirebaseFirestore.instance.collection("distributed");

    final newUser = ContModel(
      locationData: posting.locationData,
      phoneNumber: posting.phoneNumber,
      quantityCount: posting.quantityCount,
      dateAndTime: posting.dateAndTime,
      isveg: posting.isveg,
      itemtype: posting.itemtype,
      userid: posting.userid,
      lat: posting.lat,
      lng: posting.lng,
    ).toJson();

    try {
      await contCollection.add(newUser);
    } catch (e) {
      print("some error occurred: $e");
    }
  }

  static Future delete(String? documentId) async {
    final contCollection = FirebaseFirestore.instance.collection("distributed");
    try {
      await contCollection.doc(documentId).delete();
    } catch (e) {
      print("Error deleting entry: $e");
    }
  }
}
