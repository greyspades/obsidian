import 'package:e_360/Models/Transaction.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:e_360/Models/Staff.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:e_360/Widgets/input.dart';
import 'package:e_360/Models/DepOfficer.dart';
import 'package:e_360/Widgets/customSlider.dart';

class Summary extends HookWidget {

  Staff staff;
  int totalBC;
  int totalKpi;
  TextEditingController ad1;
  TextEditingController ad2;
  TextEditingController ad3;
  String appraiser;
  dynamic submit;
  Transaction? trans;
  List<Map>? selfDetails;
  
  Summary({super.key, this.trans, this.selfDetails, required this.staff, required this.totalBC, required this.totalKpi, required this.ad1, required this.ad2, required this.ad3, required this.appraiser, required this.submit});

  @override 

  Widget build(BuildContext context) {
    return ListView(children: [
              Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.only(bottom: 10),
                  child: const Text('Summary', style: TextStyle(color: Color(0xff15B77C), fontSize: 20, fontWeight: FontWeight.bold),),
                ),

              Container(
                margin: const EdgeInsets.only(top: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                  const Text('Full Name'),
                  Container(
                    margin: const EdgeInsets.only(top: 7),
                    padding: const EdgeInsets.all(10),
                    height: 40,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(color: Colors.grey[200], borderRadius: const BorderRadius.all(Radius.circular(8))),
                    child: trans == null ? Text('${staff.firstName.toString()} ${staff.lastName.toString()}', style: const TextStyle(fontWeight: FontWeight.bold),)
                    : Text(trans?.createdBy as String, style: const TextStyle(fontWeight: FontWeight.bold),)
                    ,
                  )
                ]),
              ),

              Container(
                margin: const EdgeInsets.only(top: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                  const Text('Maximum Points'),
                  Container(
                    margin: const EdgeInsets.only(top: 7),
                    padding: const EdgeInsets.all(10),
                    height: 40,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(color: Colors.grey[200], borderRadius: const BorderRadius.all(Radius.circular(8))),
                    child: const Text("100", style: TextStyle(fontWeight: FontWeight.bold),),
                  )
                ]),
              ),

              Container(
                margin: const EdgeInsets.only(top: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                  const Text('KPI Score'),
                  Container(
                    margin: const EdgeInsets.only(top: 7),
                    padding: const EdgeInsets.all(10),
                    height: 40,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(color: Colors.grey[200], borderRadius: const BorderRadius.all(Radius.circular(8))),
                    child: Text(totalKpi.toString(), style: const TextStyle(fontWeight: FontWeight.bold),),
                  )
                ]),
              ),

              Container(
                margin: const EdgeInsets.only(top: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                  const Text('Behavioural Competencies Score'),
                  Container(
                    margin: const EdgeInsets.only(top: 7),
                    padding: const EdgeInsets.all(10),
                    height: 40,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(color: Colors.grey[200], borderRadius: const BorderRadius.all(Radius.circular(8))),
                    child: Text(totalBC.toString(), style: const TextStyle(fontWeight: FontWeight.bold),),
                  )
                ]),
              ),

              Container(
                margin: const EdgeInsets.only(top: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                  const Text('Total Score/Points', style: TextStyle(fontWeight: FontWeight.bold)),
                  Container(
                    margin: const EdgeInsets.only(top: 7),
                    padding: const EdgeInsets.all(10),
                    height: 40,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(color: Colors.grey[200], borderRadius: const BorderRadius.all(Radius.circular(8))),
                    child: Text((totalBC + totalKpi).toString(), style: const TextStyle(fontWeight: FontWeight.bold),),
                  )
                ]),
              ),

              Container(
                margin: const EdgeInsets.only(top: 30),
                child: selfDetails != null ? const Text('Self Appraisal Summary', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),) : null
              ),
              

              Container(
                child: selfDetails != null ? Column(
                  children: selfDetails!.map<Widget>((e) {
                    return Container(
                      margin: const EdgeInsets.only(top: 10),
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 230, 226, 226),
                        borderRadius: BorderRadius.all(Radius.circular(8))
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                        Text('Item Name:' + ' ' + e['Apprsl_Item_Desc']),
                        Text('Item Type:' + ' ' + e['Apprsl_ItemType_Desc']),
                        Text('Item Score:' + ' ' + e['Apprsl_Score'].toString()),
                        Text('Justification:' + ' ' + e['Apprsl_Justification']),
                      ]),
                    );
                  }).toList(),
                ) : null,
              ),
  
              Container(
                margin: const EdgeInsets.only(top: 20),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 60,
                  child: ElevatedButton(child: Text('Submit'), onPressed: () {
                    submit();
                  }, style: ElevatedButton.styleFrom(backgroundColor: const Color(0xff15B77C))),
                ),
              )
            ],);
  }
}