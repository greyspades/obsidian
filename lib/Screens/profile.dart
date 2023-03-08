import 'package:e_360/helpers/contract.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:e_360/Models/Staff.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:convert/convert.dart';
import 'dart:async';
import 'package:local_session_timeout/local_session_timeout.dart';
import 'package:e_360/helpers/contract.dart';
import 'package:e_360/helpers/aes.dart';

class Profile extends HookConsumerWidget {
  final Staff staff;
  final Map<String, dynamic>? info;
  const Profile({super.key, required this.staff, this.info});
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authProvider);

    final email = useState<String?>(null);

    final phone = useState<String?>(null);

    useEffect(() {
      void getEmail() async {
        Uri url = Uri.parse(
            'http://10.0.0.184:8015/userservices/retrievemyemails');

        var token = jsonEncode({
          'tk': auth.token,
          'us': staff.userRef,
          'rl': staff.uRole,
          'src': 'AS-IN-D659B-e3M'
        });

        var xheaders = encryption(token, auth.aesKey ?? '', auth.iv ?? '');

        var headers = {
          'x-lapo-eve-proc': base64ToHex(xheaders) + auth.token.toString(),
          'Content-type': 'text/json',
        };
      
        var response = await http.get(url, headers: headers);


        if (response.statusCode == 200) {

          final code = base64.encode(hex.decode(jsonDecode(response.body)['data']));

          final payload = decryption(code, auth.aesKey ?? '', auth.iv ?? '');

          var data = Map<dynamic, dynamic>.from(jsonDecode(payload)[0])["Item"];

          email.value = data;
        }
      }
       void getPhone() async {
        Uri url = Uri.parse(
            'http://10.0.0.184:8015/userservices/retrievemymobilenumbers');

        var token = jsonEncode({
          'tk': auth.token,
          'us': staff.userRef,
          'rl': staff.uRole,
          'src': 'AS-IN-D659B-e3M'
        });

        var xheaders = encryption(token, auth.aesKey ?? '', auth.iv ?? '');

        var headers = {
          'x-lapo-eve-proc': base64ToHex(xheaders) + auth.token.toString(),
          'Content-type': 'text/json',
        };
      
        var response = await http.get(url, headers: headers);
        if (response.statusCode == 200) {

          final code = base64.encode(hex.decode(jsonDecode(response.body)['data']));

          final payload = decryption(code, auth.aesKey ?? '', auth.iv ?? '');

          var data = Map<dynamic, dynamic>.from(jsonDecode(payload)[0])["Item"];

          phone.value = data;
        }
      }

      getEmail();
      getPhone();
      // getTransactions();
    }, []);

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
        'value': info?['MaritalStatus'] ?? 'null',
        'icon': Icons.group
      },
      {
        'title': 'Email Address',
        'value': email.value,
        'icon': Icons.mail
      },
      {
        'title': 'Phone Number',
        'value': phone.value,
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

    return (
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
