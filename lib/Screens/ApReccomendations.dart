import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:e_360/Models/Staff.dart';
import 'package:e_360/Widgets/input.dart';
import 'package:e_360/Widgets/customSlider.dart';

class Recommendations extends HookWidget {
  Staff staff;
  int totalBC;
  int totalKpi;
  ValueNotifier<int?> metricStep;
  TextEditingController re1;
  TextEditingController re2;
  TextEditingController re3;
  TextEditingController re4;
  
  Recommendations({super.key, required this.staff, required this.totalBC, required this.totalKpi, required this.re1, required this.re2, required this.re3, required this.metricStep, required this.re4});

  final _formKey = GlobalKey<FormState>(debugLabel: '');

  @override 

  Widget build(BuildContext context) {
    return Form(
              key: _formKey,
              child: ListView(children: [
                Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.only(bottom: 20),
                  child: const Text('Recommendations', style: TextStyle(color: Color(0xff15B77C), fontSize: 20, fontWeight: FontWeight.bold),),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 0),
                  child: Column(children: [
                    
                    Container(
                      height: 80,
                      margin: const EdgeInsets.only(top: 20),
                      child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,  
                      children: [
                      const Text('Observed Opportunities for improvement', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: CustomInput(controller: re1,),
                      )
                    ],),),

                    Container(
                      height: 80,
                      margin: EdgeInsets.only(top: 20),
                      child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,    
                      children: [
                      const Text('Training Needs', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: CustomInput(controller: re2),
                      )
                    ],),
                    ),

                    Container(
                      height: 80,
                      margin: EdgeInsets.only(top: 20),
                      child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,  
                      children: [
                      const Text('Observed Strengths', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: CustomInput(controller: re3),
                      )
                    ],),
                    ),

                    Container(
                      height: 80,
                      margin: EdgeInsets.only(top: 20, bottom: 20),
                      child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,  
                      children: [
                      const Text('Employees Comments/Feedback', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: CustomInput(controller: re4),
                      )
                    ],),
                    ),
                    SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 60,
                  child: ElevatedButton(child: Text('Submit'), onPressed: () {
                    metricStep.value = 3;
                  }, style: ElevatedButton.styleFrom(backgroundColor: const Color(0xff15B77C))),
                )
                  ]),
                )
            ],));
  }
}