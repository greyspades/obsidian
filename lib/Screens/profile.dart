import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:e_360/Models/Staff.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Profile extends HookWidget {
  final Staff staff;
  final Map<String, dynamic>? info;
  const Profile({super.key, required this.staff, this.info});
  
  @override
  Widget build(BuildContext context) {

    List<Map<String, dynamic>> userInfo = [
      {
        'title': 'Employee Number',
        'value': info?['Employee_No'] ?? 'null',
        'icon': Icons.numbers
      },
      {
        'title': 'Business Unit Name',
        'value': staff.buName,
        'icon': Icons.business
      },
      {
        'title': 'Gender',
        'value': info?['Gender'] ?? 'null',
        'icon': info?['Gender'] == 'Male' ? Icons.male : Icons.female
      },
      {
        'title': 'Rank',
        'value': info?['Rank'] ?? 'null',
        'icon': Icons.group
      },
      {
        'title': 'Hire Date',
        'value': info?['HireDate'] ?? 'null',
        'icon': Icons.event
      },
      {
        'title': 'Confirm Date',
        'value': info?['ConfirmDate'] ?? 'null',
        'icon': Icons.event_available,
      },
      {
        'title': 'Marital Status',
        'value': info?['maritalStatus'] ?? 'null',
        'icon': Icons.group
      },
      {
        'title': 'Email Address',
        'value': info?['Email'] ?? 'null',
        'icon': Icons.mail
      },
      {
        'title': 'Phone Number',
        'value': info?['Mobile'] ?? 'null',
        'icon': Icons.local_phone
      },
    ];

    List<Widget> listInfo() {
      return userInfo
          .map<Widget>((Map<String, dynamic> data) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 5, top: 20),
                    child: Text(data['title']),
                  ),
                  SizedBox(
                    // width: 330,
                    height: 71,
                    child: Card(
                      // color: Color(0xffD6EBE3),
                      color: Colors.grey[200],
                      child: Row(children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 5, right: 10),
                          child: Icon(data['icon'], color: const Color(0xff15B77C)),
                        ),
                        Text(data['value'] != null ? data['value'] : "null")
                      ]),
                    ),
                  )
                ],
              ))
          .toList();
    }

    return (
      Container(
        padding: const EdgeInsets.only(left: 10, right: 10),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top:Radius.circular(60))
          ),
            child: ListView(
              children: listInfo(),
            )
          )
    );
  }
}
