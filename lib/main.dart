import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:note/page/home_page.dart';
import 'package:note/settings/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  static final String title = 'Notes';

  @override
  State<MyApp> createState() => _MyAppState();
}

///view list and grid change...............................
class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    _loadData();
    super.initState();
  }

  _loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isGrid = prefs.getBool("isGrid")!;
    });
  }

  ///.........................................................

  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: MyApp.title,
        themeMode: ThemeMode.system,
        theme: MyThemes.lightTheme,
        darkTheme: MyThemes.darkTheme,
        home: NotesPage(),
      );
}
