import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:e_360/Models/Staff.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:e_360/Widgets/input.dart';
import 'package:e_360/Models/DepOfficer.dart';
import 'package:e_360/Screens/SettingsItem.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:e_360/Widgets/SearchField.dart';
import 'package:convert/convert.dart';
import 'package:e_360/helpers/contract.dart';
import 'package:e_360/helpers/aes.dart';

class LineManager extends HookConsumerWidget {
  Staff staff;
  Map<dynamic, dynamic> info;
  LineManager({super.key, required this.staff, required this.info});

  static final _formKey = GlobalKey<FormState>(debugLabel: '');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Auth auth = ref.watch(authProvider);

    final division = useState<Map<dynamic, dynamic>>({});

    final downlineController = useTextEditingController();

    final selectedDonwline = useState({});

    final loading = useState<bool>(false);

    final downline = useState({});

    final error = useState<String?>(null);

    Future<dynamic> search(String item) async {
      Uri url =
          Uri.parse('https://e360.lapo-nigeria.org/userservices/searchemployees');
      var token = jsonEncode({
        'tk': auth.token,
        'us': staff.userRef,
        'rl': staff.uRole,
        'src': "AS-IN-D659B-e3M"
      });
      var headers = {
        'x-lapo-eve-proc':
            base64ToHex(encryption(token, auth.aesKey ?? '', auth.iv ?? '')) + (auth.token ?? ''),
        'Content-type': 'text/json',
      };

      var body = jsonEncode({
        "xParam": item,
        "xBuCode": "",
        "xScope": division.value['DivisionName'],
        "xScopeRef": division.value['DivisionCode'],
        "xRowCount": 1,
        "xFromDate": "",
        "xToDate": "",
        "xApp": "AS-IN-D659B-e3M",
        "xPageIndex": 1,
        "xPageSize": 1
      });
      var response = await http.post(url,
          headers: headers,
          body:
              base64ToHex(encryption(body, auth.aesKey ?? '', auth.iv ?? '')));
      if (response.statusCode == 200) {
        var xdata = decryption(
            base64.encode(hex.decode(jsonDecode(response.body)['data'])),
            auth.aesKey ?? '',
            auth.iv ?? '');
        var result = List<Map<dynamic, dynamic>>.from(jsonDecode(xdata));

        return result;
      }
    }

