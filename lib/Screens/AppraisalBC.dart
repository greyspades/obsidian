import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:e_360/Models/Staff.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:e_360/Widgets/input.dart';
import 'package:e_360/Models/DepOfficer.dart';
import 'package:e_360/Widgets/customSlider.dart';

Map<int, Color> color = {
  50: Color.fromRGBO(136, 14, 79, .1),
  100: Color.fromRGBO(136, 14, 79, .2),
  200: Color.fromRGBO(136, 14, 79, .3),
  300: Color.fromRGBO(136, 14, 79, .4),
  400: Color.fromRGBO(136, 14, 79, .5),
  500: Color.fromRGBO(136, 14, 79, .6),
  600: Color.fromRGBO(136, 14, 79, .7),
  700: Color.fromRGBO(136, 14, 79, .8),
  800: Color.fromRGBO(136, 14, 79, .9),
  900: Color.fromRGBO(136, 14, 79, 1),
};

class BehaviouralComp extends HookWidget {
  Staff staff;
  ValueNotifier<int?> totalBC;
  ValueNotifier<int?> metricStep;
  ValueNotifier<int> currentStep;
  ValueNotifier<int> valueOne;
  ValueNotifier<int> valueTwo;
  ValueNotifier<int> valueThree;
  ValueNotifier<int> valueFour;
  ValueNotifier<int> valueFive;
  dynamic setStep;
  dynamic calculateBCSum;
  
  BehaviouralComp({super.key, required this.staff, required this.totalBC, required this.metricStep, required this.currentStep, required this.setStep, required this.valueOne, required this.valueTwo, required this.valueThree, required this.valueFour, required this.valueFive, required this.calculateBCSum});

  final _formKey = GlobalKey<FormState>(debugLabel: '');

   final _kpiForm = GlobalKey<FormState>(debugLabel: '');

   MaterialColor colorCustom = MaterialColor(0xff15B77C, color);

  @override 

