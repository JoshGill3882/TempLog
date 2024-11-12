import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceService {
  // Setters
  setStringPreference(String key, String value) async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setString(key, value);
  }
  
  setListPreferences(String key, List<String> values) async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setStringList(key, values);
  }


  // Getters
  getStringPreference(String key) async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    final String? value = preferences.getString(key);
    return value;
  }
  
  getListPreferences(String key) async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    final List<String>? values = preferences.getStringList(key);
    return (values == null) ? <String>[] : values;
  }


  // Clearer
  clearSharedPreference() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.clear();
  }
}
