import 'package:flutter/material.dart';
import 'package:note/page/note_detail_page.dart';
import 'package:note/page/edit_note_page.dart';
import 'package:note/page/home_page.dart';

class MyThemes {
  static final darkTheme = ThemeData(
    scaffoldBackgroundColor: Colors.grey.shade900,
    primaryColor: Colors.black,
    colorScheme: ColorScheme.dark(),
    appBarTheme: AppBarTheme(
      color: Colors.grey.shade900,
      iconTheme: IconThemeData(color: Colors.white),
    ),
  );

  static final lightTheme = ThemeData(
    scaffoldBackgroundColor: Colors.white,
    primaryColor: Colors.white,
    colorScheme: ColorScheme.light(),
    appBarTheme: AppBarTheme(
      color: Colors.white,
      iconTheme: IconThemeData(color: Colors.black),
    ),
  );
}
