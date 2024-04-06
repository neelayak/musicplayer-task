import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:musicplayer/datamodel/music_data_model.dart';
import 'package:musicplayer/utils/hivedatabase.dart';

import '../main.dart';
import '../utils/datalist.dart';

class ListViewmodel with ChangeNotifier {
  var favouratelist = [];
  List<dynamic> items = []; // Your list of items
  List<dynamic> musicDM = []; // Filtered items based on search query

  get filteredItems => musicDM;

  void updateQuery(String query) {
    musicDM = items
        .where((item) => item.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
    notifyListeners();
  }

  getlistdata(String query) async {
    getdata();
    var data = await json.decode(jsondata);
    List<dynamic> list = data['songlist'];
    if (query == '') {
      return list;
    } else {
      List<dynamic> querylist = [];
      for (int i = 0; i < list.length; i++) {
        if (query.contains(list[i]['song_name'])) {
          querylist.add(list[i]);
        }
      }
      return querylist;
    }
  }

  addfavouratedata(String title) {
    favouratelist.add(title);
    print(favouratelist);
    updatedatabase(favouratelist);
    notifyListeners();
  }

  bool isfav(String title) {
    if (favouratelist.contains(title)) {
      return true;
    } else {
      return false;
    }
    print(favouratelist);
  }

  getdata() async {
    final data = await supabase
        .from('user_test')
        .select('favorite')
        .match({'email': HiveDatabase().getemail()});
    //  favouratelist = data;
  }

  updatedatabase(var fav) async {
    await supabase
        .from('user_test')
        .update({'favorite': fav}).match({'email': HiveDatabase().getemail()});
  }

  removefavourate(String title) {
    if (favouratelist.contains(title)) {
      for (int i = 0; i < favouratelist.length; i++) {
        if (title == favouratelist[i]) {
          favouratelist.removeAt(i);
        }
      }
    }
    updatedatabase(favouratelist);

    print(favouratelist);

    notifyListeners();
  }
}
