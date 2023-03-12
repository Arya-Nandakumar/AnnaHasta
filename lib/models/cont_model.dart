import 'package:cloud_firestore/cloud_firestore.dart';

class ContModel {
  final String? boxID;
  final String? caseID;
  final String? vname;
  final String? contents;
  final String? isveg;

  ContModel({this.boxID, this.caseID, this.vname, this.contents, this.isveg});

  factory ContModel.fromSnapshot(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return ContModel(
        vname: snapshot['vname'],
        boxID: snapshot['boxID'],
        caseID: snapshot['caseID'],
        contents: snapshot['contents'],
        isveg: snapshot['isveg']);
  }

  Map<String, dynamic> toJson() => {
        "vname": vname,
        "boxID": boxID,
        "caseID": caseID,
        "contents": contents,
        "isveg": isveg,
      };
}
