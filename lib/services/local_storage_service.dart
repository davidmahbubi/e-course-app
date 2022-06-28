import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {

  static late SharedPreferences localStorage;

  static Future<void> initLocalStorage() async {
    localStorage = await SharedPreferences.getInstance();
  }
}