import 'package:templog/src/features/locations/data/location.dart';

class Templog {
  String id;
  Location location;
  String deviceName;
  DateTime dateTime;
  double temperature;
  bool probeUsed;
  String signature;
  String comments;

  Templog({
    required this.id,
    required this.location,
    required this.deviceName,
    required this.dateTime,
    required this.temperature,
    required this.probeUsed,
    required this.signature,
    required this.comments
  });
}
