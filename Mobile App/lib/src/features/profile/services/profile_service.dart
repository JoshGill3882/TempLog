import 'package:firebase_auth/firebase_auth.dart';
import 'package:templog/firebase_options.dart';
import 'package:templog/src/features/profile/repositories/profile_repository.dart';

class ProfileService {
  final auth = DefaultFirebaseOptions.auth;

  final profileRepository = ProfileRepository();

  Future<String> updateProfile(String email, String password, String displayName) async {
    IdTokenResult userCustomClaims = await auth.currentUser!.getIdTokenResult(true);
    String businessCode = userCustomClaims.claims!["businessCode"];
    bool adminFlag = userCustomClaims.claims!["admin"];
    final String userId = auth.currentUser!.uid;

    try {
      await auth.currentUser!.updateDisplayName(displayName);
      // ignore: deprecated_member_use
      await auth.currentUser!.updateEmail(email);
      if (password.isNotEmpty) { await auth.currentUser!.updatePassword(password); }

      await profileRepository.setProfileDisplayName(businessCode, adminFlag, userId, displayName);

      return "success";
    } on FirebaseAuthException catch (error) {
      return error.code;
    }
  }

  getProfiles() async {
    IdTokenResult userCustomClaims = await auth.currentUser!.getIdTokenResult(true);
    String businessCode = userCustomClaims.claims!["businessCode"];
    return await profileRepository.getProfiles(businessCode);
  }

  deleteProfile() async {
    IdTokenResult userCustomClaims = await auth.currentUser!.getIdTokenResult(true);
    String businessCode = userCustomClaims.claims!["businessCode"];
    bool adminFlag = userCustomClaims.claims!["admin"];
    return await profileRepository.deleteProfile(businessCode, adminFlag);
  }
}
