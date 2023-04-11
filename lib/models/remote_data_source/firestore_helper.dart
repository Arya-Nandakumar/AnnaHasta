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


  static Future update(ContModel box) async {
    final contCollection = FirebaseFirestore.instance.collection("listings");
    final bid = contCollection.doc(box.boxID).id;
    final docRef = contCollection.doc(bid);

    final newUser = ContModel(
            boxID: box.boxID,
            vname: box.vname,
            caseID: box.caseID,
            contents: box.contents,
            isveg: box.isveg,
            itemtype: box.itemtype,
            userid: box.userid)
        .toJson();

    try {
      await docRef.set(newUser);
    } catch (e) {
      print("some error occured $e");
    }
  }

  static Future delete(ContModel user) async {
    final contCollection = FirebaseFirestore.instance.collection("listings");
    final docRef = contCollection.doc(user.boxID).delete();
  }
}
