import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:e_360/Models/Staff.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Profile extends HookWidget {
  final Staff staff;
  final Map<String, dynamic>? info;
  const Profile({super.key, required this.staff, this.info});

  Future<dynamic> getProfilePhoto() async {
    Uri url = Uri.parse(
        'http://10.0.0.184:8015/userservices/retrievephoto/${staff.userRef}/retrievephoto');
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
      return response.bodyBytes;
    }
  }

  dynamic getDetails() async {
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
      return response.body;
    }
  }

  @override
  Widget build(BuildContext context) {
    // final userData = useState<dynamic>({});

    List<Map<String, dynamic>> userInfo = [
      {
        'title': 'Employee Number',
        'value': info?['Employee_No'] ?? 'null',
        'icon': Icons.numbers
      },
      {
        'title': 'Business Unit Name',
        'value': staff.buName,
        'icon': Icons.business
      },
      {
        'title': 'Gender',
        'value': info?['Gender'] ?? 'null',
        'icon': info?['Gender'] == 'Male' ? Icons.male : Icons.female
      },
      {
        'title': 'Rank',
        'value': info?['Rank'] ?? 'null',
        'icon': Icons.group
      },
      {
        'title': 'Hire Date',
        'value': info?['HireDate'] ?? 'null',
        'icon': Icons.event
      },
      {
        'title': 'Confirm Date',
        'value': info?['ConfirmDate'] ?? 'null',
        'icon': Icons.event_available,
      },
      {
        'title': 'Marital Status',
        'value': info?['maritalStatus'] ?? 'null',
        'icon': Icons.group
      },
      {
        'title': 'Email Address',
        'value': info?['Email'] ?? 'null',
        'icon': Icons.mail
      },
      {
        'title': 'Phone Number',
        'value': info?['Mobile'] ?? 'null',
        'icon': Icons.local_phone
      },
    ];

    List<Widget> listInfo() {
      return userInfo
          .map<Widget>((Map<String, dynamic> data) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 5, top: 20),
                    child: Text(data['title']),
                  ),
                  SizedBox(
                    // width: 330,
                    height: 71,
                    child: Card(
                      // color: Color(0xffD6EBE3),
                      color: Colors.grey[200],
                      child: Row(children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 5, right: 10),
                          child: Icon(data['icon'], color: const Color(0xff15B77C)),
                        ),
                        Text(data['value'] != null ? data['value'] : "null")
                      ]),
                    ),
                  )
                ],
              ))
          .toList();
    }

    // useEffect(() {
    //   void getData() async {
    //     Uri url = Uri.parse(
    //         'http://10.0.0.184:8015/userservices/primaryrecord/11536/primaryrecord');
    //     var token = {
    //       'br':
    //           "66006500390034006200650036003400390065006500630063006400380063006600330062003200300030006200630061003300330062003300640030006300",
    //       'us': staff.userRef,
    //       'rl': staff.uRole
    //     };
    //     var headers = {
    //       'x-lapo-eve-proc': jsonEncode(token),
    //       'Content-type': 'text/json',
    //     };
    //     var response = await http.get(url, headers: headers);

    //     if (response.statusCode == 200) {
    //       userData.value = jsonDecode(response.body)['data'];
    //       // return response.body;
    //     }
    //   }

    //   getData();
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

    return (
      // padding: const EdgeInsets.all(10),
      Container(
        padding: const EdgeInsets.only(left: 10, right: 10),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top:Radius.circular(60))
          ),
            child: ListView(
              children: listInfo(),
            )
          )
    );
  }
}
