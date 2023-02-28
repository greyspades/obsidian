import 'package:e_360/helpers/aes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:e_360/Models/Staff.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:e_360/Widgets/input.dart';
import 'package:e_360/Models/DepOfficer.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:e_360/Widgets/leaveUtilization.dart';
import 'package:e_360/helpers/contract.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:convert/convert.dart';


class Requests extends StatefulWidget {
  final Staff staff;
  final Map<String, dynamic> info;
  final Auth? auth;
  const Requests({super.key, required this.staff, required this.info, required this.auth});

  @override
  State<Requests> createState() => RequestsState();
}

enum Reasons { sick, mandated }

class RequestsState extends State<Requests> {
  // final Staff staff;
  // final Map<String, dynamic> info;
  // Requests({super.key, required this.staff, required this.info});

  String leaveType = '100';

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

  String? ltgError;

  String? leaveTypeError;

  List<dynamic>? setups;

  Map<dynamic, dynamic>? activeSetup;

  Map<dynamic, dynamic>? division;

  List<Map<dynamic, dynamic>>? searchResult;

  Map<dynamic, dynamic>? selectedOfficer;

  Map<dynamic, dynamic>? utilDetails;

  Map<dynamic, dynamic>? selectedBeneficiary;

  int dayDifference = 0;

  bool sick = false;

  bool mandated = false;

  int reason = -1;

  String reasonValue = '9999';

  final _deputizingOfficerController = TextEditingController();
  final _startDateController = TextEditingController();
  final _endDateController = TextEditingController();
  final _resumptionDateController = TextEditingController();
  final _mobileController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressController = TextEditingController();
  final beneficiaryController = TextEditingController();
  final justificationController = TextEditingController();
  final searchController = TextEditingController();

  Future<void> getLeaveTypes() async {
    Uri url = Uri.parse('http://10.0.0.184:8015/requisition/leave/leavetypes/lv_req/leavetypes');
    var token = jsonEncode({
      'tk': widget.auth?.token,
      'us': widget.staff.userRef,
      'rl': widget.staff.uRole,
      'src': "AS-IN-D659B-e3M"
    });
    var headers = {
      'x-lapo-eve-proc': base64ToHex(encryption(token, widget.auth?.aesKey ?? '', widget.auth?.iv ?? '')) + (widget.auth?.token ?? ''),
      'Content-type': 'text/json',
    };
    var response = await http.get(url, headers: headers);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body)['data'];
      
