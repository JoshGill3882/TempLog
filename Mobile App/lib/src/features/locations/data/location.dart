import 'package:templog/src/features/devices/data/device.dart';

class Location {
  String locationId;
  String locationName;
  String locationAddress;
  String locationCity;
  String locationPostCode;
  List<Device> devices;

  Location(this.locationId, this.locationName, this.locationAddress, this.locationCity, this.locationPostCode, this.devices);
}
