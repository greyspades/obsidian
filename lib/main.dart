import 'dart:async';

import 'package:flutter/material.dart';
import 'package:e_360/Screens/login.dart';
import 'package:e_360/Widgets/frame.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:local_session_timeout/local_session_timeout.dart';

void main() {
  runApp(
    ProviderScope(child: MyApp())
  );
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  
  // @override
  // State<MyApp> createState() => _MyAppState();
  final _navigatorKey = GlobalKey<NavigatorState>();
  NavigatorState get _navigator => _navigatorKey.currentState!;
   @override
  Widget build(BuildContext context) {
    // final sessionConfig = SessionConfig(
    //     invalidateSessionForAppLostFocus: const Duration(seconds: 15),
    //     invalidateSessionForUserInactivity: const Duration(seconds: 30));

    //     sessionConfig.stream.listen((SessionTimeoutState timeoutEvent) {
    // if (timeoutEvent == SessionTimeoutState.userInactivityTimeout) {
    //     // handle user  inactive timeout
    //     print('e don lose focuss oooo');
    //     _navigator.push(MaterialPageRoute(
    //       builder: (_) => Login(title: ''),
    //     ));
    //     // Navigator.push(context, MaterialPageRoute(builder: (context) => Login(title: '')));
    //     // Navigator.of(context).pushNamed("/login");
    // } else if (timeoutEvent == SessionTimeoutState.appFocusTimeout) {
    //     // handle user  app lost focus timeout
    //     // Navigator.of(context).pushNamed("/auth");
    //     print('timed out oooooo');
    // }});
    
    return MaterialApp(
      title: 'E360',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Login(title: 'Flutter Demo Home Page'),
    );
}

// class _MyAppState extends State<MyApp> {

//   final _navigatorKey = GlobalKey<NavigatorState>();

//   Timer? _timer;

// //handles inactivity in the app
//     void _handleInactivity() {
//       _timer?.cancel();
//       _timer = null;
//       print('has been inactive!!!!!');
//       // Navigator.push(context, MaterialPageRoute(builder: (context) => Login(title: '')));
//       _navigatorKey.currentState?.pushNamedAndRemoveUntil('login', (_) => false);

//     }
//   //initializes the timer for detecting activity
//     void _initializeTimer() {
//       if (_timer != null) {
//         _timer?.cancel();
//       }
//       // setup action after 5 minutes
//       _timer = Timer(const Duration(minutes: 5), () => _handleInactivity());
//     }

//   @override
//   void initState() {
//     _initializeTimer();
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {

//     return GestureDetector(
//       behavior: HitTestBehavior.translucent,
//       onTap: () => _initializeTimer(),
//       onPanDown: (_) => _initializeTimer(),
//       onPanUpdate: (_) => _initializeTimer(),
//       child: MaterialApp(
//       navigatorKey: _navigatorKey,
//       title: 'E360',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: Login(title: 'Flutter Demo Home Page'),
//       // home: Navigator(key: _navigatorKey,
//       // initialRoute: 'login',
//       // onGenerateRoute: (item) {
//       //   return MaterialPageRoute(builder: (context) {
//       //     return Login(title: 'Flutter Demo Home Page');
//       //   });
//       // },
//       // ),
//       // home: const Frame()
//     ),
//     );
//   }
}
