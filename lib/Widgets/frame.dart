import 'package:e_360/Screens/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:e_360/Screens/profile.dart';
import 'package:e_360/Models/Staff.dart';
import 'package:e_360/Models/Staff.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:e_360/Models/DrawerItem.dart';
import 'package:e_360/Screens/Requests.dart';
import 'package:e_360/Screens/Home.dart';
import 'package:e_360/Screens/Payslip.dart';
import 'package:e_360/Screens/Settings.dart';
import 'package:e_360/Screens/Management.dart';

class Frame extends HookWidget {
  final Staff staff;

  final String? screen;
  Frame({super.key, required this.staff, this.screen});

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final currentIndex = useState<int>(0);
    final userData = useState<Map<String, dynamic>>({});

    useEffect(() {
      void getData() async {
        Uri url = Uri.parse(
            'http://10.0.0.184:8015/userservices/primaryrecord/11536/primaryrecord');
        var token = {
          'br':
              "66006500390034006200650036003400390065006500630063006400380063006600330062003200300030006200630061003300330062003300640030006300",
          'us': staff.userRef,
          'rl': staff.uRole
        };
        var headers = {
          'x-lapo-eve-proc': jsonEncode(token),
          'Content-type': 'text/json',
        };
        var response = await http.get(url, headers: headers);

        if (response.statusCode == 200) {
          userData.value = jsonDecode(response.body)['data'];
          // return response.body;
        }
      }

      getData();
    }, []);

    // useEffect(() {
    //   switch (screen) {
    //     case 'profile':
    //       {}
    //       break;
    //   }
    // }, []);

    var token = {
      'br':
          "66006500390034006200650036003400390065006500630063006400380063006600330062003200300030006200630061003300330062003300640030006300",
      'us': staff.userRef,
      'rl': staff.uRole
    };
    var headers = {
      'x-lapo-eve-proc': jsonEncode(token),
      'Content-type': 'text/json',
    };

