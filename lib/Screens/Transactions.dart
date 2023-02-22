import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:e_360/Models/Staff.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:e_360/Widgets/input.dart';
import 'package:e_360/Models/DepOfficer.dart';
import 'package:e_360/Models/Transaction.dart';
import 'package:e_360/Screens/Confirmation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:convert/convert.dart';
import 'package:e_360/helpers/contract.dart';
import 'package:e_360/helpers/aes.dart';

class Transactions extends StatefulWidget {
  final Staff staff;
  final Map<dynamic, dynamic> info;
  final Auth auth;
  const Transactions(
      {super.key, required this.staff, required this.info, required this.auth});

  @override
  State<Transactions> createState() => TransactionState();
}

class TransactionState extends State<Transactions> {
  List<Transaction>? transactions;

  bool loading = false;

  Future<void> getTransactions() async {
    setState(() {
      loading = true;
    });
    Uri url = Uri.parse('http://10.0.0.184:8015/userservices/listtransactions');
    var token = jsonEncode({
      'tk': widget.auth.token,
      'us': widget.staff.userRef,
      'rl': widget.staff.uRole,
      'src': "AS-IN-D659B-e3M"
    });
    var headers = {
      'x-lapo-eve-proc': base64ToHex(
          encryption(token, widget.auth.aesKey ?? '', widget.auth.iv ?? ''))+ (widget.auth.token ?? ''),
      'Content-type': 'text/json',
    };
    var body = jsonEncode({
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
    });

    final xpayload = base64ToHex(
        encryption(body, widget.auth.aesKey ?? '', widget.auth.iv ?? ''));

    var response = await http.post(url, headers: headers, body: xpayload);
    if (response.statusCode == 200) {
      var xData = decryption(
          base64.encode(hex.decode(jsonDecode(response.body)['data'])),
          widget.auth.aesKey ?? '',
          widget.auth.iv ?? '');
      setState(() {
        loading = false;
      });
      final data = List.from(jsonDecode(xData));
      final dataList = data
          .map(
            (e) => Transaction.fromJson(e),
          )
          .toList();
      setState(() {
        transactions = dataList;
      });
    }
  }

  Future<Map<dynamic, dynamic>> retrieveLeave(String ref) async {
    Uri url = Uri.parse('http://10.0.0.184:8015/requisition/retrieveleave');
    var token = jsonEncode({
      'tk': widget.auth.token,
      'us': widget.staff.userRef,
      'rl': widget.staff.uRole,
      'src': "AS-IN-D659B-e3M"
    });
    var headers = {
      'x-lapo-eve-proc': base64ToHex(
          encryption(token, widget.auth.aesKey ?? '', widget.auth.iv ?? ''))+ (widget.auth.token ?? ''),
      'Content-type': 'text/json',
    };
    var body = jsonEncode({
      "xTransRef": ref,
      "xTransScope": "129dekekddkffmf2sv25",
      "xAppTransScope": "9e9efefech009eee",
      "xAppSource": "AS-IN-D659B-e3M"
    });

    final xpayload = base64ToHex(
        encryption(body, widget.auth.aesKey ?? '', widget.auth.iv ?? ''));

    var result = await http.post(url, headers: headers, body: xpayload);

    if (result.statusCode == 200) {
      var data = jsonDecode(result.body)["data"][0];
      var xData = decryption(base64.encode(hex.decode(jsonDecode(data))),
          widget.auth.aesKey ?? '', widget.auth.iv ?? '')[0];
      var leaveDetails = Map<dynamic, dynamic>.from(jsonDecode(xData));

      return leaveDetails;
    }
    return {};
  }

  void initState() {
    super.initState();
    getTransactions();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
          padding: const EdgeInsets.only(top: 30),
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(60))),
          height: MediaQuery.of(context).size.height,
          child: transactions != null
              ? Container(
                  child: ExpansionPanelList(
                    expansionCallback: (int index, bool isExpanded) {
                      setState(() {
                        transactions?[index].isExpanded = !isExpanded;
                      });
                    },
                    children: transactions!.map((Transaction trans) {
                      return ExpansionPanel(
                          headerBuilder: ((context, isExpanded) {
                            return ListTile(
                                title: Text(
                                  trans.itemCode.toString(),
                                  style: const TextStyle(
                                      overflow: TextOverflow.ellipsis),
                                ),
                                leading: Text(trans.itemName.toString()),
                                trailing: trans.xTransStatus == 'Pending'
                                    ? const Icon(
                                        Icons.pending,
                                        color: Color(0xff15B77C),
                                      )
                                    : const Icon(
                                        Icons.check_circle,
                                        color: Color(0xff15B77C),
                                      ));
                          }),
                          body: Container(
                            height: 250,
                            padding: const EdgeInsets.all(10),
                            color: Colors.grey[200],
                            child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        'Initiated By',
                                        style: TextStyle(),
                                      ),
                                      Text(
                                        trans.fullName.toString(),
                                        style: const TextStyle(),
                                      )
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
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
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(top: 20),
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              const Color(0xff15B77C)),
                                      child: const Text('View'),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  Confirmation(
                                                      staff: widget.staff,
                                                      ref: trans.itemCode
                                                          .toString(),
                                                      trans: trans)),
                                        );
                                      },
                                    ),
                                  )
                                ]),
                          ),
                          isExpanded: trans.isExpanded as bool);
                    }).toList(),
                  ),
                )
              : Center(
                  child: const CircularProgressIndicator(
                    color: Color(0xff15B77C),
                    strokeWidth: 5,
                  ),
                )),
    );
  }
}
