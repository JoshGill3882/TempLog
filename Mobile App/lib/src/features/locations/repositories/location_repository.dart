import 'package:templog/firebase_options.dart';
import 'package:templog/src/features/locations/data/location.dart';

class LocationRepository {
  getLocations(String businessCode) async {
    return await DefaultFirebaseOptions
      .database
      .collection(businessCode)
      .doc("Business Info")
      .collection("Locations")
      .get();
  }

  addLocation(String businessCode, Location location) async {
    return await DefaultFirebaseOptions.database
      .collection(businessCode)
      .doc("Business Info")
      .collection("Locations")
      .add({
        "Name": location.locationName,
        "Address": location.locationAddress,
        "City": location.locationCity,
        "Post Code": location.locationPostCode
      });
  }

  setLocation(String businessCode, Location location) async {
    await DefaultFirebaseOptions.database
      .collection(businessCode)
      .doc("Business Info")
      .collection("Locations")
      .doc(location.locationId)
      .set({
        "ID": location.locationId,
        "Name": location.locationName,
        "Address": location.locationAddress,
        "City": location.locationCity,
        "Post Code": location.locationPostCode
      });
  }
}