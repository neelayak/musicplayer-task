import 'package:hive_flutter/hive_flutter.dart';

class HiveDatabase {
  var box = Hive.box('musicplayer');

  setemail(String email) {
    box.put('email', email);
  }

  getemail() {
    var email = box.get('email');
    if (email != null) {
      return email;
    } else {
      return null;
    }
  }

  setpassword(String password) {
    box.put('password', password);
  }

  getpassword() {
    var password = box.get('password');
    if (password != null) {
      return password;
    } else {
      return null;
    }
  }

  setfavourate(var fav) {
    box.put('fav', fav);
  }

  getfavourate() {
    var fav = box.get('fav');
    return fav;
  }
}
