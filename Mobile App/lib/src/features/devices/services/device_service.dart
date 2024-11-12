import 'package:collection/collection.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:templog/firebase_options.dart';
import 'package:templog/src/features/devices/data/device.dart';
import 'package:templog/src/features/devices/repositories/device_repository.dart';
import 'package:templog/src/features/devices/widgets/device_button.dart';
import 'package:templog/src/features/locations/data/location.dart';
import 'package:templog/src/features/main_page.dart';

class DeviceService {
  FirebaseAuth auth = DefaultFirebaseOptions.auth;
  DeviceRepository deviceRepository = DeviceRepository();

  getNumberOfDevices() {
    int numOfDevices = 0;
    for (var element in MainPage.locations) { numOfDevices += element.devices.length; }
    return numOfDevices;
  }

  getDeviceButtons(Location location, Function changePage, BuildContext context) {
    List<DeviceButton> deviceButtons = [];
    for (Device device in location.devices) { deviceButtons.add(DeviceButton(device, changePage)); }
    deviceButtons.add(DeviceButton(Device("", "Add Device", DeviceType.add, ""), changePage));
    Iterable<List<DeviceButton>> iterableDeviceList = deviceButtons.slices(3);

    List<Row> deviceDisplayRows = [];
    for (var deviceList in iterableDeviceList) {
      deviceDisplayRows.add(Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            deviceList[0],
            (deviceList.length < 2)
                ? SizedBox(width: MediaQuery.of(context).size.width * 0.27, height: MediaQuery.of(context).size.width * 0.27)
                : deviceList[1],
            (deviceList.length < 3)
                ? SizedBox(width: MediaQuery.of(context).size.width * 0.27, height: MediaQuery.of(context).size.width * 0.27)
                : deviceList[2]
          ]));
    }

    return ListView.separated(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: deviceDisplayRows.length,
      separatorBuilder: (BuildContext context, int index) => const Padding(padding: EdgeInsets.all(10)),
      itemBuilder: (BuildContext context, int index) => deviceDisplayRows[index],
      physics: const NeverScrollableScrollPhysics(),
    );
  }

  setDevice(Device device) async {
    IdTokenResult userCustomClaims = await auth.currentUser!.getIdTokenResult(true);
    String businessCode = userCustomClaims.claims!["businessCode"];
    String locationId = MainPage.currentLocation.locationId;

    if (device.deviceId.isEmpty) { // If the device ID is empty, we can assume it is a new device
      var deviceRef = await deviceRepository.addDevice(businessCode, locationId, device);
      device.deviceId = deviceRef.id;

      await deviceRepository.setDevice(businessCode, locationId, device);
      
    } else { // If the device ID is not empty, we can assume the user is editing an existing device
      await deviceRepository.setDevice(businessCode, locationId, device);
    }

    MainPage.currentLocation.devices.removeWhere((element) => element.deviceId == device.deviceId);
    MainPage.currentLocation.devices.add(device);
    MainPage.currentLocation.devices = sortDevices(MainPage.currentLocation.devices);

    return device;
  }

  deleteDevice(Device device) async {
    IdTokenResult userCustomClaims = await auth.currentUser!.getIdTokenResult(true);
    String businessCode = userCustomClaims.claims!["businessCode"];
    String locationId = MainPage.currentLocation.locationId;

    await deviceRepository.deleteDevice(businessCode, locationId, device);

    MainPage.currentLocation.devices.removeWhere((element) => element.deviceId == device.deviceId);
  }

  sortDevices(List<Device> devices) {
    // Define empty lists for each type
    List<Device> fridges = [];
    List<Device> freezers = [];
    List<Device> others = [];

    // For each device in the given list
    for (Device device in devices) {
      // Sort it into it's appropriate list
      switch (device.deviceType) {
        case DeviceType.fridge:
          fridges.add(device);
          break;
        case DeviceType.freezer:
          freezers.add(device);
          break;
        case DeviceType.other:
          others.add(device);
          break;
        case DeviceType.add:
          // Should never happen so just breaks
          break;
      }
    }

    // Sort each list based on device name
    fridges.sort((a, b) => a.deviceName.compareTo(b.deviceName));
    freezers.sort((a, b) => a.deviceName.compareTo(b.deviceName));
    others.sort((a, b) => a.deviceName.compareTo(b.deviceName));

    // Re-combine the lists into one long list
    List<Device> sortedDevices = [];
    for (var device in fridges) { sortedDevices.add(device); }
    for (var device in freezers) { sortedDevices.add(device); }
    for (var device in others) { sortedDevices.add(device); }

    // Return the sorted list
    return sortedDevices;
  }
}
