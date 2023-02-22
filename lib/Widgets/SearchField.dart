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
import 'package:convert/convert.dart';
import 'package:e_360/helpers/contract.dart';
import 'package:e_360/helpers/aes.dart';


class SearchField extends HookConsumerWidget {

  Staff staff;
  Map<dynamic, dynamic> info;
  ValueNotifier<Map<dynamic, dynamic>> downline;
  String label;

  SearchField({super.key, required this.staff, required this.info, required this.downline, required this.label});

  static final _formKey = GlobalKey<FormState>(debugLabel: '');  

  @override 

  Widget build(BuildContext context, WidgetRef ref) {
  
  final Auth auth = ref.watch(authProvider);
  
  final searchController = useTextEditingController();

  final selectedDownline = useState({});

  final division = useState<Map<dynamic, dynamic>>({});

    Future<dynamic> search(String item) async {
      
    Uri url = Uri.parse('http://10.0.0.184:8015/userservices/searchemployees');
    var token = jsonEncode({
      'tk': auth.token,
      'us': staff.userRef,
      'rl': staff.uRole,
      'src': "AS-IN-D659B-e3M"
    });
    var headers = {
      'x-lapo-eve-proc': base64ToHex(encryption(token, auth.aesKey ?? '', auth.iv ?? '')),
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

    final xpayload = base64ToHex(encryption(body, auth.aesKey ?? '', auth.iv ?? ''));
    var response =
        await http.post(url, headers: headers, body: xpayload);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body)["data"];
    var xData = decryption(base64.encode(hex.decode(data)), auth.aesKey ?? '', auth.iv ?? '');
      var result =
          List<Map<dynamic, dynamic>>.from(jsonDecode(xData));
          
      return result;
    }
  }

  Future<void> getDivision() async {
    Uri url = Uri.parse('http://10.0.0.184:8015/userservices/divisionbyempNo');
    var token = jsonEncode({
      'tk': auth.token,
      'us': staff.userRef,
      'rl': staff.uRole,
      'src': "AS-IN-D659B-e3M"
    });
    var headers = {
      'x-lapo-eve-proc': base64ToHex(encryption(token, auth.aesKey ?? '', auth.iv ?? '')),
      'Content-type': 'text/json',
    };

    var body = jsonEncode({"xParam": staff.userRef});

    final xpayload = base64ToHex(encryption(body, auth.aesKey ?? '', auth.iv ?? ''));

    var response = await http.post(url,
        headers: headers, body: xpayload);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body)["data"];
    var xData = decryption(base64.encode(hex.decode(data)), auth.aesKey ?? '', auth.iv ?? '');
      var divisionResponse =
          Map<dynamic, dynamic>.from(jsonDecode(xData));
      division.value = divisionResponse;
    }
  }

  useEffect(() {
    getDivision();
  }, []);

    return SingleChildScrollView(
      child: Container(
              margin: const EdgeInsets.only(top: 30),
              child: Form(
                key: _formKey,
                child: TypeAheadFormField(
                                  textFieldConfiguration:
                                      TextFieldConfiguration(

                                          autofocus: false,
                                          style: DefaultTextStyle.of(context)
                                              .style
                                              .copyWith(
                                                  fontStyle: FontStyle.italic,
                                                  height: 1.5,
                                                  fontSize: 14),
                                          controller: searchController,
                                          cursorColor: Colors.black,
                                          decoration: InputDecoration(
                                            labelText: label,
                                            labelStyle: const TextStyle(color: Colors.black),
                                            prefixIcon: const Icon(
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
                                      height: 100,
                                      color: Colors.red,
                                      padding: const EdgeInsets.all(10),
                                      child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              data['ItemName'],
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            Container(
                                              padding:
                                                  const EdgeInsets.only(top: 5),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      data['Item_Title_Desc'],
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                  Text(
                                                    data['Bu'],
                                                    overflow:
                                                        TextOverflow.ellipsis,
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
                                    var data =
                                        suggestion as Map<dynamic, dynamic>;
                                        downline.value = data['ItemName'];
                                    // downline.value =
                                    //     TextEditingValue(
                                    //   text: data['ItemName'],
                                    //   selection: TextSelection.fromPosition(
                                    //     TextPosition(
                                    //         offset: data['ItemName'].length),
                                    //   ),
                                    // );
                                    selectedDownline.value = suggestion;
                                  },
                                ),)
            ),
    );
  }
  
}