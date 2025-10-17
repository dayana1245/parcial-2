import 'package:flutter/material.dart';
import 'welcome_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mood Diary',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: const WelcomePage(),
    );
  }
}
