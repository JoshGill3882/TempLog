enum DeviceType {
  fridge,
  freezer,
  other,
  add
}

class Device {
  String deviceId;
  String deviceName;
  DeviceType deviceType;
  String comments;

  Device(this.deviceId, this.deviceName, this.deviceType, this.comments);
}