import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:templog/firebase_options.dart';
import 'package:templog/src/features/templogs/data/templog.dart';

class TemplogRepository {
  Future<int> getNumOfTemplogs(String businessCode, DateTime date) async {
    final docRef = await DefaultFirebaseOptions
      .database
      .collection(businessCode)
      .doc("Data")
      .collection(date.year.toString())
      .doc(date.month.toString())
      .get();

    final data = docRef.data();
    if (data != null) { return data["Monthly Templogs"]; }
    else { return 0; }
  }

  updateMonthlyTemplogNumber(String businessCode, DateTime date, int newNumber) async {
    await DefaultFirebaseOptions
      .database
      .collection(businessCode)
      .doc("Data")
      .collection(date.year.toString())
      .doc(date.month.toString())
      .set({
        "Monthly Templogs": newNumber
      }, SetOptions(merge: true));
  }

  getTemplogs(String businessCode, DateTime date, String locationId) async {
    return await DefaultFirebaseOptions
      .database
      .collection(businessCode)
      .doc("Data")
      .collection(date.year.toString())
      .doc(date.month.toString())
      .collection(date.day.toString())
      .doc(locationId)
      .collection("Templogs")
      .get();
  }

  addTempLog(String businessCode, Templog templog) async {
    return await DefaultFirebaseOptions
      .database
      .collection(businessCode)
      .doc("Data")
      .collection(templog.dateTime.year.toString())
      .doc(templog.dateTime.month.toString())
      .collection(templog.dateTime.day.toString())
      .doc(templog.location.locationId)
      .collection("Templogs")
      .add({
        "Device Name": templog.deviceName,
        "Timestamp": Timestamp.fromDate(templog.dateTime),
        "Temperature": templog.temperature,
        "Probe Used": templog.probeUsed,
        "Signature": templog.signature,
        "Comments": templog.comments
      });
  }

  setTemplog(String businessCode, Templog templog) async {
    return await DefaultFirebaseOptions
      .database
      .collection(businessCode)
      .doc("Data")
      .collection(templog.dateTime.year.toString())
      .doc(templog.dateTime.month.toString())
      .collection(templog.dateTime.day.toString())
      .doc(templog.location.locationId)
      .collection("Templogs")
      .doc(templog.id)
      .set({
        "ID": templog.id,
        "Device Name": templog.deviceName,
        "Timestamp": Timestamp.fromDate(templog.dateTime),
        "Temperature": templog.temperature,
        "Probe Used": templog.probeUsed,
        "Signature": templog.signature,
        "Comments": templog.comments
      });
  }

  deleteTemplog(String businessCode, Templog templog) async {
    await DefaultFirebaseOptions
      .database
      .collection(businessCode)
      .doc("Data")
      .collection(templog.dateTime.year.toString())
      .doc(templog.dateTime.month.toString())
      .collection(templog.dateTime.day.toString())
      .doc(templog.location.locationId)
      .collection("Templogs")
      .doc(templog.id)
      .delete();
  }
}