    Future<void> getDivision() async {
      Uri url =
          Uri.parse('https://e360.lapo-nigeria.org/userservices/divisionbyempNo');
      var token = jsonEncode({
        'tk': auth.token,
        'us': staff.userRef,
        'rl': staff.uRole,
        'src': "AS-IN-D659B-e3M"
      });
      var headers = {
        'x-lapo-eve-proc':
            base64ToHex(encryption(token, auth.aesKey ?? '', auth.iv ?? '')) + (auth.token ?? ''),
        'Content-type': 'text/json',
      };

      var body = jsonEncode({
        "xParam": staff.userRef,
        "xBuCode": "",
        "xScope": "",
        "xScopeRef": "",
        "xRowCount": 1,
        "xFromDate": "",
        "xToDate": "",
        "xApp": "AS-IN-D659B-e3M",
        "xPageIndex": 1,
        "xPageSize": 1
      });

      final xpayload =
          base64ToHex(encryption(body, auth.aesKey ?? '', auth.iv ?? ''));

      var response = await http.post(url, headers: headers, body: xpayload);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body)["data"];
        var xData = decryption(
            base64.encode(hex.decode(data)), auth.aesKey ?? '', auth.iv ?? '');
        var divisionResponse = Map<dynamic, dynamic>.from(jsonDecode(xData));
        division.value = divisionResponse;
      }
    }

    Future<void> _showMyDialog(Map data) async {
      loading.value = false;
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: data['status'] == 400
                ? const Text('Unsuccessful')
                : const Text('Success'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text(data['message_description']),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Close'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }

    Future<void> createDownline() async {
      loading.value = true;
      Uri url = Uri.parse('https://e360.lapo-nigeria.org/userservices/createdownline');
      var token = jsonEncode({
        'tk': auth.token,
        'us': staff.userRef,
        'rl': staff.uRole,
        'src': "AS-IN-D659B-e3M"
      });
      var headers = {
        'x-lapo-eve-proc':
            base64ToHex(encryption(token, auth.aesKey ?? '', auth.iv ?? '')) + (auth.token ?? ''),
        'Content-type': 'text/json',
      };
      var body = jsonEncode({
        "xDivCode": "string",
        "xDownLines": [
          {
            "xDownLnRef": selectedDonwline.value["ItemCode"],
            "xDownLnName": selectedDonwline.value["ItemName"],
            "xUserRef": staff.userRef,
            "isActive": 0,
            "isPrmary": 0
          }
        ],
        "xTrans": {
          "xTransRef": "",
          "xTransScope": "129dekekddkffmf2sv25",
          "xAppTransScope": "9e9efefech009eee",
          "xAppSource": "AS-IN-D659B-e3M"
        }
      });

      final xpayload =
          base64ToHex(encryption(body, auth.aesKey ?? '', auth.iv ?? ''));

      var response = await http.post(url, headers: headers, body: xpayload);

      var data = jsonDecode(response.body);
      _showMyDialog(data);
    }

    useEffect(() {
      getDivision();
    }, []);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Container(
        height: 700,
        // color: Colors.red,
        padding: const EdgeInsets.all(10),
        child: ListView(
          children: [
            Container(
              height: 150,
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.only(left: 20, top: 30),
              decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: const BorderRadius.all(Radius.circular(10))),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      division.value['DivisionName'] ?? '',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800]),
                    ),
                    Container(
                      height: 60,
                      margin: const EdgeInsets.only(top: 20),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Level scope: Division'),
                            const Text(
                                'Your downline selection will be limited within this scope.')
                          ]),
                    ),
                  ]),
            ),

            // SearchField(staff: staff, info: info, downline: downline)

            Container(
                margin: const EdgeInsets.only(top: 20),
                height: 400,
                child: Column(
                  children: [
                    Form(
                      key: _formKey,
                      child: TypeAheadFormField(
                        textFieldConfiguration: TextFieldConfiguration(
                            autofocus: false,
                            style: DefaultTextStyle.of(context).style.copyWith(
                                // decorationStyle: null,
                                // fontStyle: FontStyle.italic,
                                height: 1.5,
                                color: Colors.black,
                                decoration: TextDecoration.none,
                                fontSize: 14),
                            controller: downlineController,
                            cursorColor: Colors.black,
                            decoration: const InputDecoration(
                              labelText: 'Click here to search for employees',
                              labelStyle: TextStyle(color: Colors.black),
                              prefixIcon: Icon(
                                Icons.person_search,
                                color: Color(0xff15B77C),
                                size: 30,
                              ),
                              border: OutlineInputBorder(),
                              filled: true,
                              focusColor: Color(0xffDFEEE9),
                              fillColor: Color(0xffDFEEE9),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0xff15B77C),
                                  width: 3.0,
                                ),
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0xff15B77C),
                                  width: 3.0,
                                ),
                              ),
                            )),
                        suggestionsCallback: (pattern) async {
                          return await search(pattern);
                        },
                        itemBuilder: (context, item) {
                          var data = item as Map<dynamic, dynamic>;
                          return Container(
                            height: 60,
                            padding: const EdgeInsets.all(10),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    data['ItemName'],
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Container(
                                    padding: const EdgeInsets.only(top: 5),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            data['Item_Title_Desc'],
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        Text(
                                          data['Bu'],
                                          overflow: TextOverflow.ellipsis,
                                        )
                                      ],
                                    ),
                                  )
                                ]),
                          );
                        },
                        validator: ((value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a beneficiary';
                          }
                          return null;
                        }),
                        onSuggestionSelected: (suggestion) {
                          var data = suggestion as Map<dynamic, dynamic>;
                          downlineController.value = TextEditingValue(
                            text: data['ItemName'],
                            selection: TextSelection.fromPosition(
                              TextPosition(offset: data['ItemName'].length),
                            ),
                          );

                          selectedDonwline.value = suggestion;
                          error.value = null;
                        },
                      ),
                    ),
                    Flexible(
                      child: Container(
                          height:
                              selectedDonwline.value.isNotEmpty ? 100 : null,
                          color: const Color(0xffDFEEE9),
                          padding: const EdgeInsets.all(10),
                          child: selectedDonwline.value.isNotEmpty
                              ? Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    CircleAvatar(
                                      backgroundColor: Colors.grey[200],
                                      radius: 30,
                                    ),
                                    Container(
                                      height: 45,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Flexible(
                                            child: Text(
                                              selectedDonwline
                                                      .value['ItemName'] ??
                                                  '',
                                              style: const TextStyle(
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  fontSize: 12),
                                            ),
                                          ),
                                          Flexible(
                                            child: Text(
                                              selectedDonwline.value[
                                                      'Item_Title_Desc'] ??
                                                  '',
                                              style: const TextStyle(
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  fontSize: 12),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    Flexible(
                                        child: Text(
                                      selectedDonwline.value['Bu'] ?? '',
                                      style: const TextStyle(
                                          overflow: TextOverflow.ellipsis,
                                          fontSize: 12),
                                    )),
                                  ],
                                )
                              : null),
                    ),
                    Container(
                      child: Text(
                        error.value ?? '',
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: 60,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xff15B77C),
                          ),
                          onPressed: () {
                            if (selectedDonwline.value.isNotEmpty) {
                              createDownline();
                            } else {
                              error.value = 'Please select a downline';
                            }
                          },
                          child: loading.value != true
                              ? const Text(
                                  'Submit',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                )
                              : const CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 5,
                                )),
                    )
                  ],
                ))
          ],
        ),
      ),
    );
  }
}
