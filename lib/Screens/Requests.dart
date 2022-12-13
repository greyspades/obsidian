import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:e_360/Models/Staff.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:e_360/Widgets/input.dart';
import 'package:e_360/Models/DepOfficer.dart';

class Requests extends StatefulWidget {
  final Staff staff;
  final Map<String, dynamic> info;
  Requests({super.key, required this.staff, required this.info});

  @override
  State<Requests> createState() => RequestsState();
}

class RequestsState extends State<Requests> {
  // final Staff staff;
  // final Map<String, dynamic> info;
  // Requests({super.key, required this.staff, required this.info});

  String? leaveType;

  List<dynamic>? leaveTypes;

  List<dynamic>? depOfficers;

  DateTime startDate = DateTime.now();

  DateTime endDate = DateTime.now();

  DateTime resumptionDate = DateTime.now();

  bool setLoading = false;

  String? depOfficer;

  bool payLtg = false;

  bool onBehalf = false;

  String? startDateError;

  String? endDateError;

  String? resumptionDateError;


  final _deputizingOfficerController = TextEditingController();
  final _startDateController = TextEditingController();
  final _endDateController = TextEditingController();
  final _resumptionDateController = TextEditingController();
  final _mobileController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressController = TextEditingController();
  final _beneficiaryController = TextEditingController();
  final _justificationController = TextEditingController();

