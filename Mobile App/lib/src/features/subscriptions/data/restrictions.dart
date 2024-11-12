class Restrictions {
  String currentTier;
  int maxLocations;
  int maxDevices;
  int maxMonthlyLogs;
  bool downloadAllowed;
  bool notificationsAllowed;

  Restrictions({
    required this.currentTier,
    required this.maxLocations,
    required this.maxDevices,
    required this.maxMonthlyLogs,
    required this.downloadAllowed,
    required this.notificationsAllowed
  });

  static freeTierRestrictions() {
    return Restrictions(
      currentTier: "Free",
      maxLocations: 1,
      maxDevices: 3,
      maxMonthlyLogs: 100,
      downloadAllowed: false,
      notificationsAllowed: false
    );
  }

  static plusTierRestrictions() {
    return Restrictions(
      currentTier: "Plus",
      maxLocations: 5,
      maxDevices: 50,
      maxMonthlyLogs: 5000,
      downloadAllowed: true,
      notificationsAllowed: true
    );
  }

  @override
  String toString() {
    // TODO: implement toString
    return super.toString();
  }
}