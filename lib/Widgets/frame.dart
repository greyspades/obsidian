import 'package:e_360/Screens/Downline.dart';
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
import 'package:e_360/Screens/Transactions.dart';
import 'package:e_360/Models/Transaction.dart';


class Frame extends HookWidget {
  final Staff staff;

  final String? screen;
  Frame({super.key, required this.staff, this.screen});

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final currentIndex = useState<int>(0);
    final userData = useState<Map<String, dynamic>>({});
    final transactions = useState<List<Transaction>?>(null);

    Future<void> getTransactions() async {
    Uri url = Uri.parse(
        'http://10.0.0.184:8015/userservices/listtransactions');
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
    var body = {
      "xParam": "",
  "xBuCode": "",
  "xScope": "all",
  "xScopeRef": "",
  "xRowCount": 1,
  "xFromDate": "",
  "xToDate": "",
  "xApp": "100",
  "xPageIndex": 1,
  "xPageSize": 1
    };
    var response =
        await http.post(url, headers: headers, body: jsonEncode(body));
    if (response.statusCode == 200) {
      final data =
          List.from(jsonDecode(response.body)['data']);
      final dataList = data.map((e) => Transaction.fromJson(e),).toList();
     transactions.value = dataList;
    }
  }

    useEffect(() {
      void getData() async {
        Uri url = Uri.parse(
            'http://10.0.0.184:8015/userservices/primaryrecord/${staff.employeeNo}/primaryrecord');
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
        }
      }

      getData();
      getTransactions();
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

    Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Are you sure you want to sign out?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Sign out'),
              onPressed: () {
                Navigator.push(context,
                MaterialPageRoute(builder: (context) => Login(title: '')));
              },
            ),
          ],
        );
      },
    );
  }

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
      Transactions(staff: staff, info: userData.value, transactions: transactions.value,),
      Settings(staff: staff, info: userData.value),
    ];

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(

      backgroundColor: const Color(0xffD6EBE3),
      key: _scaffoldKey,
      resizeToAvoidBottomInset: true,
      body: Container(
        padding: const EdgeInsets.only(top: 20),
        child: Column(
          children: [
          Container(
            height: 150,
            margin: const EdgeInsets.only(top: 10, bottom: 20),
            color: const Color(0xffD6EBE3),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
              IconButton(
                            onPressed: () {},
                            icon:Icon(
                              Icons.notifications,
                              color: Colors.grey[600],
                            )),

              Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  alignment: Alignment.centerRight,
                  child: CircleAvatar(
                    radius: 40,
                    backgroundImage: NetworkImage(
                      'http://10.0.0.184:8015/userservices/retrievephoto/${staff.userRef}/retrievephoto',
                      headers: headers,
                    ),
                    // backgroundImage: AssetImage('images/ebele.png'),
                  ),
                ),

                  Container(
                    alignment: Alignment.center,
                        // margin: const EdgeInsets.only(bottom: 10, top: 5, left: 60),
                        // width: 120,
                        child: Row(
                          children: [
                            Text(
                                // 'Ebele',
                                (staff.firstName as String),
                                style: TextStyle(color: Colors.black),
                              ),
                              Text(' '),
                            Text(
                              (staff.lastName as String),
                              // '',
                              style: TextStyle(color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                    Container(
                      padding: const EdgeInsets.all(5),
                      // width: 200,
                      height: 27,
                      decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: Text(
                        userData.value['JobTitle'] ?? '',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            color: Color(0xff55BE88),
                            fontSize: 14,
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.bold),
                      ),
                    )
              ],
             ),

             Builder(builder: (BuildContext context) {
                  return IconButton(
                            onPressed: () => Scaffold.of(context).openDrawer(),
                            icon:Icon(Icons.menu,
                                color: Colors.grey[600]
                                ));
                })
          ]),),

          Expanded(
            child: Container(
          //  margin: const EdgeInsets.only(bottom: 20),
            // height: 700,
            // padding: currentIndex.value != 0 ? const EdgeInsets.only(top: 20) : null,
            clipBehavior: Clip.hardEdge,
        decoration: const BoxDecoration(
          color: Color(0xffD6EBE3),
          // color: Colors.white
          // color: Colors.red,
          borderRadius: BorderRadius.vertical(top:Radius.circular(60))
          ),
            child: screens.elementAt(currentIndex.value),)
            )
        ],)
          ),
      drawer: Drawer(
          backgroundColor: const Color(0xffD6EBE3),
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
                          backgroundImage: NetworkImage(
                            'http://10.0.0.184:8015/userservices/retrievephoto/${staff.userRef}/retrievephoto',
                            headers: headers,
                          ),
                          // backgroundImage: AssetImage('images/ebele.png'),  
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
                                  (staff.firstName as String),
                                  // 'Ebele',
                                  style: const TextStyle(color: Colors.black),
                                ),
                              ),
                              Text(
                                (staff.lastName as String),
                                // '',
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
                  Icons.request_quote,
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
                  Icons.manage_accounts,
                  color: Color(0xff15B77C),
                ),),
                title: const Text('Appraisals', style: TextStyle(color: Colors.black)),
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
                  Icons.receipt,
                  color: Color(0xff15B77C),
                ),),
                title: const Text('Transactions', style: TextStyle(color: Colors.black)),
                onTap: () {
                  Navigator.pop(context);
                  currentIndex.value = 5;
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
                  currentIndex.value = 6;
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
                  _showMyDialog();
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
          BottomNavigationBarItem(icon: Icon(Icons.request_quote), label: 'Pay Slip'),
          BottomNavigationBarItem(
              icon: Icon(Icons.manage_accounts), label: 'Appraisals'),
          BottomNavigationBarItem(
              icon: Icon(Icons.receipt), label: 'Transactions'),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings), label: 'Settings'),

              
              // BottomNavigationBarItem(
              // icon: Icon(Icons.settings), label: 'Settings'),
        ],
        currentIndex: currentIndex.value,
        onTap: (int index) {
          currentIndex.value = index;
        },
        selectedItemColor: const Color(0xff15B77C),
        unselectedItemColor:Colors.grey[400],
        unselectedFontSize: 12,
        selectedFontSize: 14,
      ),)
    ));
  }
}
