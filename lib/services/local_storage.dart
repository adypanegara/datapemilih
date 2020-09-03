import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  // simpan data dari json ke sharedpreference
  void setData(bool value, String username, String fullname, String kode,
      String kdesa) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setBool("value", value);
    pref.setString("username", username);
    pref.setString("fullname", fullname);
    pref.setString("kode", kode);
    pref.setString("kdesa", kdesa);
  }

  Future<bool> getValueLogin() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getBool("value") ?? false;
  }

  Future<String> getNama() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString("fullname") ?? "No name";
  }

  Future<String> getKode() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString("kode") ?? "A000";
  }

  Future<String> getKdesa() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString("kdesa") ?? "No Kdesa";
  }
}
