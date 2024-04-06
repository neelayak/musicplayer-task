import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:musicplayer/provider/list_viewmodel.dart';
import 'package:musicplayer/ui/screen/mediaplayer_screen.dart';
import 'package:provider/provider.dart';

import '../../datamodel/music_data_model.dart';

class ListScreen extends StatefulWidget {
  const ListScreen({super.key});

  @override
  State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  bool issearch = false;
  final TextEditingController _controller = TextEditingController();
  String query = '';
  List<ConnectivityResult> _connectionStatus = [ConnectivityResult.none];
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;

  @override
  void initState() {
    super.initState();
    initConnectivity();

    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initConnectivity() async {
    late List<ConnectivityResult> result;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      return;
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(List<ConnectivityResult> result) async {
    setState(() {
      print(result.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ListViewmodel(),
      child: Builder(builder: (context) {
        var listVM = Provider.of<ListViewmodel>(context, listen: false);
        // listVM.updatedatabase();
        // listVM.getdata();
        print(listVM.musicDM.length);

        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.deepPurple,
            automaticallyImplyLeading: false,
            title: !issearch
                ? null
                : TextFormField(
                    controller: _controller,
                    style: TextStyle(color: Colors.white),
                    onChanged: (value) {
                      setState(() {
                        query = value;
                      });
                    },
                    decoration: InputDecoration(
                        icon: Icon(
                          Icons.search,
                          color: Colors.white,
                        ),
                        hintText: 'Enter music name ',
                        hintStyle: TextStyle(color: Colors.white),
                        suffixStyle: TextStyle(color: Colors.white)),
                  ),
            actions: [
              issearch
                  ? IconButton(
                      onPressed: () {
                        setState(() {
                          this.issearch = false;
                        });
                      },
                      icon: Icon(
                        Icons.cancel,
                        color: Colors.white,
                      ),
                    )
                  : IconButton(
                      onPressed: () {
                        setState(() {
                          this.issearch = true;
                        });
                      },
                      icon: Icon(
                        FontAwesomeIcons.search,
                        color: Colors.white,
                      ),
                    )
            ],
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  width: double.maxFinite,
                  height: MediaQuery.of(context).size.height,
                  child: FutureBuilder(
                      future: listVM.getlistdata(query),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          List<dynamic> musicDM =
                              snapshot.data as List<dynamic>;
                          print(musicDM);
                          return Container(
                            width: double.maxFinite,
                            height: 600,
                            child: ListView.builder(
                                itemCount: musicDM!.length,
                                itemBuilder: (context, index) {
                                  return ListTile(
                                    onTap: () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) => Playermedia(
                                                  title: musicDM![index]
                                                      ['song_name']!,
                                                  author: musicDM[index]
                                                      ['song_artistname']!,
                                                  cover_url: musicDM[index]
                                                      ['song_cover'],
                                                  tag: 'musicplayer$index')));
                                    },
                                    title: Text(musicDM![index]['song_name']!),
                                    subtitle: Text(
                                        musicDM![index]['song_artistname']!),
                                    leading: Container(
                                      height: 80,
                                      width: 80,
                                      child: Hero(
                                        tag: 'musicplayer$index',
                                        child: CachedNetworkImage(
                                          fit: BoxFit.fill,
                                          imageUrl: musicDM![index]
                                              ['song_cover']!,
                                          placeholder: (context, url) =>
                                              Container(
                                            color: Colors.black38,
                                          ),
                                          errorWidget: (context, url, error) =>
                                              Icon(Icons.error),
                                        ),
                                      ),
                                    ),
                                    trailing: InkWell(
                                        onTap: () {
                                          setState(() {
                                            if (listVM.isfav(
                                                musicDM[index]['song_name']!)) {
                                              listVM.removefavourate(
                                                  musicDM![index]
                                                      ['song_name']!);
                                            } else {
                                              listVM.addfavouratedata(
                                                  musicDM![index]
                                                      ['song_name']!);
                                            }
                                          });
                                        },
                                        child: listVM.isfav(
                                                musicDM![index]['song_name']!)
                                            ? Icon(FontAwesomeIcons.solidHeart)
                                            : Icon(FontAwesomeIcons.heart)),
                                  );
                                }),
                          );
                        } else {
                          return Container(
                            alignment: Alignment.center,
                            child: CircularProgressIndicator(),
                          );
                        }
                      }),
                )
              ],
            ),
          ),
        );
      }),
    );
  }
}