    List<Widget> screens = <Widget>[
      Home(),
      Profile(
        staff: staff,
        info: userData.value,
      ),
      Requests(
        staff: staff,
        info: userData.value,
      ),
      Payslip(
        staff: staff,
        info: userData.value
      ),
      Management(staff: staff, info: userData.value),
      Settings(staff: staff, info: userData.value),
    ];

    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 170,
        actions: [
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  margin: EdgeInsets.only(top: 20, right: 5),
                  child: CircleAvatar(
                    radius: 40,
                    // backgroundImage: NetworkImage(
                    //   'http://10.0.0.184:8015/userservices/retrievephoto/${staff.userRef}/retrievephoto',
                    //   headers: headers,
                    // ),
                    backgroundImage: AssetImage('images/ebele.png'),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(right: 20, top: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          margin: EdgeInsets.only(top: 20),
                          child: const Text(
                            'Welcome!',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          )),
                      Container(
                        margin: const EdgeInsets.only(bottom: 10, top: 5),
                        width: 120,
                        child: Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(right: 10),
                              child: Text(
                                'Ebele',
                                // (staff.firstName as String),
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                            Text(
                              // (staff.lastName as String),
                              '',
                              // style: TextStyle(color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Builder(builder: (BuildContext context) {
                  return Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        IconButton(
                            onPressed: () {},
                            icon:Icon(
                              Icons.notifications,
                              color: Colors.grey[600],
                            )),
                        IconButton(
                            onPressed: () => Scaffold.of(context).openDrawer(),
                            icon:Icon(Icons.menu,
                                color: Colors.grey[600]
                                ))
                      ],
                    ),
                  );
                })
              ],
            ),
            Container(
              margin: EdgeInsets.only(bottom: 15),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.only(right: 10),
                    alignment: Alignment.centerLeft,
                    // width: 160,
                    decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 237, 236, 236),
                        borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(10),
                            topRight: Radius.circular(10))),
                    margin: const EdgeInsets.only(top: 20),
                    child: Row(children: [
                      const Icon(Icons.business, color: Color(0xff55BE88)),
                      Text(
                        userData.value['JobTitle'] ?? '',
                        style: const TextStyle(
                            color: Color(0xff55BE88),
                            fontSize: 10,
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.bold),
                      )
                    ]),
                  ),
                ],
              ),
            ),
          ])
        ],
      ),
      body: screens.elementAt(currentIndex.value),
      drawer: Drawer(
          // backgroundColor: Color(0xff15B77C),
          backgroundColor: const Color(0xffD6EBE3),
          // backgroundColor: Colors.grey[200],
          child: ListView(
            children: [
              SizedBox(
                height: 200,
                child: DrawerHeader(
                    padding: EdgeInsets.zero,
                    child: Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 30),
                          child: CircleAvatar(
                          radius: 50,
                          // backgroundImage: NetworkImage(
                          //   'http://10.0.0.184:8015/userservices/retrievephoto/${staff.userRef}/retrievephoto',
                          //   headers: headers,
                          // ),
                          backgroundImage: AssetImage('images/ebele.png'),
                        ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 10),
                                child: Text(
                                  // (staff.firstName as String),
                                  'Ebele',
                                  style: const TextStyle(color: Colors.black),
                                ),
                              ),
                              Text(
                                // (staff.lastName as String),
                                '',
                                style: const TextStyle(color: Colors.black),
                              ),
                            ],
                          ),
                        )
                      ],
                    )),
              ),
              ListTile(
                leading: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: Colors.white),
                  child: const Icon(
                  Icons.home,
                  color: Color(0xff15B77C),
                ),),
                title: const Text('Home', style: TextStyle(color: Colors.black)),
                onTap: () {
                  Navigator.pop(context);
                  currentIndex.value = 0;
                },
              ),
              ListTile(
                leading: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: Colors.white),
                  child: const Icon(
                  Icons.person,
                  color: Color(0xff15B77C),
                ),),
                title: const Text('Profile', style: TextStyle(color: Colors.black),),
                onTap: () {
                  Navigator.pop(context);
                  currentIndex.value = 1;
                },
              ),
              ListTile(
                leading: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: Colors.white),
                  child: const Icon(
                  Icons.note_add,
                  color: Color(0xff15B77C),
                ),),
                title: const Text('Requisitions', style: TextStyle(color: Colors.black)),
                onTap: () {
                  Navigator.pop(context);
                  currentIndex.value = 2;
                },
              ),
              ListTile(
                leading: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: Colors.white),
                  child: const Icon(
                  Icons.receipt,
                  color: Color(0xff15B77C),
                ),),
                title: const Text('Payslip', style: TextStyle(color: Colors.black)),
                onTap: () {
                  Navigator.pop(context);
                  currentIndex.value = 3;
                },
              ),
              ListTile(
                leading: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: Colors.white),
                  child: const Icon(
                  Icons.settings,
                  color: Color(0xff15B77C),
                ),),
                title: const Text('Settings', style: TextStyle(color: Colors.black)),
                onTap: () {
                  Navigator.pop(context);
                  currentIndex.value = 4;
                },
              ),
              ListTile(
                leading: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: Colors.white),
                  child: const Icon(
                  Icons.exit_to_app,
                  color: Color(0xff15B77C),
                ),),
                title: const Text('Sign Out', style: TextStyle(color: Colors.black)),
                onTap: () {
                   Navigator.push(context,
            MaterialPageRoute(builder: (context) => Login(title: '')));
                },
              ),
            ],
          )),
      bottomNavigationBar: Theme(
        
        data: Theme.of(context).copyWith(
              // canvasColor: const Color(0xffD6EBE3),
              canvasColor: Colors.white,
              textTheme: Theme.of(context)
                  .textTheme
                  .copyWith(caption: const TextStyle(color: Colors.black54))),child: BottomNavigationBar(
        // fixedColor: const Color(0xffD6EBE3),
        backgroundColor: const Color(0xffD6EBE3),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          BottomNavigationBarItem(
              icon: Icon(Icons.note_add), label: 'Requests'),
          BottomNavigationBarItem(icon: Icon(Icons.receipt), label: 'Pay Slip'),
          BottomNavigationBarItem(
              icon: Icon(Icons.manage_accounts), label: 'Appraisals'),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings), label: 'Settings'),
        ],
        currentIndex: currentIndex.value,
        onTap: (int index) {
          currentIndex.value = index;
        },
        selectedItemColor: const Color(0xff15B77C),
        unselectedItemColor:Colors.grey[400],
        unselectedFontSize: 12,
        selectedFontSize: 16,
      ),)
    );
  }
}
