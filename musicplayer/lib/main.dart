import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:musicplayer/provider/list_viewmodel.dart';
import 'package:musicplayer/provider/login_viewmodel.dart';
import 'package:musicplayer/ui/screen/list_screen.dart';
import 'package:musicplayer/ui/screen/login_screen.dart';
import 'package:musicplayer/utils/datalist.dart';
import 'package:musicplayer/utils/hivedatabase.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

void main() async {
  await Hive.initFlutter();
  await Hive.openBox('musicplayer');
  await Supabase.initialize(
    url: supaURL,
    anonKey: supaANONNKEY,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => LoginViewModel()),
        ChangeNotifierProvider(create: (context) => ListViewmodel()),
      ],
      child: MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          home: (HiveDatabase().getemail() == null)
              ? LoginScreen()
              : ListScreen()),
    );
  }
}
