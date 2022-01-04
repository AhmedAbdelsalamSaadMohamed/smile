import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smile/model/report_model.dart';
import 'package:smile/utils/constants.dart';

class ReportFireStore{
  final CollectionReference _reportCollection =FirebaseFirestore.instance.collection(collectionReports);
  addReport(ReportModel report){
    _reportCollection.add(report.toJson()).then((value) {
    report.id = value.id;
      _reportCollection.doc(value.id).update(report.toJson());
    });
  }
}