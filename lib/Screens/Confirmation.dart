import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:e_360/Models/Staff.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:e_360/Widgets/input.dart';
import 'package:e_360/Models/DepOfficer.dart';
import 'package:e_360/Models/Transaction.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:convert/convert.dart';
import 'package:e_360/helpers/contract.dart';
import 'package:e_360/helpers/aes.dart';
import 'package:e_360/Screens/Management.dart';

class Confirmation extends HookConsumerWidget {
  Staff staff;
  String ref;
  Transaction trans;
  String type;
  Map<dynamic, dynamic> info;
  Confirmation(
      {super.key,
      required this.staff,
      required this.ref,
      required this.trans,
      required this.type,
      required this.info});

  @override
  Widget build(BuildContext context, WidgetRef _ref) {
    final auth = _ref.watch(authProvider);
    final screen = _ref.watch(screenProvider);

    final leave = useState<Map<dynamic, dynamic>?>(null);
    final lineManager = useState<Map<dynamic, dynamic>?>(null);

    void retrieveLeave(String ref) async {
      Uri url = Uri.parse('https://e360.lapo-nigeria.org/requisition/retrieveleave');

      var token = jsonEncode({
        'tk': auth.token,
        'us': staff.userRef,
        'rl': staff.uRole,
        'src': "AS-IN-D659B-e3M"
      });
      var headers = {
        'x-lapo-eve-proc':
            base64ToHex(encryption(token, auth.aesKey ?? '', auth.iv ?? '')) +
                (auth.token ?? ''),
        'Content-type': 'text/json',
      };
      var body = jsonEncode({
        "xTransRef": ref,
        "xTransScope": "129dekekddkffmf2sv25",
        "xAppTransScope": "9e9efefech009eee",
        "xAppSource": "AS-IN-D659B-e3M"
      });
      final xpayload =
          base64ToHex(encryption(body, auth.aesKey ?? '', auth.iv ?? ''));

      var result = await http.post(url, headers: headers, body: xpayload);

      if (result.statusCode == 200) {
        var data = jsonDecode(result.body)["data"];
        if (data != null) {
          var xData = decryption(base64.encode(hex.decode(data)),
              auth.aesKey ?? '', auth.iv ?? '');
          var leaveDetails = Map<dynamic, dynamic>.from(jsonDecode(xData));
          leave.value = leaveDetails;
        }
      }
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
            // title: Text('Unsuccessful'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  // Text('Invalid details'),
                  Text(data['message'])
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

    void getLineManager() async {
      Uri url = Uri.parse('https://e360.lapo-nigeria.org/userservices/mylinemanager');
      var token = jsonEncode({
        'tk': auth.token,
        'us': staff.userRef,
        'rl': staff.uRole,
        'src': "AS-IN-D659B-e3M"
      });
      var headers = {
        'x-lapo-eve-proc':
            base64ToHex(encryption(token, auth.aesKey ?? '', auth.iv ?? '')) +
                (auth.token ?? ''),
        'Content-type': 'text/json',
      };
      var result = await http.get(url, headers: headers);

      if (result.statusCode == 200) {
        var data = jsonDecode(result.body)["data"];
        var xData = decryption(base64.encode(hex.decode(jsonDecode(data))),
            auth.aesKey ?? '', auth.iv ?? '')[0];
        var lineManagerData = Map<dynamic, dynamic>.from(jsonDecode(xData));
        lineManager.value = lineManagerData;
      }
    }

    void createLeave(String operation) async {
      Uri url = Uri.parse('https://e360.lapo-nigeria.org/requisition/createleave');
      var token = jsonEncode({
        'tk': auth.token,
        'us': staff.userRef,
        'rl': staff.uRole,
        'src': "AS-IN-D659B-e3M"
      });
      var headers = {
        'x-lapo-eve-proc':
            base64ToHex(encryption(token, auth.aesKey ?? '', auth.iv ?? '')) +
                (auth.token ?? ''),
        'Content-type': 'text/json',
      };
      var body = jsonEncode({
        "xLeaveType": leave.value?["lv_type_Id"].toString(),
        "xSelf": leave.value?["isSelf"] == true ? 0 : 1,
        "xOnBehalf": leave.value?["isOnbehalf"] == true ? 1 : 0,
        "xLeaveOrigin": staff.userRef.toString(),
        "xLeaveOwner": leave.value?["Leave_InitiatedBy_User_Ref"],
        "xLTG": leave.value?["PayLTG"] == true ? "1" : "0",
        "xBhalfReason": leave.value?["Bhalf_Req_Reasn_Id"].toString(),
        "xDepOfficer": leave.value?["Deputizing_Officer"],
        "xStart_Date": leave.value?["Lv_Start_Date"],
        "xEnd_Date": leave.value?["Lv_End_Date"],
        "xRsm_Date": leave.value?["Lv_Rsm_Date"],
        "xYear": leave.value?["Lv_Year"],
        "xHasDoc": leave.value?["hasDoc"] == true ? "1" : "0",
        "xDuration": leave.value?["Lv_Duration"].toString(),
        "xisJustifiable": leave.value?["isJustifiable"] == true ? 1 : 0,
        "xJustify": leave.value?["Lv_Justify"],
        "xMobile": leave.value?["Lv_Mobile"],
        "xEmail": leave.value?["Lv_Email"],
        "xAddress": leave.value?["Lv_Address"],
        "xTrans": {
          "xTransRef": ref,
          "xTransScope": operation == 'authorize'
              ? "246646upkjhfkwhjfj77"
              : operation == 'decline'
                  ? "246646upkjhfkwhjfj77"
                  : "",
          "xAppTransScope": operation == 'authorize'
              ? "2efefept9e000001"
              : operation == 'decline'
                  ? "00000009e0000000"
                  : "",
          "xAppSource": "AS-IN-D659B-e3M"
        }
      });

      final xpayload =
          base64ToHex(encryption(body, auth.aesKey ?? '', auth.iv ?? ''));

      var response = await http.post(url, headers: headers, body: xpayload);
      var data = jsonDecode(response.body);
      _showMyDialog(jsonDecode(data));
      // if (response.statusCode == 200) {
      //   var data = jsonDecode(response.body);
      // var xData = decryption(base64.encode(hex.decode(jsonDecode(data))), auth.aesKey ?? '', auth.iv ?? '');
      // _showMyDialog(jsonDecode(xData));
      // }
    }

    useEffect(() {
      retrieveLeave(ref);

      return null;
    }, [ref]);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Container(
        child: Column(children: [
          Container(
            height: 350,
            padding: const EdgeInsets.all(10),
            color: Colors.grey[200],
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Transaction Type',
                        style: TextStyle(),
                      ),
                      Container(
                        child: leave.value?["LeaveName"] != null ? Text(leave.value?["LeaveName"]) : trans.itemName =='poastappraisalevaluation' ? const Text('Self Appraisal') : null,
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Initiated By',
                        style: TextStyle(),
                      ),
                      Text(
                        trans.createdBy.toString(),
                        style: const TextStyle(),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Description',
                        style: TextStyle(),
                      ),
                      Text(
                        trans.titleDesc.toString(),
                        style: const TextStyle(),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Originating Bu',
                        style: TextStyle(),
                      ),
                      Text(
                        trans.buName.toString(),
                        style: const TextStyle(),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Time Stamp',
                        style: TextStyle(),
                      ),
                      Text(
                        trans.timeStamp.toString(),
                        style: const TextStyle(),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Approval Stage',
                        style: TextStyle(),
                      ),
                      Text(
                        trans.xStageNo.toString(),
                        style: const TextStyle(),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Stage Status',
                        style: TextStyle(),
                      ),
                      Text(
                        trans.xStageStatus.toString(),
                        style: const TextStyle(),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Record State',
                        style: TextStyle(),
                      ),
                      Text(
                        trans.xRecordState.toString(),
                        style: const TextStyle(),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Transaction Status',
                        style: TextStyle(),
                      ),
                      Text(
                        trans.xTransStatus.toString(),
                        style: const TextStyle(),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Assigned To',
                        style: TextStyle(),
                      ),
                      Text(
                        trans.xAssignTo.toString(),
                        style: const TextStyle(),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Reviewed By',
                        style: TextStyle(),
                      ),
                      Text(
                        trans.tReviewer.toString(),
                        style: const TextStyle(),
                      )
                    ],
                  )
                ]),
          ),

