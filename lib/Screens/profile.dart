import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:e_360/Models/Staff.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_hooks/flutter_hooks.dart';

class Profile extends HookWidget {
  final Staff staff;
  const Profile({super.key, required this.staff});

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
      
      return response.body;
    }
  }
    Future<dynamic> getDetails() async {
    Uri url = Uri.parse(
        'http://10.0.0.184:8015/userservices/primaryrecord/11536/primaryrecord');
    var token = {
      'br': "66006500390034006200650036003400390065006500630063006400380063006600330062003200300030006200630061003300330062003300640030006300",
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

    final userData = useState<dynamic>({});

    useEffect(() {

      return () async{
        var data = await getDetails();
        userData.value = jsonDecode(data)['data'];
      };
  }, [null]);

    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            FutureBuilder(
              future: getProfilePhoto(),
              builder: ((context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasError) {
                    return const Text('Error');
                  } else if (snapshot.hasData) {
                    return const CircleAvatar(
                      radius: 30,
                    );
                  } else {
                    return const Text('Empty data');
                  }
                }
                return const Text("fwf");
              }),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(top: 10),
                  child: Text('Welcome!', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),)),
                Container(
                  margin: const EdgeInsets.only(bottom: 10, top: 5),
                  width: 120,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        (staff.firstName as String),
                      ),
                      Text(
                        (staff.lastName as String),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  IconButton(
                      onPressed: () {}, icon: const Icon(Icons.notifications)),
                  IconButton(onPressed: () {}, icon: const Icon(Icons.menu))
                ],
              ),
            )
          ],
        ),
        Row(
          children: [
            Container(
              padding: EdgeInsets.only(right: 10),
              alignment: Alignment.centerLeft,
              // width: 160,
              decoration: BoxDecoration(
                  color: Colors.grey[350],
                  borderRadius: const BorderRadius.only(
                      bottomRight: Radius.circular(10),
                      topRight: Radius.circular(10))),
              margin: const EdgeInsets.only(left: 10, top: 20),
              child: Row(
                children: [
                const Icon(Icons.business, color: Color(0xff55BE88)),
                Text(
                  userData.value['JobTitle'],
                  style: const TextStyle(color: Color(0xff55BE88),
                  fontSize: 10,
                  fontStyle: FontStyle.normal
                  ),
                )
              ]),
            ),
          //  ElevatedButton(onPressed: (){
          //     print(userData.value);
          //  }, child: Text('cnvl'))
          ],
        )
      ]),
    );
  }
}
