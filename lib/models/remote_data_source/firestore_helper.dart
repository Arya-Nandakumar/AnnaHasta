import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:annahasta/models/cont_model.dart';

class FirestoreHelper {
  static Stream<List<ContModel>> read() {
    final contCollection = FirebaseFirestore.instance.collection("listings");
    return contCollection.snapshots().map((querySnapshot) =>
        querySnapshot.docs.map((e) => ContModel.fromSnapshot(e)).toList());
  }

  static Future create(ContModel box) async {
  final contCollection = FirebaseFirestore.instance.collection("listings");

  final newUser = ContModel(
    boxID: box.boxID,
    vname: box.vname,
    caseID: box.caseID,
    contents: box.contents,
    isveg: box.isveg,
    itemtype: box.itemtype,
    userid: box.userid,
  ).toJson();

  try {
    await contCollection.add(newUser);
  } catch (e) {
    print("some error occurred: $e");
  }
}
static Future delete(String? documentId) async {
    final contCollection = FirebaseFirestore.instance.collection("listings");
    try {
      await contCollection.doc(documentId).delete();
    } catch (e) {
      print("Error deleting entry: $e");
    }
  }
}