  Future<void> getLeaveTypes() async {
    Uri url = Uri.parse('http://10.0.0.184:8015/requisition/leave/leavetypes');
    var token = {
      'br':
          "66006500390034006200650036003400390065006500630063006400380063006600330062003200300030006200630061003300330062003300640030006300",
      'us': widget.staff.userRef,
      'rl': widget.staff.uRole
    };
    var headers = {
      'x-lapo-eve-proc': jsonEncode(token),
      'Content-type': 'text/json',
    };
    var response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      setState(() {
        leaveTypes = jsonDecode(response.body)['data'];
        leaveType = jsonDecode(response.body)['data'][0]['Code'].toString();
      });
    }
  }

  Future<void> getDeputizingOfficer() async {
    Uri url = Uri.parse('http://10.0.0.184:8015/userservices/mylinemanager');
    var token = {
      'br':
          "66006500390034006200650036003400390065006500630063006400380063006600330062003200300030006200630061003300330062003300640030006300",
      'us': widget.staff.userRef,
      'rl': widget.staff.uRole
    };
    var headers = {
      'x-lapo-eve-proc': jsonEncode(token),
      'Content-type': 'text/json',
    };
    var response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      setState(() {
        depOfficers = jsonDecode(response.body)['data'];
        depOfficer = jsonDecode(response.body)['data'][0]['ItemCode'];
      });
    }
  }

  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: startDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null &&
        picked != startDate &&
        picked.compareTo(DateTime.now()) > 0) {
      final trueEndDate = picked.add(const Duration(days: 10));
      setState(() {
        startDate = picked;
        endDate = trueEndDate;
        startDateError = null;
      });
    } else if (picked != null &&
        picked != startDate &&
        picked.compareTo(DateTime.now()) < 0) {
      setState(() {
        startDateError = 'Only enter future dates';
      });
    }
  }

  Future<void> _selectResumptiontDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: resumptionDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null &&
        picked != resumptionDate &&
        picked.compareTo(DateTime.now()) > 0) {
      setState(() {
        resumptionDate = picked;
        resumptionDateError = null;
      });
    } else if (picked != null &&
        picked != resumptionDate &&
        picked.compareTo(DateTime.now()) < 0) {
      setState(() {
        resumptionDateError = 'Only enter future dates';
      });
    }
  }

  Future<void> _selectEndDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: endDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != endDate && picked.compareTo(DateTime.now()) > 0) {
      setState(() {
        endDate = picked;
        endDateError = null;
      });
    } else if (picked != null &&
        picked != endDate &&
        picked.compareTo(DateTime.now()) < 0) {
      setState(() {
        endDateError = 'Only enter future dates';
      });
    }
  }

  void createLeave() async {
    DateTime start = DateTime.parse(startDate.toString());
    DateTime end = DateTime.parse(endDate.toString());
    final differenceInDays = end.difference(start).inDays;

    Uri url = Uri.parse('http://10.0.0.184:8015/requisition/createleave');
    var token = {
      'br':
          "66006500390034006200650036003400390065006500630063006400380063006600330062003200300030006200630061003300330062003300640030006300",
      'us': widget.staff.userRef,
      'rl': widget.staff.uRole
    };
    var headers = {
      'x-lapo-eve-proc': jsonEncode(token),
      'Content-type': 'text/json',
    };
    var body = {
      "xLeaveType": leaveType.toString(),
      "xSelf": 0,
      "xOnBehalf": 0,
      "xLeaveOrigin": widget.staff.userRef.toString(),
      "xLeaveOwner": widget.staff.userRef.toString(),
      "xLTG": "0",
      "xBhalfReason": "9999",
      "xDepOfficer": depOfficer,
      "xStart_Date": startDate.toString(),
      "xEnd_Date": endDate.toString(),
      "xRsm_Date": resumptionDate.toString(),
      "xYear": "2022",
      "xHasDoc": "0",
      "xDuration": differenceInDays.toString(),
      "xisJustifiable": 0,
      "xJustify": "",
      "xMobile": _mobileController.text.toString(),
      "xEmail": _emailController.text.toString(),
      "xAddress": _addressController.text.toString(),
      "xTrans": {
        "xTransRef": "",
        "xTransScope": "129dekekddkffmf2sv25",
        "xAppTransScope": "9e9efefech009eee",
        "xAppSource": "AS-IN-D659B-e3M"
      }
    };
    var response =
        await http.post(url, headers: headers, body: jsonEncode(body));
    if (response.statusCode == 200) {
      _showMyDialog(jsonDecode(response.body));
    }
  }

  validateField(String value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a username';
    }
    return null;
  }

  validatePhone(String value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a phone number during leave';
    }
    if (value.length != 11) {
      return 'Must be 11 digits and start with 0';
    }
    return null;
  }

  validateEmail(String value) {
    if (value == null || value.isEmpty) {
      return 'Please enter an email address during leave';
    }
    if (!value.contains('@') || !value.contains('.')) {
      return 'Not a valid email address';
    }
    return null;
  }

  validateAddress(String value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a residential address during leave';
    }
    return null;
  }

  Future<void> _showMyDialog(Map data) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: data['status'] == false
              ? const Text('Unsuccessful')
              : const Text('Success'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(data['message']),
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

  static final _formKey = GlobalKey<FormState>(debugLabel: '');

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLeaveTypes();
    getDeputizingOfficer();
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> dummy = [
      {'name': 'ludex', 'title': 'gundyr'},
      {'name': 'peter', 'title': 'gundyr'},
      {'name': 'pan', 'title': 'gundyr'}
    ];

    getCurrentDate(String type) {
      var date = type == 'start' ? startDate.toString() : endDate.toString();

      var dateParse = DateTime.parse(date);

      var formattedDate = "${dateParse.day}";

      return formattedDate;
    }

    void submit() {
      setLoading = !setLoading;
    }

    return Container(
      color: Colors.white,
      child: ListView(children: [
        Container(
          margin: const EdgeInsets.only(top: 5, bottom: 20, left: 20),
          child: const Text(
            'Requisition Details',
            style: TextStyle(color: Color(0xff88A59A)),
          ),
        ),

        const Padding(padding: EdgeInsets.only(left: 10, right: 20), child: Text('Who is this Requisition for?'),),
        Container(
          padding: const EdgeInsets.only(left: 100, right: 100),
          width: 100,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
          const Text('Self'),
          SizedBox(
                                  width: 90,
                                  height: 70,
                                  child: FittedBox(
                                    fit: BoxFit.fill,
                                    child: Switch(
                                      value: onBehalf,
                                      onChanged: (bool value) {
                                        setState(() {
                                          onBehalf = value;
                                        });
                                      },
                                      activeColor: const Color(0xff15B77C),
                                      activeTrackColor: const Color(0xffD6EBE3),
                                      inactiveThumbColor:
                                          const Color(0xffD6EBE3),
                                      inactiveTrackColor:
                                          const Color(0xffD9D9D9),
                                    ),
                                  ),
                                ),
                                const Text('On Behalf')
        ],)),
        // Container(
        //   padding: EdgeInsets.only(left: 120, right: 120),

        //   alignment: Alignment.center,
        //   width: 200,
        //   child:  Row(
        //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        //     children: [
        //     SizedBox(
        //       child: Checkbox(value: self, onChanged: (bool? value) {
        //         setState(() {
        //           self = value!;
        //         });
        //       },)
        //     ),
        //     SizedBox(
        //       child: Checkbox(value: self, onChanged: (bool? value) {
        //         setState(() {
        //           self = value!;
        //         });
        //       },)
        //     )
        //   ],)
        // ),
        Container(
          child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Container(
                      width: MediaQuery.of(context).size.width,
                      height: 130,
                      color: const Color(0xffD6EBE3),
                      child: Container(
                        margin: const EdgeInsets.only(
                            top: 40, left: 20, bottom: 20, right: 70),
                        width: 100,
                        height: 40,
                        child: DropdownButtonFormField(
                          decoration: const InputDecoration(
                            fillColor: Colors.white,
                            filled: true,
                            border: OutlineInputBorder(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(10.0),
                              ),
                            ),
                          ),
                          value: leaveTypes?[0]['Item'],
                          icon: const Icon(Icons.keyboard_arrow_down),
                          items: leaveTypes?.map<DropdownMenuItem>((item) {
                            return DropdownMenuItem(
                              child: Text(item['Item']),
                              value: item['Item'],
                            );
                          }).toList(),
                          onChanged: (item) {
                            var ref = leaveTypes
                                ?.where((element) => element['Item'] == item)
                                .single['Code']
                                .toString();
                            setState(() {
                              leaveType = ref;
                            });
                          },
                        ),
                      )),
                      Container(
                        margin: onBehalf == true ? const EdgeInsets.only(top: 30) : null,
                        padding: const EdgeInsets.only(left: 10, right: 20),
                        child: onBehalf == true ? CustomInput(
                                  controller: _beneficiaryController,
                                  validation: validateField,
                                  hintText: 'Beneficiary',
                                  prefixIcon: const Icon(Icons.person,
                                      color: Color(0xffF88A4C)),
                                ) : null
                      ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 10, top: 20, bottom: 30, right: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(bottom: 20),
                          child: const Text('Leave transport grant',
                              style: TextStyle(
                                  color: Color(0xff88A59A),
                                  fontWeight: FontWeight.bold)),
                        ),
                        const Text(
                            'Indicate whether or not you want your LTG paid in this requisition'),
                        Row(
                          children: [
                            const Text('Pay LTG ?'),
                            Container(
                                margin: const EdgeInsets.only(left: 20),
                                child: SizedBox(
                                  width: 100,
                                  height: 70,
                                  child: FittedBox(
                                    fit: BoxFit.fill,
                                    child: Switch(
                                      value: payLtg,
                                      onChanged: (bool value) {
                                        setState(() {
                                          payLtg = !payLtg;
                                        });
                                      },
                                      activeColor: const Color(0xff15B77C),
                                      activeTrackColor: const Color(0xffD6EBE3),
                                      inactiveThumbColor:
                                          const Color(0xffD6EBE3),
                                      inactiveTrackColor:
                                          const Color(0xffD9D9D9),
                                    ),
                                  ),
                                ))
                          ],
                        ),
                        Container(
                          margin: const EdgeInsets.only(bottom: 10, top: 10),
                          child: const Divider(
                              color: Color(0xffD6EBE3),
                              height: 1,
                              thickness: 2),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 10, bottom: 10),
                          // child: depOfficer.value != null ? Text('fer') : null,
                          width: 200,
                          child: DropdownButtonFormField(
                            decoration: const InputDecoration(
                              fillColor: Colors.white,
                              filled: true,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10.0),
                                ),
                              ),
                            ),
                            value: depOfficers?[0]['ItemName'],
                            icon: const Icon(Icons.keyboard_arrow_down),
                            items: depOfficers?.map<DropdownMenuItem>((item) {
                              return DropdownMenuItem(
                                  child: Text(
                                    item['ItemName'],
                                    style: TextStyle(fontSize: 14),
                                  ),
                                  value: item['ItemName']);
                            }).toList(),
                            onChanged: (item) {
                              var value = depOfficers
                                  ?.where((data) => data['ItemName'] == item)
                                  .single;
                              setState(() {
                                value['ItemCode']!;
                              });
                            },
                          ),
                        ),
                        Container(
                          child: const Text(
                              'Select a leave deputizing officer. This staff should be within your reporting line'),
                        ),
                        Container(
                          margin: const EdgeInsets.only(bottom: 10, top: 15),
                          child: const Divider(
                              color: Color(0xffD6EBE3),
                              height: 1,
                              thickness: 2),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 10),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                    child: Padding(
                                        padding:
                                            const EdgeInsets.only(right: 10),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                                margin: const EdgeInsets.only(
                                                    bottom: 5),
                                                decoration: const BoxDecoration(
                                                    color: Color(0xffDFEEE9),
                                                    border: Border(
                                                        bottom: BorderSide(
                                                            color: Color(
                                                                0xff15B77C),
                                                            width: 3))),
                                                child: SizedBox(
                                                  height: 50,
                                                  child: ListTile(
                                                    leading: const Icon(
                                                      Icons.today,
                                                      color: Color(0xffF88A4C),
                                                    ),
                                                    title: Text(
                                                        DateTime.parse(startDate
                                                                .toString())
                                                            .toString()
                                                            .split(" ")[0],
                                                        style: const TextStyle(
                                                            fontSize: 14)),
                                                    onTap: () =>
                                                        _selectStartDate(
                                                            context),
                                                  ),
                                                )),
                                            startDateError != null
                                                ? Text(
                                                    startDateError ?? '',
                                                    style: TextStyle(
                                                        color: Colors.red,
                                                        fontSize: 11),
                                                  )
                                                : Text('Start Date')
                                          ],
                                        ))),
                                Expanded(
                                    child: Padding(
                                        padding:
                                            const EdgeInsets.only(left: 10),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                                margin: const EdgeInsets.only(
                                                    bottom: 5),
                                                decoration: const BoxDecoration(
                                                    color: Color(0xffDFEEE9),
                                                    border: Border(
                                                        bottom: BorderSide(
                                                            color: Color(
                                                                0xff15B77C),
                                                            width: 3))),
                                                child: SizedBox(
                                                  height: 50,
                                                  child: ListTile(
                                                    leading: const Icon(
                                                      Icons.today,
                                                      color: Color(0xffF88A4C),
                                                    ),
                                                    title: Text(
                                                      DateTime.parse(endDate
                                                              .toString())
                                                          .toString()
                                                          .split(" ")[0],
                                                      style: const TextStyle(
                                                          fontSize: 14),
                                                    ),
                                                    onTap: () =>
                                                        _selectEndDate(context),
                                                  ),
                                                )),
                                            endDateError != null
                                                ? Text(
                                                    endDateError ?? '',
                                                    style: TextStyle(
                                                        color: Colors.red,
                                                        fontSize: 11),
                                                  )
                                                : Text('End Date')
                                          ],
                                        )))
                              ]),
                        ),
                        Container(
                            margin: const EdgeInsets.only(top: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                    margin: const EdgeInsets.only(bottom: 5),
                                    decoration: const BoxDecoration(
                                        color: Color(0xffDFEEE9),
                                        border: Border(
                                            bottom: BorderSide(
                                                color: Color(0xff15B77C),
                                                width: 3))),
                                    child: SizedBox(
                                      height: 50,
                                      child: ListTile(
                                        leading: const Icon(
                                          Icons.today,
                                          color: Color(0xffF88A4C),
                                        ),
                                        title: Text(
                                            DateTime.parse(
                                                    resumptionDate.toString())
                                                .toString()
                                                .split(" ")[0],
                                            style:
                                                const TextStyle(fontSize: 14)),
                                        onTap: () =>
                                            _selectResumptiontDate(context),
                                      ),
                                    )),
                                resumptionDateError != null
                                                ? Text(
                                                    resumptionDateError ?? '',
                                                    style: TextStyle(
                                                        color: Colors.red,
                                                        fontSize: 11),
                                                  )
                                                : Text('Resumption Date')
                              ],
                            )),
                        Container(
                          margin: const EdgeInsets.only(bottom: 10, top: 15),
                          child: const Divider(
                              color: Color(0xffD6EBE3),
                              height: 1,
                              thickness: 2),
                        ),
                        Container(
                          height: 220,
                          margin: const EdgeInsets.only(top: 10),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              // mainAxisSize: MainAxisSize.max,
                              children: [
                                CustomInput(
                                  controller: _mobileController,
                                  validation: validatePhone,
                                  hintText: 'Mobile during leave',
                                  prefixIcon: const Icon(Icons.call,
                                      color: Color(0xffF88A4C)),
                                  textType: TextInputType.number,
                                ),
                                CustomInput(
                                  controller: _emailController,
                                  validation: validateEmail,
                                  hintText: 'Email during leave',
                                  prefixIcon: const Icon(Icons.email,
                                      color: Color(0xffF88A4C)),
                                ),
                                CustomInput(
                                  controller: _addressController,
                                  validation: validateAddress,
                                  hintText: 'Address during leave',
                                  prefixIcon: const Icon(Icons.home,
                                      color: Color(0xffF88A4C)),
                                ),
                              ]),
                        )
                      ],
                    ),
                  )
                ],
              )),
        ),
        Padding(
            padding: const EdgeInsets.only(left: 10, right: 10, bottom: 20),
            child: SizedBox(
              height: 60,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff15B77C),
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      createLeave();
                    }
                  },
                  child: setLoading != true
                      ? const Text(
                          'Submit',
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        )
                      : CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 5,
                        )),
            ))
      ]),
    );
  }
}
