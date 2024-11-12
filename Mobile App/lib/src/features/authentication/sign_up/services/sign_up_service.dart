import 'package:cloud_functions/cloud_functions.dart';
import 'package:templog/firebase_options.dart';
import 'package:templog/src/features/authentication/data/update_claims_dto.dart';

class SignUpService {
  Future<String> updateClaims(UpdateClaimsDTO updateClaimsDTO) async {
    final functions = DefaultFirebaseOptions.functions;

    try {
      final HttpsCallable updateClaimsFunction = functions.httpsCallable("updateClaims");
      final response = await updateClaimsFunction.call(
        { 
          "userId": updateClaimsDTO.userId,
          "businessCode": updateClaimsDTO.businessCode,
          "admin": updateClaimsDTO.admin ? "true" : "false"
        }
      );
      return response.data as String;

    } on FirebaseFunctionsException catch (error) {
      print(error.code);
      print(error.details);
      print(error.message);
      return "error";
    }
  }
}