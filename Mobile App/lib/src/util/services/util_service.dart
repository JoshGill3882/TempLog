import 'dart:math';

class UtilService {
  final _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  final Random _rnd = Random();

  String getRandomString() { return String.fromCharCodes(Iterable.generate(
    15,
    (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))
  )); }
}