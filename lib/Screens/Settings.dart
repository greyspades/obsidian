import 'package:e_360/Screens/Downline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:e_360/Models/Staff.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:e_360/Widgets/input.dart';
import 'package:e_360/Models/DepOfficer.dart';
import 'package:e_360/Screens/SettingsItem.dart';
import 'package:e_360/Screens/login.dart';

class Settings extends HookWidget {
  Staff staff;
  Map<String, dynamic> info;
  Settings({super.key, required this.staff, required this.info});

  @override 
  Widget build(BuildContext context) {

    Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Are you sure you want to sign out?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Sign out'),
              onPressed: () {
                Navigator.push(context,
                MaterialPageRoute(builder: (context) => Login(title: '')));
              },
            ),
          ],
        );
      },
    );
  }

    return Container(
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top:Radius.circular(60))
          ),
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: ListView(children: [
          Container(
            alignment: Alignment.centerLeft,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                child: Row(
                children: [
                const Icon(Icons.lock, color: Color(0xff15B77C)),
                Container(
                  margin: const EdgeInsets.only(left: 10),
                  child: TextButton(onPressed: () {
                  Navigator.push(context,
                MaterialPageRoute(builder: (context) => SettingsItem(staff: staff, info: info, currentItem: '300'))
                );
                }, child: const Text('Update Password', style: TextStyle(color: Colors.black, fontSize: 16),),),
                )
              ],),),

              Container(
                child: Divider(color: Colors.grey[200], thickness: 2,)
              ),

            Container(
                child: Row(
                children: [
                const Icon(Icons.account_tree, color: Color(0xff15B77C)),
                Container(
                  margin: const EdgeInsets.only(left: 10),
                  child: TextButton(onPressed: () {
                  Navigator.push(context,
                MaterialPageRoute(builder: (context) => LineManager(staff: staff, info: info)));
                }, child: const Text('Set Downline', style: TextStyle(color: Colors.black, fontSize: 16),),),
                )
              ],),),

              Container(
                child: Divider(color: Colors.grey[200], thickness: 2,)
              ),

              Container(
                child: Row(
                children: [
                const Icon(Icons.exit_to_app, color: Color(0xff15B77C)),
                Container(
                  margin: const EdgeInsets.only(left: 10),
                  child: TextButton(onPressed: () {
                 _showMyDialog();
                }, child: const Text('Sign Out', style: TextStyle(color: Colors.black, fontSize: 16),),),
                )
              ],),),

            // ElevatedButton(child: Text('Update Profile Photo', style: TextStyle(color: Colors.black),), onPressed: () {
            //   Navigator.push(context,
            //     MaterialPageRoute(builder: (context) => SettingsItem(staff: staff, info: info, currentItem: '400')));
            // }, style: ElevatedButton.styleFrom(backgroundColor: const Color(0xffD6EBE3)),),
            ],)
          ),

          // SettingsItem(staff: staff, info: info, currentItem: currentItem.value)
      ]),
    );
  }
}