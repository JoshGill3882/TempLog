import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:templog/firebase_options.dart';
import 'package:templog/src/features/profile/data/profile.dart';

class ProfileRepository {
  setProfileDisplayName(String businessCode, bool adminFlag, String userId, String newDisplayName) async {
    await DefaultFirebaseOptions
      .database
      .collection(businessCode)
      .doc("Users")
      .collection((adminFlag) ? "Managers" : "Employees")
      .doc(userId)
      .set({ 'Display Name': newDisplayName }, SetOptions(merge: true));
  }

  getProfiles(String businessCode) async {
    List<List<Profile>> profiles = [];

    List<Profile> managers = [];
    final managerDocs = await DefaultFirebaseOptions
      .database
      .collection(businessCode)
      .doc("Users")
      .collection("Managers")
      .get();
    for (var manager in managerDocs.docs) {
      var managerData = manager.data();
      managers.add(Profile(userId: managerData["ID"], displayName: managerData["Display Name"], admin: true));
    }
    profiles.add(managers);

    List<Profile> employees = [];
    final employeeDocs = await DefaultFirebaseOptions.database
        .collection(businessCode)
        .doc("Users")
        .collection("Employees")
        .get();
    for (var employee in employeeDocs.docs) {
      var employeeData = employee.data();
      employees.add(Profile(userId: employeeData["ID"], displayName: employeeData["Display Name"], admin: false));
    }
    profiles.add(employees);

    return profiles;
  }

  deleteProfile(String businessCode, bool adminFlag) async {
    // Delete profile data from Firestore
    await DefaultFirebaseOptions.database
      .collection(businessCode)
      .doc("Users")
      .collection((adminFlag) ? "Managers" : "Employees")
      .doc(DefaultFirebaseOptions.auth.currentUser!.uid)
      .delete();
    
    // Delete the user from Auth
    DefaultFirebaseOptions.auth.currentUser!.delete();
  }
}
