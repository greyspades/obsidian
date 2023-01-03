import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:e_360/Models/Staff.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:e_360/Widgets/input.dart';
import 'package:e_360/Models/DepOfficer.dart';
import 'package:e_360/Screens/SettingsItem.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';



class SearchField extends HookWidget {

  Staff staff;
  Map<dynamic, dynamic> info;
  ValueNotifier<Map<dynamic, dynamic>> downline;
  String label;

  SearchField({super.key, required this.staff, required this.info, required this.downline, required this.label});

  static final _formKey = GlobalKey<FormState>(debugLabel: '');  

  @override 

  Widget build(BuildContext context) {
  
  final searchController = useTextEditingController();

  final selectedDownline = useState({});

  final division = useState<Map<dynamic, dynamic>>({});

    Future<dynamic> search(String item) async {

      print(item);
      print(division.value['DivisionName']);
      print(division.value['DivisionCode']);
      
    Uri url = Uri.parse('http://10.0.0.184:8015/userservices/searchemployees');
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
    };
    var response =
        await http.post(url, headers: headers, body: jsonEncode(body));
    if (response.statusCode == 200) {
      var result =
          List<Map<dynamic, dynamic>>.from(jsonDecode(response.body)['data']);
          print(result);
      return result;
    }
  }

  Future<void> getDivision() async {
    Uri url = Uri.parse('http://10.0.0.184:8015/userservices/divisionbyempNo');
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
    var response = await http.post(url,
        headers: headers, body: jsonEncode({"xParam": staff.userRef}));
    if (response.statusCode == 200) {
      var divisionResponse =
          Map<dynamic, dynamic>.from(jsonDecode(response.body)['data']);
          print(divisionResponse);

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