      setState(() {
        leaveTypes = jsonDecode(decryption(base64.encode(hex.decode(data)), widget.auth?.aesKey ?? '', widget.auth?.iv ?? ''));
        leaveType = jsonDecode(decryption(base64.encode(hex.decode(data)), widget.auth?.aesKey ?? '', widget.auth?.iv ?? ''))[0]['Code'].toString();
      });
    }
  }

  Future<void> getLineManager() async {
    Uri url = Uri.parse('http://10.0.0.184:8015/userservices/mylinemanager');
    var token = jsonEncode({
      'tk': widget.auth?.token,
      'us': widget.staff.userRef,
      'rl': widget.staff.uRole,
      'src': "AS-IN-D659B-e3M"
    });
    var headers = {
      'x-lapo-eve-proc': base64ToHex(encryption(token, widget.auth?.aesKey ?? '', widget.auth?.iv ?? '')) + (widget.auth?.token ?? ''),
      'Content-type': 'text/json',
    };
    var response = await http.get(url, headers: headers);
    print(response.body);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body)['data'];
      print(jsonDecode(decryption(base64.encode(hex.decode(data)), widget.auth?.aesKey ?? '', widget.auth?.iv ?? '')));
      setState(() {
        depOfficers = jsonDecode(decryption(base64.encode(hex.decode(data)), widget.auth?.aesKey ?? '', widget.auth?.iv ?? ''));
        depOfficer = jsonDecode(decryption(base64.encode(hex.decode(data)), widget.auth?.aesKey ?? '', widget.auth?.iv ?? ''))[0]['ItemCode'];
      });
    }
  }

  Future<void> getLeaveSetup() async {
    Uri url = Uri.parse('http://10.0.0.184:8015/requisition/leave/leavesetup');
    var token = jsonEncode({
      'tk': widget.auth?.token,
      'us': widget.staff.userRef,
      'rl': widget.staff.uRole,
      'src': "AS-IN-D659B-e3M"
    });
    var headers = {
      'x-lapo-eve-proc': base64ToHex(encryption(token, widget.auth?.aesKey ?? '', widget.auth?.iv ?? '')) + (widget.auth?.token ?? ''),
      'Content-type': 'text/json',
    };
    var response = await http.get(url, headers: headers);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body)['data'];
      var xdata = decryption(base64.encode(hex.decode(data)), widget.auth?.aesKey ?? '', widget.auth?.iv ?? '');
      var activeData = List<dynamic>.from(jsonDecode(xdata))
          .toList()
          .where((element) => element['lv_type_Id'].toString() == leaveType)
          .single;
      var activeMap = Map<dynamic, dynamic>.from(activeData);
      setState(() {
        setups = jsonDecode(xdata);
        activeSetup = activeMap;
      });
    }
  }

  Future<void> getDivision() async {
    Uri url = Uri.parse('http://10.0.0.184:8015/userservices/divisionbyempNo');
    
    var token = jsonEncode({
      'tk': widget.auth?.token,
      'us': widget.staff.userRef,
      'rl': widget.staff.uRole,
      'src': "AS-IN-D659B-e3M"
    });
    var headers = {
      'x-lapo-eve-proc': base64ToHex(encryption(token, widget.auth?.aesKey ?? '', widget.auth?.iv ?? '')) + (widget.auth?.token ?? ''),
      'Content-type': 'text/json',
    };
    var body = jsonEncode({
      "xParam": widget.staff.userRef,
      "xBuCode": "",
      "xScope": division?['DivisionName'],
      "xScopeRef": division?['DivisionCode'],
      "xRowCount": 1,
      "xFromDate": "",
      "xToDate": "",
      "xApp": "AS-IN-D659B-e3M",
      "xPageIndex": 1,
      "xPageSize": 1
    });
    var response = await http.post(url,
        headers: headers, body: base64ToHex(encryption(body, widget.auth?.aesKey ?? '', widget.auth?.iv ?? '')));
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body)['data'];
      var xdata = decryption(base64.encode(hex.decode(data)), widget.auth?.aesKey ?? '', widget.auth?.iv ?? '');
      var divisionResponse =
          Map<dynamic, dynamic>.from(jsonDecode(xdata));
      setState(() {
        division = divisionResponse;
      });
    }
  }

  Future<void> getUtlzDetails(String id) async {
    Uri url = Uri.parse(
        'http://10.0.0.184:8015/requisition/retrieveleaveUtlzdetails');
    var token = jsonEncode({
      'tk': widget.auth?.token,
      'us': widget.staff.userRef,
      'rl': widget.staff.uRole,
      'src': "AS-IN-D659B-e3M"
    });
    var headers = {
      'x-lapo-eve-proc': base64ToHex(encryption(token, widget.auth?.aesKey ?? '', widget.auth?.iv ?? '')) + (widget.auth?.token ?? ''),
      'Content-type': 'text/json',
    };
    var body = jsonEncode({
      "xLeaveType": id.toString(),
      "xLeaveOwner": widget.staff.userRef,
      "xYear": DateTime.now().year.toString()
    });
    var response =
        await http.post(url, headers: headers, body: base64ToHex(encryption(body, widget.auth?.aesKey ?? '', widget.auth?.iv ?? '')));
    
    if (response.statusCode == 200) {
      var xdata = decryption(base64.encode(hex.decode(jsonDecode(response.body)['data'])), widget.auth?.aesKey ?? '', widget.auth?.iv ?? '');
      var data =
          Map<dynamic, dynamic>.from(jsonDecode(xdata));
      setState(() {
        utilDetails = data;
      });
    }
  }

  Future<dynamic> search(String item) async {
    Uri url = Uri.parse('http://10.0.0.184:8015/userservices/searchemployees');
    var token = jsonEncode({
      'tk': widget.auth?.token,
      'us': widget.staff.userRef,
      'rl': widget.staff.uRole,
      'src': "AS-IN-D659B-e3M"
    });
    var headers = {
      'x-lapo-eve-proc': base64ToHex(encryption(token, widget.auth?.aesKey ?? '', widget.auth?.iv ?? '')) + (widget.auth?.token ?? ''),
      'Content-type': 'text/json',
    };

    var body = jsonEncode({
      "xParam": item,
      "xBuCode": "",
      "xScope": division?['DivisionName'],
      "xScopeRef": division?['DivisionCode'],
      "xRowCount": 1,
      "xFromDate": "",
      "xToDate": "",
      "xApp": "AS-IN-D659B-e3M",
      "xPageIndex": 1,
      "xPageSize": 1
    });
    var response =
        await http.post(url, headers: headers, body: base64ToHex(encryption(body, widget.auth?.aesKey ?? '', widget.auth?.iv ?? '')));
    if (response.statusCode == 200) {
      // print(jsonDecode(response.body)['data']);
      var xdata = decryption(base64.encode(hex.decode(jsonDecode(response.body)['data'])), widget.auth?.aesKey ?? '', widget.auth?.iv ?? '');
      // print(xdata);
      var result =
          List<Map<dynamic, dynamic>>.from(jsonDecode(xdata));
      return result;
    }
  }

  Future<void> _selectStartDate(BuildContext context) async {
    var interval = 0;

    final DateTime? picked = await showDatePicker(
        builder: (BuildContext context, Widget? child) {
      return Theme(
        data: ThemeData(
          colorScheme: const ColorScheme.light(
              primary: Color(0xff15B77C),
              ),
              dialogBackgroundColor: Colors.white,
        ),
        child: child ?? const Text(""),
      );
    },
        context: context,
        initialDate: startDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null &&
        picked != startDate &&
        picked.compareTo(DateTime.now()) > 0 &&
        picked.weekday != DateTime.saturday &&
        picked.day != DateTime.now().day &&
        picked.weekday != DateTime.sunday) {
      activeSetup?["LvMaxDuration_Male"];
      final trueEndDate = picked.add(Duration(
          days: widget.staff.gender == 'Male'
              ? utilDetails!["LvRemain"]
                  : null));
      setState(() {
        startDate = picked;
        endDate = trueEndDate;
        startDateError = null;
        resumptionDate = trueEndDate.weekday == DateTime.friday ? trueEndDate.add(Duration(days: 3)) : trueEndDate.weekday == DateTime.saturday ? trueEndDate.add(Duration(days: 2)) : trueEndDate.add(Duration(days: 1));
      });
    } else if ((picked != null &&
        picked != startDate &&
        picked.compareTo(DateTime.now()) < 0)
        ||
        (picked != null && picked.day == DateTime.now().day)
        
        ) {
      setState(() {
        startDateError = 'Only enter future dates';
      });
    } else if (picked != null &&
        picked != startDate &&
        activeSetup?['hasWeekEnds'] == false &&
        (picked.weekday == DateTime.saturday ||
            picked.weekday == DateTime.sunday)) {
      setState(() {
        startDateError = 'Can only select weekdays';
      });
    }
  }

  Future<void> _selectResumptiontDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
       builder: (BuildContext context, Widget? child) {
      return Theme(
        data: ThemeData(
          colorScheme: const ColorScheme.light(
              primary: Color(0xff15B77C),
              ),
              dialogBackgroundColor: Colors.white,
        ),
        child: child ?? const Text(""),
      );
    },
        context: context,
        initialDate: resumptionDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null &&
        picked != resumptionDate &&
        picked.compareTo(DateTime.now()) > 0 &&
        picked.weekday != DateTime.saturday &&
        picked.weekday != DateTime.sunday) {
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
    } else if (picked != null &&
        picked != resumptionDate &&
        activeSetup?['hasWeekEnds'] == false &&
        (picked.weekday == DateTime.saturday ||
            picked.weekday == DateTime.sunday)) {
      setState(() {
        resumptionDateError = 'Can only select weekdays';
      });
    }
  }

  Future<void> _selectEndDate(BuildContext context) async {
    DateTime start = DateTime.parse(startDate.toString());
    DateTime end = DateTime.parse(endDate.toString());
    var differenceInDays = end.difference(start).inDays;

    final DateTime? picked = await showDatePicker(
       builder: (BuildContext context, Widget? child) {
      return Theme(
        data: ThemeData(
          colorScheme: const ColorScheme.light(
              primary: Color(0xff15B77C),
              ),
              dialogBackgroundColor: Colors.white,
        ),
        child: child ?? const Text(""),
      );
    },
        context: context,
        initialDate: endDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null &&
            picked != endDate &&
            picked.compareTo(DateTime.now()) > 0 &&
            picked.weekday != DateTime.saturday &&
            picked.weekday != DateTime.sunday
        // (widget.staff.gender == 'Male' && differenceInDays <= activeSetup?["LvMaxDuration_Male"] || widget.staff.gender == 'Female' && differenceInDays <= activeSetup?["LvMaxDuration_Female"])
        ) {
      setState(() {
        endDate = picked;
        resumptionDate = picked.weekday == DateTime.friday ? picked.add(Duration(days: 3)) : picked.weekday == DateTime.saturday ? picked.add(Duration(days: 2)) : picked.add(Duration(days: 1));
        endDateError = null;
      });
    } else if ((picked != null &&
        picked != endDate &&
        picked.compareTo(DateTime.now()) < 0)
        ) {
      setState(() {
        endDateError = 'Only enter future dates';
      });
    } else if (picked != null &&
        picked != endDate &&
        activeSetup?['hasWeekEnds'] == false &&
        (picked.weekday == DateTime.saturday ||
            picked.weekday == DateTime.sunday)) {
      setState(() {
        endDateError = 'Can only select weekdays';
      });
    }
    // if(startDate.toString().split(" ")[0] == DateTime.now().toString().split(" ")[0]) {
    //   setState(() {
    //     startDateError = 'Only enter future dates';
    //   });
    // }
    // else if (picked != null &&
    //     picked != endDate
    //     // (widget.staff.gender == 'Male' && differenceInDays > activeSetup?["LvMaxDuration_Male"] || widget.staff.gender == 'Female' && differenceInDays > activeSetup?["LvMaxDuration_Female"])
    //     ) {
    //   setState(() {
    //     endDateError = 'eror';
    //     // endDateError = widget.staff.gender == "Female" ? 'You are entitled to a maximum of ${activeSetup?["LvMaxDuration_Female"]}' : widget.staff.gender == "Male" ? 'You are entitled to a maximum of ${activeSetup?["LvMaxDuration_Male"]}' : null;
    //   });
    // }
    // print(activeSetup?["LvMaxDuration_Male"]);
    // print(differenceInDays);
    // print(startDate);
  }

  void createLeave() async {
    DateTime start = DateTime.parse(startDate.toString());
    DateTime end = DateTime.parse(endDate.toString());
    final differenceInDays = end.difference(start).inDays;

    Uri url = Uri.parse('http://10.0.0.184:8015/requisition/createleave');

    var token = jsonEncode({
      'tk': widget.auth?.token,
      'us': widget.staff.userRef,
      'rl': widget.staff.uRole,
      'src': "AS-IN-D659B-e3M"
    });
    var headers = {
      'x-lapo-eve-proc': base64ToHex(encryption(token, widget.auth?.aesKey ?? '', widget.auth?.iv ?? '')) + (widget.auth?.token ?? ''),
      'Content-type': 'text/json',
    };
    var body = jsonEncode({
      "xLeaveType": leaveType.toString(),
      "xSelf": onBehalf == false ? 0 : 1,
      "xOnBehalf": onBehalf == false ? 0 : 1,
      "xLeaveOrigin": widget.staff.userRef.toString(),
      "xLeaveOwner": onBehalf == false
          ? widget.staff.userRef.toString()
          : selectedBeneficiary?['ItemCode'],
      "xLTG": payLtg == false ? "0" : "1",
      "xBhalfReason": reasonValue,
      "xDepOfficer": depOfficer,
      "xStart_Date": startDate.toString(),
      "xEnd_Date": endDate.toString(),
      "xRsm_Date": resumptionDate.toString(),
      "xYear": DateTime.now().year.toString(),
      "xHasDoc": "0",
      "xDuration": differenceInDays < 2 ? (differenceInDays + 1).toString() : differenceInDays.toString(),
      "xisJustifiable": 0,
      "xJustify": justificationController.text,
      "xMobile": _mobileController.text.toString(),
      "xEmail": _emailController.text.toString(),
      "xAddress": _addressController.text.toString(),
      "xTrans": {
        "xTransRef": "",
        "xTransScope": "129dekekddkffmf2sv25",
        "xAppTransScope": "9e9efefech009eee",
        "xAppSource": "AS-IN-D659B-e3M"
      }
    });
    var response =
        await http.post(url, headers: headers, body: base64ToHex(encryption(body, widget.auth?.aesKey ?? '', widget.auth?.iv ?? '')));
    print(response.body);
    var data = jsonDecode(response.body);
    
    return _showMyDialog(data);

    // else {
    //   var xdata = decryption(base64.encode(hex.decode(jsonDecode(response.body))), widget.auth?.aesKey ?? '', widget.auth?.iv ?? '');
    //   return _showMyDialog(xdata);
    // }

    // if (response.statusCode == 200) {
    //   var xdata = decryption(base64.encode(hex.decode(jsonDecode(response.body))), widget.auth?.aesKey ?? '', widget.auth?.iv ?? '');
    //   print(xdata);
    //   // _showMyDialog(xdata);
    // }
  }

  validateField(String value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a username';
    }
    return null;
  }

  validateJustification(String value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a justification for the leave';
    }
    return null;
  }

  validateBeneficiary(String value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a beneficiary';
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

  static final _formKey = GlobalKey<FormState>(debugLabel: '');

  @override
  void initState() {
    super.initState();
    getLeaveTypes();
    // getLineManager();
    getLeaveSetup();
    getDivision();
    getUtlzDetails(leaveType);
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

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top:Radius.circular(60))
          ),
      child: ListView(children: [
        Container(
          margin: const EdgeInsets.only(top: 5, bottom: 20, left: 20),
          child: const Text(
            'Requisition Details',
            style: TextStyle(color: Color(0xff88A59A)),
          ),
        ),

        // const Padding(
        //   padding: EdgeInsets.only(left: 10, right: 20),
        //   child: Text('Who is this Requisition for',
        //       style: TextStyle(
        //           color: Color(0xff88A59A), fontWeight: FontWeight.bold)),
        // ),
        // Container(
        //     padding: const EdgeInsets.only(left: 40, right: 40),
        //     width: 200,
        //     child: Row(
        //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //       children: [
        //         const Text('Self'),
        //         SizedBox(
        //           width: 90,
        //           height: 70,
        //           child: FittedBox(
        //             fit: BoxFit.fill,
        //             child: Switch(
        //               value: onBehalf,
        //               onChanged: (bool value) {
        //                 setState(() {
        //                   onBehalf = value;
        //                 });
        //               },
        //               activeColor: const Color(0xff15B77C),
        //               activeTrackColor: const Color(0xffD6EBE3),
        //               inactiveThumbColor: const Color(0xffD6EBE3),
        //               inactiveTrackColor: const Color(0xffD9D9D9),
        //             ),
        //           ),
        //         ),
        //         const Text('On Behalf Of Another', style: TextStyle(overflow: TextOverflow.ellipsis))
        //       ],
        //     )),
        Container(
          child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 270,
                    color: const Color(0xffD6EBE3),
                    child: Container(
                        margin: const EdgeInsets.only(
                            top: 40, left: 20, bottom: 20, right: 20),
                        width: 100,
                        height: 40,
                        child: Column(
                          children: [
                            DropdownButtonFormField(
                              decoration: const InputDecoration(
                                fillColor: Colors.white,
                                filled: true,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
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
                                    ?.where(
                                        (element) => element['Item'] == item)
                                    .single['Code']
                                    .toString();
                                var _setup = Map<dynamic, dynamic>.from(setups
                                    ?.toList()
                                    .where((elem) =>
                                        elem["lv_type_Id"].toString() == ref)
                                    .single);
                                getUtlzDetails(ref as String);
                                // var error = _setup["isMaleValid"] != true && widget.staff.gender == 'Male' ? 'You are not eligible for this leave type' : '';
                                // : _setup["isFemaleValid"] == true && widget.staff.gender != 'Female' ? 'You are not eligible for this leave type' : '';
                                setState(() {
                                  leaveType = ref as String;
                                  activeSetup = _setup;
                                  startDateError = null;
                                  endDateError = null;
                                  resumptionDateError = null;
                                  startDate = DateTime.now();
                                  endDate = DateTime.now();
                                  resumptionDate = DateTime.now();
                                  payLtg = false;
                                  ltgError = null;
                                });
                              },
                            ),
                            Container(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  leaveTypeError ?? '',
                                  style: const TextStyle(color: Colors.red),
                                )),
                            Utilization(data: utilDetails)
                          ],
                        )),
                  ),
                  Container(
                      margin: onBehalf == true
                          ? const EdgeInsets.only(top: 30)
                          : null,
                      padding: const EdgeInsets.only(left: 10, right: 20),
                      child: onBehalf == true
                          ? Column(
                              children: [
                                TypeAheadFormField(
                                  textFieldConfiguration:
                                      TextFieldConfiguration(

                                          autofocus: false,
                                          style: DefaultTextStyle.of(context)
                                              .style
                                              .copyWith(
                                                  fontStyle: FontStyle.italic,
                                                  height: 1.5,
                                                  fontSize: 14),
                                          controller: beneficiaryController,
                                          cursorColor: Colors.black,
                                          decoration: const InputDecoration(
                                            labelText: 'Who is this requisition for?',
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
                                    // print(data);
                                    return Container(
                                      height: 60,
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
                                    beneficiaryController.value =
                                        TextEditingValue(
                                      text: data['ItemName'],
                                      selection: TextSelection.fromPosition(
                                        TextPosition(
                                            offset: data['ItemName'].length),
                                      ),
                                    );
                                    setState(() {
                                      selectedBeneficiary = suggestion;
                                    });
                                  },
                                ),
                                Container(
                                  child: Column(children: [
                                    Container(
                                      margin: const EdgeInsets.only(
                                          top: 10, bottom: 20),
                                      child: const Text(
                                        'You can search by Employee name or Employee number.',
                                      ),
                                    ),
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      child: const Text('Reason',
                                          style: TextStyle(
                                              color: Color(0xff88A59A),
                                              fontWeight: FontWeight.bold)),
                                    ),
                                    Container(
                                      child: Column(children: [
                                        RadioListTile(
                                          value: 1,
                                          activeColor: const Color(0xff15B77C),
                                          groupValue: reason,
                                          title: const Text('Sick'),
                                          onChanged: ((value) {
                                            setState(() {
                                              reason = value!;
                                              reasonValue = '10';
                                            });
                                          }),
                                        ),
                                        RadioListTile(
                                          value: 2,
                                          activeColor: const Color(0xff15B77C),
                                          groupValue: reason,
                                          title: const Text('Mandated'),
                                          onChanged: ((value) {
                                            setState(() {
                                              reason = value!;
                                              reasonValue = '11';
                                            });
                                          }),
                                        )
                                      ]),
                                    )
                                  ]),
                                )
                              ],
                            )
                          : null),
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
                                        if (activeSetup?["hasLTG"]) {
                                          setState(() {
                                            payLtg = !payLtg;
                                          });
                                        } else {
                                          setState(() {
                                            ltgError =
                                                'You are not entitled to LTG for this leave type';
                                          });
                                        }
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
                          child: ltgError != null
                              ? Text(
                                  ltgError ?? '',
                                  style: const TextStyle(color: Colors.red),
                                )
                              : null,
                        ),
                        Container(
                          margin: const EdgeInsets.only(bottom: 10, top: 10),
                          child: const Divider(
                              color: Color(0xffD6EBE3),
                              height: 1,
                              thickness: 2),
                        ),
                        Container(
                          height: 80,
                          margin: const EdgeInsets.only(top: 10, bottom: 10),
                          width: MediaQuery.of(context).size.width,
                          child: TypeAheadFormField(
                            textFieldConfiguration: TextFieldConfiguration(
                                autofocus: false,
                                style: DefaultTextStyle.of(context)
                                    .style
                                    .copyWith(
                                        fontStyle: FontStyle.italic,
                                        height: 1.5,
                                        fontSize: 14),
                                controller: searchController,
                                cursorColor: Colors.black,
                                decoration: const InputDecoration(
                                  labelText: 'Select a Deputizing Officer',
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(data['ItemName']),
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
                                            )),
                                            Text(
                                              data['Bu'],
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        ),
                                      )
                                    ]),
                              );
                            },
                            validator: ((value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a deputizing officer';
                              }
                              return null;
                            }),
                            onSuggestionSelected: (suggestion) {
                              var data = suggestion as Map<dynamic, dynamic>;
                              searchController.value = TextEditingValue(
                                text: data['ItemName'],
                                selection: TextSelection.fromPosition(
                                  TextPosition(offset: data['ItemName'].length),
                                ),
                              );
                              setState(() {
                                depOfficer = data['ItemCode'];
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
                                                      color: Color(0xff15B77C),
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
                                                      color: Color(0xff15B77C),
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
                                          color: Color(0xff15B77C),
                                        ),
                                        title: Text(
                                            DateTime.parse(
                                                    resumptionDate.toString())
                                                .toString()
                                                .split(" ")[0],
                                            style:
                                                const TextStyle(fontSize: 14)),
                                        // onTap: () =>
                                        //     _selectResumptiontDate(context),
                                      ),
                                    )),
                                resumptionDateError != null
                                    ? Text(
                                        resumptionDateError ?? '',
                                        style: TextStyle(
                                            color: Colors.red, fontSize: 11),
                                      )
                                    : Text('Resumption Date')
                              ],
                            )),
                        Container(
                            margin: onBehalf == true || leaveType == "300" || leaveType == "500" || leaveType == "600" || leaveType == "900"
                                ? const EdgeInsets.only(top: 20)
                                : null,
                            child: onBehalf == true || leaveType == "300" || leaveType == "500" || leaveType == "600" || leaveType == "900"
                                ? CustomInputField(
                                    controller: justificationController,
                                    hintText: 'Leave Justification',
                                    minLines: 2,
                                    maxLines: 5,
                                    validation: validateJustification,
                                  )
                                : null),
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
                                      color: Color(0xff15B77C)),
                                  textType: TextInputType.number,
                                ),
                                CustomInput(
                                  controller: _emailController,
                                  validation: validateEmail,
                                  hintText: 'Email during leave',
                                  prefixIcon: const Icon(Icons.email,
                                      color: Color(0xff15B77C)),
                                  textType: TextInputType.emailAddress,
                                ),
                                CustomInput(
                                  controller: _addressController,
                                  validation: validateAddress,
                                  hintText: 'Address during leave',
                                  prefixIcon: const Icon(Icons.home,
                                      color: Color(0xff15B77C)),
                                  textType: TextInputType.text,
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
                              fontSize: 16, fontWeight: FontWeight.bold),
                        )
                      : const CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 5,
                        )),
            ))
      ]),
    ),
    );
  }
}
