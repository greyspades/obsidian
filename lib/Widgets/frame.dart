import 'package:e_360/Screens/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:e_360/Screens/profile.dart';
import 'package:e_360/Models/Staff.dart';


class Frame extends HookWidget {
  final Staff staff;
  const Frame({super.key, required this.staff});

  @override
  Widget build(BuildContext context) {
    final currentIndex = useState<int>(0);

    List<Widget> screens = <Widget>[
    Profile(staff: staff),
    Text('second'),
    Text('third'),
    Text('fourth')
  ];

    return Scaffold(
      appBar: AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      toolbarHeight: 10,
    ),
    
      body: screens.elementAt(currentIndex.value),

      bottomNavigationBar: BottomNavigationBar(items:const <BottomNavigationBarItem> [

        BottomNavigationBarItem(icon: Icon(Icons.person),label: 'Profile'),

        BottomNavigationBarItem(icon: Icon(Icons.note_add),label: 'Requests'),

        BottomNavigationBarItem(icon: Icon(Icons.badge),label: 'Training'),

        BottomNavigationBarItem(icon: Icon(Icons.card_membership),label: 'Payroll')
      ],

      currentIndex: currentIndex.value,

      onTap: (int index) {
        currentIndex.value = index;
      },

      selectedItemColor: const Color(0xff15B77C),

      unselectedItemColor: const Color(0xff939393),
      ),
      );
  }
}