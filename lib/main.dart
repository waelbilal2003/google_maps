import 'package:flutter/material.dart';
import 'the_first_page.dart';
import 'home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Alpha One',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      // البداية ستكون صفحة الـ Splash
      home: const TheFirstPage(),
      routes: {'/home': (_) => const HomePage()},
    );
  }
}
