import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:e_360/Models/Staff.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:e_360/Widgets/input.dart';
import 'package:e_360/Models/DepOfficer.dart';
import 'package:e_360/Screens/SettingsItem.dart';

class Settings extends HookWidget {
  Staff staff;
  Map<String, dynamic> info;
  Settings({super.key, required this.staff, required this.info});

  @override 
  Widget build(BuildContext context) {

    final currentItem = useState<String>('');

    return Container(
      margin: const EdgeInsets.only(top: 30),
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: ListView(children: [
          Container(
            alignment: Alignment.centerLeft,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
              ElevatedButton(child: Text('Update Email', style: TextStyle(color: Colors.black),), onPressed: () {
                currentItem.value = '100';
            }, style: ElevatedButton.styleFrom(backgroundColor: const Color(0xffD6EBE3)),),

            ElevatedButton(child: Text('Update Phone Number', style: TextStyle(color: Colors.black),), onPressed: () {
              currentItem.value = '200';
            }, style: ElevatedButton.styleFrom(backgroundColor: const Color(0xffD6EBE3)),),
            ],)
          ),

          Container(
            margin: const EdgeInsets.only(top: 20),
            alignment: Alignment.centerLeft,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
              ElevatedButton(child: Text('Update Password', style: TextStyle(color: Colors.black),), onPressed: () {
                currentItem.value = '300';
            }, style: ElevatedButton.styleFrom(backgroundColor: const Color(0xffD6EBE3)),),

            ElevatedButton(child: Text('Update Profile Photo', style: TextStyle(color: Colors.black),), onPressed: () {
            }, style: ElevatedButton.styleFrom(backgroundColor: const Color(0xffD6EBE3)),),
            ],)
          ),

          SettingsItem(staff: staff, info: info, currentItem: currentItem.value)
      ]),
    );
  }
}