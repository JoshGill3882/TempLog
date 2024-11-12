import 'package:email_validator/email_validator.dart';

class Validators {
  static bool isPassword(value) {
    final RegExp regex = RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,32}$');
    // Criteria
    // - >=1 lowercase letter
    // - >=1 uppercase letter
    // - >=1 number
    // - >=1 "special character" - (#, ?, !, @, $, %, ^, &, *, -)
    return regex.hasMatch(value);
  }

  static bool isEmail(value) { return EmailValidator.validate(value); }
  
  static bool isPostCode(value) {
    final RegExp regex = RegExp('([Gg][Ii][Rr] 0[Aa]{2})|((([A-Za-z][0-9]{1,2})|(([A-Za-z][A-Ha-hJ-Yj-y][0-9]{1,2})|(([A-Za-z][0-9][A-Za-z])|([A-Za-z][A-Ha-hJ-Yj-y][0-9][A-Za-z]?))))\s?[0-9][A-Za-z]{2})');
    return regex.hasMatch(value);
  }

  static bool isNull(value) { return value == null; }

  static bool isBlank(value) {
    //Stripping white space, just spaces won't be allowed
    String valueStripped = value.replaceAll(' ', '');
    return (valueStripped == "" || valueStripped == " ");
  }
}