import 'package:e_360/Screens/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:e_360/Screens/profile.dart';
import 'package:e_360/Models/Staff.dart';
import 'package:e_360/Models/Staff.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:e_360/Models/DrawerItem.dart';
import 'package:e_360/Screens/Requests.dart';
import 'package:e_360/Screens/Home.dart';
import 'package:e_360/Screens/Payslip.dart';
import 'package:e_360/Screens/Settings.dart';
import 'package:e_360/Screens/Management.dart';

class Utilization extends HookWidget {

  Map<dynamic, dynamic>? data;
  Utilization({super.key, required this.data});


  @override 
  Widget build(BuildContext context) {

    return Container(
        // width: 300,
        padding: const EdgeInsets.all(10),
      height: 120,
      decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(7))),
      child: data != null ? Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text('Your Requisition Details', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),),
          Container(
            margin: const EdgeInsets.only(top: 20),
            child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
            Container(
              width: 100,
              child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
              const Text("Total leave", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black)),
              Text(data?["LvTotal"].toString() as String, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xff15B77C)))
            ],),
            ),
            Container(
              width: 100,
              child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
              const Text("Leave Used", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black)),
              Text(data?["LvUsed"].toString() as String, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xff15B77C)))
            ],),
            ),
            Container(
              width: 100,
              child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
              const Text("Leave Remaining", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black)),
              Text(data?["LvRemain"].toString() as String, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xff15B77C)))
            ],),
            )
          ],),)
      ],) : null
      );
  }
}