import 'package:flutter/cupertino.dart';
import 'package:musicplayer/utils/hivedatabase.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../main.dart';

class LoginViewModel with ChangeNotifier {
  logindata(String email, String password) async {
    HiveDatabase().setemail(email);
    HiveDatabase().setpassword(password);
    final AuthResponse res = await supabase.auth
        .signInWithPassword(email: email, password: password);
    if (res.user!.email != null) {
      print('1');
    }
  }

  signupdata(String email, String password) async {
    HiveDatabase().setemail(email);
    HiveDatabase().setpassword(password);
    final AuthResponse res =
        await supabase.auth.signUp(email: email, password: password);
    if (res.user!.email != null) {
      savedata(email, password);
    }
  }

  savedata(String email, String password) async {
    await supabase
        .from('user_test')
        .insert({'password': password, 'email': email});
  }
}
