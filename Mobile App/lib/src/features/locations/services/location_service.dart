import 'package:firebase_auth/firebase_auth.dart';
import 'package:templog/firebase_options.dart';
import 'package:templog/src/features/devices/data/device.dart';
import 'package:templog/src/features/devices/repositories/device_repository.dart';
import 'package:templog/src/features/devices/services/device_service.dart';
import 'package:templog/src/features/locations/data/location.dart';
import 'package:templog/src/features/locations/repositories/location_repository.dart';
import 'package:templog/src/features/main_page.dart';
import 'package:templog/src/util/services/shared_preference_service.dart';

class LocationService {
  FirebaseAuth auth = DefaultFirebaseOptions.auth;
  LocationRepository locationRepository = LocationRepository();
  DeviceService deviceService = DeviceService();
  DeviceRepository devicesRepository = DeviceRepository();

  Future<List<Location>> getLocations() async {
    IdTokenResult userCustomClaims = await auth.currentUser!.getIdTokenResult(true);
    String businessCode = userCustomClaims.claims!["businessCode"];

    // Get a snapshot of the "Locations" collection for the user's business code
    var locationsSnapshot = await locationRepository.getLocations(businessCode);
    
    // Create the empty list of "Location"s
    List<Location> locations = [];
    // For each location document
    for (var location in locationsSnapshot.docs) {
      // Get that location's data
      Map<String, dynamic> locationData = location.data();
      
      // Get the "Devices" collection for that location
      var devicesSnapshot = await devicesRepository.getDevices(businessCode, location.id);
      // Create the empty list of "Device"s
      List<Device> devices = [];
      // For each device
      for (var device in devicesSnapshot.docs) {
        // Get the device's data
        Map<String, dynamic> deviceData = device.data();
        // Add the device to the array
        devices.add(
          Device(
            device.id,
            deviceData["Name"],
            DeviceType.values.firstWhere((e) => e.toString() ==  'DeviceType.${deviceData["Type"]!.toLowerCase()}'),
            deviceData["Comments"]
          )
        );
        devices = deviceService.sortDevices(devices);
      }
      
      // Add the location to the array
      locations.add(Location(location.id, locationData["Name"], locationData["Address"], locationData["City"], locationData["Post Code"], devices));
      locations.sort((a, b) => a.locationName.compareTo(b.locationName));
    }
    return locations;
  }

  setLocation(Location location) async {
    IdTokenResult userCustomClaims = await auth.currentUser!.getIdTokenResult(true);
    String businessCode = userCustomClaims.claims!["businessCode"];

    if (location.locationId.isEmpty) { // If the device ID is empty, we can assume it is a new device
      var locationRef = await locationRepository.addLocation(businessCode, location);
      location.locationId = locationRef.id;

      await locationRepository.setLocation(businessCode, location);
      
    } else { // If the device ID is not empty, we can assume the user is editing an existing device
      await locationRepository.setLocation(businessCode, location);
    }

    MainPage.locations.removeWhere((element) => element.locationId == location.locationId);
    MainPage.locations.add(location);
    MainPage.currentLocation = location;
    SharedPreferenceService().setStringPreference("currentLocationName", location.locationName);
  }
}