          // Container(
          //   padding: const EdgeInsets.only(top: 30, left: 20, right: 20),
          //   child: leave.value?["Deputizing_Officer"] == staff.userRef || (staff.userRef == lineManager.value?["ItemCode"] && trans.xStageNo.toString() == "2") ? Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   children: [
          //     ElevatedButton(onPressed: (){
          //       createLeave('authorize');
          //     }, child: Text('Approve'), style: ElevatedButton.styleFrom(backgroundColor: const Color(0xff15B77C)),),

          //     ElevatedButton(onPressed: (){
          //       createLeave('decline');
          //     }, child: Text('Decline'), style: ElevatedButton.styleFrom(backgroundColor: const Color(0xff15B77C)),)
          //   ],
          // ) : null,
          // )

          Container(
              padding: const EdgeInsets.only(top: 30, left: 20, right: 20),
              child: type == 'createleave' &&
                      staff.userRef != trans.xAppOriginRef
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            createLeave('authorize');
                          },
                          child: Text('Approve'),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xff15B77C)),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            createLeave('decline');
                          },
                          child: Text('Decline'),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xff15B77C)),
                        )
                      ],
                    )
                  : 
                  type == 'poastappraisalevaluation' &&
                          staff.userRef != trans.xAppOriginRef
                   ? 
                      ElevatedButton(
                          onPressed: () {
                            _ref.read(screenProvider.notifier).state = Screen(screen: 'manage');
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (contect) => Management(
                                    staff: staff,
                                    info: info,
                                    appraiser: 'Supervisor',
                                    appraiserRef: trans.xAppOriginRef as String,
                                    trans: trans,
                                  ),
                                ));
                          },
                          child: Text('Appraise'),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xff15B77C)),
                        ) : null
                      )
        ]),
      ),
    );
  }
}
