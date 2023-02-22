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
  ValueNotifier<String?> appraiser;
  
  Summary({super.key, required this.staff, required this.totalBC, required this.totalKpi, required this.ad1, required this.ad2, required this.ad3, required this.appraiser});

  @override 

  Widget build(BuildContext context) {
    return ListView(children: [
              Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.only(bottom: 10),
                  child: const Text('KPI', style: TextStyle(color: Color(0xff15B77C), fontSize: 20, fontWeight: FontWeight.bold),),
                ),
                
              Container(
                margin: const EdgeInsets.only(top: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                  const Text('Employee No'),
                  Container(
                    margin: const EdgeInsets.only(top: 7),
                    padding: const EdgeInsets.all(10),
                    height: 40,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(color: Colors.grey[200], borderRadius: const BorderRadius.all(Radius.circular(8))),
                    child: Text(staff.employeeNo.toString(), style: TextStyle(fontWeight: FontWeight.bold),),
                  )
                ]),
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
                    child: Text('${staff.firstName.toString()} ${staff.lastName.toString()}', style: const TextStyle(fontWeight: FontWeight.bold),),
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
                child: appraiser.value == "other" ? Column(children: [
                  Container(
                margin: const EdgeInsets.only(top: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                  const Text('1st Level Line Managers Comment', style: TextStyle(fontWeight: FontWeight.bold)),
                  Container(
                    margin: const EdgeInsets.only(top: 7),
                    height: 60,
                    width: MediaQuery.of(context).size.width,
                    child: CustomInput(controller: ad1),
                  )
                ]),
              ),
              Container(
                margin: const EdgeInsets.only(top: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                  const Text('HR/Personnel Dept. Comment', style: TextStyle(fontWeight: FontWeight.bold)),
                  Container(
                    margin: const EdgeInsets.only(top: 7),
                    height: 60,
                    width: MediaQuery.of(context).size.width,
                    child: CustomInput(controller: ad2),
                  )
                ]),
              ),

              Container(
                margin: const EdgeInsets.only(top: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                  const Text('Recommended Action', style: TextStyle(fontWeight: FontWeight.bold)),
                  Container(
                    margin: const EdgeInsets.only(top: 7),
                    height: 60,
                    width: MediaQuery.of(context).size.width,
                    child: CustomInput(controller: ad3),
                  )
                ]),
              ),

              SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 60,
                  child: ElevatedButton(child: Text('Submit'), onPressed: () {
                    
                  }, style: ElevatedButton.styleFrom(backgroundColor: const Color(0xff15B77C))),
                )
                ],) : null
              )
            ],);
  }
}