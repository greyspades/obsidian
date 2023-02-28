import 'dart:async';

import 'package:flutter/material.dart';
import 'package:e_360/Screens/login.dart';
import 'package:e_360/Widgets/frame.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() {
  runApp(
    const ProviderScope(child: MyApp())
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  Timer? _timer;

  void _initializeTimer() {
      if (_timer != null) {
        _timer?.cancel();
      }
      // setup action after 5 minutes
      _timer = Timer(const Duration(minutes: 5), () => _handleInactivity());
    }

    void _handleInactivity() {
      _timer?.cancel();
      _timer = null;
      Navigator.push(context, MaterialPageRoute(builder: (context) => Login(title: '')));
    }

  @override
  void initState() {
    super.initState();
    _initializeTimer();
  }
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => _initializeTimer(),
      onPanDown: (_) => _initializeTimer(),
      onPanUpdate: (_) => _initializeTimer(),
      child: MaterialApp(
      title: 'E360',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Login(title: 'Flutter Demo Home Page'),
      // home: const Frame()
    ),
    );
  }
}
