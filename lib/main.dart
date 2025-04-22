import 'package:flutter/material.dart';
import 'package:sqflite_todoapp/screens/home_page.dart';
// import 'package:sqflite_common_ffi/sqflite_ffi.dart';
void main() {

  // sqfliteFfiInit();
  // databaseFactory = databaseFactoryFfi;
  runApp( MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Sqflite Todo App',
    theme: ThemeData.dark(useMaterial3: true),
    home: HomePage(),

  ));
}
