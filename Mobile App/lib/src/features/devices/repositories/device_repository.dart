import 'package:templog/firebase_options.dart';
import 'package:templog/src/features/devices/data/device.dart';

class DeviceRepository {
  getDevices(String businessCode, String locationId) async {
    return await DefaultFirebaseOptions
      .database
      .collection(businessCode)
      .doc("Business Info")
      .collection("Locations")
      .doc(locationId)
      .collection("Devices")
      .get();
  }

  addDevice(String businessCode, String locationId, Device device) async {
    return await DefaultFirebaseOptions
      .database
      .collection(businessCode)
      .doc("Business Info")
      .collection("Locations")
      .doc(locationId)
      .collection("Devices")
      .add({
        "Name": device.deviceName,
        "Type": device.deviceType.name,
        "Comments": device.comments
      });
  }

  setDevice(String businessCode, String locationId, Device device) async {
    return await DefaultFirebaseOptions
      .database
      .collection(businessCode)
      .doc("Business Info")
      .collection("Locations")
      .doc(locationId)
      .collection("Devices")
      .doc(device.deviceId)
      .set({
        "ID": device.deviceId,
        "Name": device.deviceName,
        "Type": device.deviceType.name,
        "Comments": device.comments
      });
  }

  deleteDevice(String businessCode, String locationId, Device device) async {
    await DefaultFirebaseOptions
      .database
      .collection(businessCode)
      .doc("Business Info")
      .collection("Locations")
      .doc(locationId)
      .collection("Devices")
      .doc(device.deviceId)
      .delete();
  }
}