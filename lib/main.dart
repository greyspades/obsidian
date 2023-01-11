import 'package:flutter/material.dart';
import 'package:e_360/Screens/login.dart';
import 'package:e_360/Widgets/frame.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() {
  runApp(
    const ProviderScope(child: MyApp())
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'E360',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Login(title: 'Flutter Demo Home Page'),
      // home: const Frame()
    );
  }
}