  Widget build(BuildContext context) {
    return ListView(
              children: [
                Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.only(bottom: 20),
                  child: const Text('Behavioral Competencies', style: TextStyle(color: Color(0xff15B77C), fontSize: 20, fontWeight: FontWeight.bold),),
                ),
                Theme(
                  data: ThemeData(
                      primarySwatch: colorCustom,
                      colorScheme: ColorScheme.light(primary: colorCustom)),
                  child: Stepper(
                      physics: const ClampingScrollPhysics(),
                      controlsBuilder: ((context, details) {
                        return Container(
                            padding: const EdgeInsets.only(
                                left: 100, right: 10, top: 5),
                            child: currentStep.value != 5
                                ? Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                const Color(0xff15B77C)),
                                        onPressed: () {
                                          details.onStepCancel!();
                                        },
                                        child: const Text(
                                          'Prev',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                const Color(0xff15B77C)),
                                        onPressed: () {
                                          details.onStepContinue!();
                                        },
                                        child: const Text(
                                          'Next',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      )
                                    ],
                                  )
                                : null);
                      }),
                      currentStep: currentStep.value,
                      onStepContinue: () {
                        // currentStep.value = currentStep.value ++;
                        currentStep.value < 5 ? currentStep.value += 1 : null;
                      },
                      onStepCancel: () {
                        currentStep.value > 0 ? currentStep.value -= 1 : null;
                      },
                      onStepTapped: (int step) => setStep(step, 'BC'),
                      steps: <Step>[
                        Step(
                          title: Container(
                            decoration: BoxDecoration(color: Colors.grey[200], borderRadius: const BorderRadius.all(Radius.circular(6))),
                            padding: const EdgeInsets.all(10),
                            // width: 200,
                            child: const Text("Integrity", style: TextStyle(color: Color(0xff15B77C)),)),
                          content: Container(
                            // color: Colors.grey[200],
                            child: Column(
                              children: <Widget>[
                                CustomSlider(
                                    name: "Integrity",
                                    value: valueOne.value.toDouble(),
                                    onChange: (value) {
                                      valueOne.value = value.toInt();
                                    },
                                    prev: () {},
                                    next: () {
                                      
                                    })
                              ],
                            ),
                          ),
                          isActive: currentStep.value == 0,
                          state: currentStep.value >= 0
                              ? StepState.complete
                              : StepState.disabled,
                        ),
                        Step(
                          // title: const Text(
                          //   '',
                          //   style: TextStyle(
                          //       fontSize: 16, fontWeight: FontWeight.bold),
                          // ),
                          title: Container(
                            decoration: BoxDecoration(color: Colors.grey[200], borderRadius: const BorderRadius.all(Radius.circular(6))),
                            padding: const EdgeInsets.all(10),
                            // width: 200,
                            child: const Text("Effective Communication/Courtious relationship with others", style: TextStyle(color: Color(0xff15B77C)),)),
                          content: Container(
                            // color: Colors.grey[200],
                            child: Column(
                              children: <Widget>[
                                CustomSlider(
                                    name:
                                        "Effective Communication/Courtious relationship with others",
                                    value: valueTwo.value.toDouble(),
                                    onChange: (value) {
                                      valueTwo.value = value.toInt();
                                    },
                                    prev: () {},
                                    next: () {})
                              ],
                            ),
                          ),
                          isActive: currentStep.value == 1,
                          state: currentStep.value >= 1
                              ? StepState.complete
                              : StepState.disabled,
                        ),
                        Step(
                          title: Container(
                            decoration: BoxDecoration(color: Colors.grey[200], borderRadius: const BorderRadius.all(Radius.circular(6))),
                            padding: const EdgeInsets.all(10),
                            // width: 200,
                            child: const Text("Cost Mgt./Turn- Arround Time with Customers", style: TextStyle(color: Color(0xff15B77C)),)),
                          content: Container(
                            // color: Colors.grey[200],
                            child: Column(
                              children: <Widget>[
                                CustomSlider(
                                    name:
                                        "Cost Mgt./Turn- Arround Time with Customers",
                                    value: valueThree.value.toDouble(),
                                    onChange: (value) {
                                      valueThree.value = value.toInt();
                                    },
                                    prev: () {},
                                    next: () {},
                                    )
                              ],
                            ),
                          ),
                          isActive: currentStep.value == 2,
                          state: currentStep.value >= 2
                              ? StepState.complete
                              : StepState.disabled,
                        ),
                        Step(
                          title: Container(
                            decoration: BoxDecoration(color: Colors.grey[200], borderRadius: const BorderRadius.all(Radius.circular(6))),
                            padding: const EdgeInsets.all(10),
                            // width: 200,
                            child: const Text("Decision Making /Initiative", style: TextStyle(color: Color(0xff15B77C)),)),
                          content: Container(
                            // color: Colors.grey[200],
                            child: Column(
                              children: <Widget>[
                                CustomSlider(
                                    name: "Decision Making /Initiative",
                                    value: valueFour.value.toDouble(),
                                    onChange: (value) {
                                      valueFour.value = value.toInt();
                                    },
                                    prev: () {},
                                    next: () {})
                              ],
                            ),
                          ),
                          isActive: currentStep.value == 3,
                          state: currentStep.value >= 3
                              ? StepState.complete
                              : StepState.disabled,
                        ),
                        Step(
                          title: Container(
                            decoration: BoxDecoration(color: Colors.grey[200], borderRadius: const BorderRadius.all(Radius.circular(6))),
                            padding: const EdgeInsets.all(10),
                            // width: 200,
                            child: const Text("Innovative Orientation", style: TextStyle(color: Color(0xff15B77C)),)),
                          content: Container(
                            // color: Colors.grey[200],
                            child: Column(
                              children: <Widget>[
                                CustomSlider(
                                    name: "Innovative Orientation",
                                    value: valueFive.value.toDouble(),
                                    onChange: (value) {
                                      valueFive.value = value.toInt();
                                    },
                                    prev: () {},
                                    next: () {})
                              ],
                            ),
                          ),
                          isActive: currentStep.value == 4,
                          state: currentStep.value >= 4
                              ? StepState.complete
                              : StepState.disabled,
                        ),
                        Step(
                          title: Container(
                            decoration: BoxDecoration(color: Colors.grey[200], borderRadius: const BorderRadius.all(Radius.circular(6))),
                            padding: const EdgeInsets.all(10),
                            // width: 200,
                            child: const Text("Next", style: TextStyle(color: Color(0xff15B77C)),)
                            ),
                          content: Container(
                            child: Column(
                              children: <Widget>[
                                SizedBox(
                                  height: 60,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      calculateBCSum();
                                    },
                                    child: const Text(
                                      'Submit',
                                      style: TextStyle(
                                          fontSize: 14, color: Colors.white),
                                    )),
                                )
                              ],
                            ),
                          ),
                          isActive: currentStep.value == 5,
                          state: currentStep.value >= 5
                              ? StepState.complete
                              : StepState.disabled,
                        ),
                      ]),
                )
              ],
            );
  }
}