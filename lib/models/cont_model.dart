import 'package:cloud_firestore/cloud_firestore.dart';

class ContModel {
  final String? boxID;
  final String? caseID;
  final String? vname;
  final String? contents;
  final String? isveg;
  final String? itemtype;

  ContModel({this.boxID, this.caseID, this.vname, this.contents, this.isveg, this.itemtype});

  factory ContModel.fromSnapshot(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return ContModel(
        vname: snapshot['vname'],
        boxID: snapshot['boxID'],
        caseID: snapshot['caseID'],
        contents: snapshot['contents'],
        isveg: snapshot['isveg'],
        itemtype: snapshot['itemtype']);
  }

  Map<String, dynamic> toJson() => {
        "vname": vname,
        "boxID": boxID,
        "caseID": caseID,
        "contents": contents,
        "isveg": isveg,
        "itemtype": itemtype,
      };
}
