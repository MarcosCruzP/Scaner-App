import 'package:flutter/material.dart';
import 'package:qr_scan_evosys/home_page.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Material App',
      initialRoute: 'Home',
      routes: {
        'Home': (_) => HomePage(),
      },
    );
  }
}
