import 'package:flutter/cupertino.dart';
import 'package:tourist_app/data/local/sharedpref_helper/preferences.dart';

class AppStateManager extends ChangeNotifier {
  final _preferences = Preferences.instance;
  // Future<void> changeLanguage(String local) async {
  //   await _preferences.insert("local", local);
  // }
  //
  // Future<Locale> getLanguage() async {
  //   String? local = (await _preferences.get("local")) as String?;
  //   if (local == "ar") {
  //     return const Locale('ar', 'SA');
  //   } else {
  //     return const Locale('en', 'US');
  //   }
  // }
}
