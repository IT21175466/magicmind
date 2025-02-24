
import 'package:shared_preferences/shared_preferences.dart';

Future<void> saveString(String key, String value) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString(key, value);
}

Future<String> loadString(String key, String defaultValue) async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString(key) ?? defaultValue;
}