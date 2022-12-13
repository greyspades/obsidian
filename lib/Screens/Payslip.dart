import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:e_360/Models/Staff.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:e_360/Widgets/input.dart';
import 'package:e_360/Models/DepOfficer.dart';

List<Map<String, dynamic>> earnings = [
  {
    'name': 'Basic Pay',
    'value': '49,601.80',
    'ydt': '127,311.28'
  },
  {
    'name': 'Housing',
    'value': '17,601.80',
    'ydt': '44,311.28'
  },
  {
    'name': 'Meal',
    'value': '17,601.80',
    'ydt': '44,311.28'
  },
  {
    'name': 'Transport',
    'value': '14,880.80',
    'ydt': '36,193.28'
  },
  {
    'name': 'Utility',
    'value': '12,569.80',
    'ydt': '32,262.28'
  }
];

List<Map<String, dynamic>> deductions = [
  {
    'name': 'Pension',
    'value': '6,547.43',
    'ydt': '16,805.07'
  },
  {
    'name': 'Tax',
    'value': '5,997.88',
    'ydt': '12,875.32'
  },
];


class Payslip extends HookWidget {

  Staff staff;
  Map<String, dynamic> info;
  Payslip({super.key, required this.staff, required this.info});

  @override 
  Widget build(BuildContext context) {

    List<Widget> listInfo(List<Map<String, dynamic>> data) {
      return data
          .map<Widget>((Map<String, dynamic> data) => Column(children: [
            Row(
              // decoration: const BoxDecoration(border: Border(
              //   right: BorderSide(color: Colors.white, width: 0),
              //   left: BorderSide(color: Colors.white, width: 0)
              //   )),
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                      Container(
                        margin: EdgeInsets.only(top: 15),
                    child: Text(data['name']),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 15),
                    child: Text(data['value'] != null ? data['value'] : "null"),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 15),
                    child: Text(data['ydt'] != null ? data['ydt'] : "null"),
                  )
                ],
              ),
              const Divider(color: Color(0xff55BE88),thickness: 3,)
          ],)
              )
          .toList();
    }

    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, top: 20),
      child: Container(
        // height: 300,
        // color: Colors.red,
        child: ListView(children: [
        Container(
          height: 80,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
            Row(children: [
              const Text('Name:',style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),),
              const Text(' '),
              Row(children: [Text(staff.firstName  ?? '',style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),),const Text(' '), Text(staff.lastName ?? '',style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),)],)
            ],),

            Row(children: [
              const Text('Dept/Group:',style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),),
              const Text(' '),
              Text(staff.buName ?? '',style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),)
            ],),

            Row(children: [
              const Text('Employee No:',style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),),
              const Text(' '),
              Text(staff.employeeNo ?? '',style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),)
            ],),
            Row(children: [
              const Text('Designation:',style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),),
              const Text(' '),
              Text(info['JobTitle'] ,style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),)
            ],)
          ]),
        ),
        Container(
          margin: const EdgeInsets.only(bottom: 20, top: 20),
          alignment: Alignment.centerLeft,
          child: const Text('Earnings', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xff55BE88)),),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
                                Container(
                    child: const Text('Item', style: TextStyle(fontWeight: FontWeight.bold),),
                  ),
                  Container(
                    child: const Text('Amount', style: TextStyle(fontWeight: FontWeight.bold),),
                  ),
                  Container(
                    child: const Text('YTD Amt', style: TextStyle(fontWeight: FontWeight.bold),),
                  ),
                  ],),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: listInfo(earnings),),
        Container(
          height: 40,
          // color: Colors.grey,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const[
            Text('Gross Pay', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 14),),
            Text('104,000.00', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 14),),
            Text('266,933.00', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 14),),
          ]),
        ),

         Container(
          margin: const EdgeInsets.only(bottom: 20, top: 20),
          alignment: Alignment.centerLeft,
          child: const Text('Deductions', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xff55BE88)),),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: listInfo(deductions),),
        Container(
          height: 40,
          // color: Colors.grey,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const[
            Text('Total Deductions', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 14),),
            Text('12,545.31', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 14),),
            Text('29,680.39', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 14),),
          ]),
        ),

        Container(
          height: 40,
          // color: Colors.grey,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const[
            Text('Net Pay', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 14),),
            Text('91,454.67', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 14),),
            Text('237,252.89', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 14),),
          ]),
        ),
        Container(
          margin: const EdgeInsets.only(bottom: 20, top: 20),
          alignment: Alignment.centerLeft,
          child: const Text('Reliefs', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xff55BE88)),),
        ),
        Container(
          margin: const EdgeInsets.only(bottom: 20),
          height: 50,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const[
              Text('Non-Taxable Allowances',style: TextStyle(fontWeight: FontWeight.bold),),
              Text('0.00')
            ],),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const[
              Text('Tax Relief',style: TextStyle(fontWeight: FontWeight.bold),),
              Text('44,019.09')
            ],)
          ]),
        )
      ],),)
    );
  }
}