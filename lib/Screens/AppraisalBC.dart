import 'package:e_360/Models/Transaction.dart';
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
  ValueNotifier<int> totalBC;
  ValueNotifier<int?> metricStep;
  ValueNotifier<int> currentStep;
  List<Map<dynamic, dynamic>> BCs;
  ValueNotifier<bool> active;
  dynamic setStep;
  dynamic calculateBCSum;
  dynamic addBc;
  TextEditingController bcJust;
  dynamic? bcObj;
  String appraiser;
  String appraiserRef;
  ValueNotifier<int> BCVal;
  Transaction? trans;

  BehaviouralComp(
      {super.key,
      required this.BCVal,
      required this.staff,
      required this.BCs,
      required this.totalBC,
      required this.metricStep,
      required this.currentStep,
      required this.setStep,
      required this.active,
      required this.calculateBCSum,
      required this.bcJust,
      required this.addBc,
      required this.appraiser,
      required this.appraiserRef,
      this.bcObj,
      this.trans});

  final _formKey = GlobalKey<FormState>(debugLabel: '');

  final _kpiForm = GlobalKey<FormState>(debugLabel: '');

  MaterialColor colorCustom = MaterialColor(0xff15B77C, color);

  @override
  Widget build(BuildContext context) {
    final bcRef = useState<String?>(null);

    final error = useState<String?>(null);

    Future<void> _showMyDialog() async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text(
              'Sure to go back?',
              style: TextStyle(
                  color: Color(0xff15B77C),
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text(
                      'Your current Behavioural Competencies inputs will be discarded'),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Close'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text('Continue'),
                onPressed: () {
                  metricStep.value = 0;
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }

    return ListView(
      children: [
        Container(
          margin: const EdgeInsets.only(right: 20),
          alignment: Alignment.centerRight,
          child: IconButton(
              onPressed: () {
                _showMyDialog();
              },
              icon: const Icon(
                Icons.keyboard_double_arrow_left_rounded,
                size: 28,
                color: Color(0xff15B77C),
              )),
        ),
        Container(
          alignment: Alignment.center,
          margin: const EdgeInsets.only(bottom: 20),
          child: const Text(
            'Behavioral Competencies',
            style: TextStyle(
                color: Color(0xff15B77C),
                fontSize: 20,
                fontWeight: FontWeight.bold),
          ),
        ),
        Theme(
          data: ThemeData(
              primarySwatch: colorCustom,
              colorScheme: ColorScheme.light(primary: colorCustom)),
          child: Stepper(
            physics: const ClampingScrollPhysics(),
            controlsBuilder: ((context, details) {
              return Container(
                  padding: const EdgeInsets.only(left: 100, right: 10, top: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xff15B77C)),
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
                            backgroundColor: const Color(0xff15B77C)),
                        onPressed: () {
                          details.onStepContinue!();
                        },
                        child: const Text(
                          'Next',
                          style: TextStyle(color: Colors.white),
                        ),
                      )
                    ],
                  ));
            }),
            currentStep: currentStep.value,
            onStepContinue: () {
              if (currentStep.value < BCs.length - 1 &&
                  bcJust.text.isNotEmpty &&
                  BCVal.value > 0) {
                totalBC.value += BCVal.value;
                var result = {
                  "xAppraisee": appraiserRef,
                  "xAppraisalBy": staff.userRef,
                  "xAppraiseeScope": appraiser,
                  "xAppraisalItemType": "Bhav_comp",
                  "xAppraisalItemRef": bcRef.value,
                  "xEvaluationScore": BCVal.value.toString(),
                  "xEvaluationJustify": bcJust.text
                };
                addBc(result);
                bcRef.value = null;
                BCVal.value = 0;
                bcJust.clear();
                error.value = null;
                currentStep.value += 1;
              } else if (bcJust.text.isEmpty) {
                error.value = 'just';
              } else if (BCVal.value < 1) {
                error.value = 'score';
              } else {
                totalBC.value += BCVal.value;
                calculateBCSum();
              }
            },
            onStepCancel: () {
              currentStep.value -= 1;
              BCVal.value = 0;
            },
            onStepTapped: (int step) => setStep(step, 'BC'),
            steps: BCs.map<Step>((e) {
              return Step(
                title: Container(
                    margin: const EdgeInsets.only(top: 5, bottom: 5),
                    decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius:
                            const BorderRadius.all(Radius.circular(6))),
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      e['Bhv_Comp_Desc'],
                      style: const TextStyle(
                          fontWeight: FontWeight.w500, fontSize: 16),
                    )),
                content: Container(
                  child: Column(
                    children: <Widget>[
                      CustomSlider(
                        value: BCVal.value.toDouble(),
                        onChange: (value) {
                          BCVal.value = value.toInt();
                          bcRef.value = e['Bhv_Comp_Code'];
                        },
                        max: e['Bhv_Comp_WMark'],
                      ),
                      Container(
                        child: error.value == 'just'
                            ? const Text(
                                'Please enter a justification for this score',
                                style: TextStyle(color: Colors.red),
                              )
                            : error.value == 'score'
                                ? const Text(
                                    'Please select a score greater than 0',
                                    style: TextStyle(color: Colors.red),
                                  )
                                : null,
                      ),
                      CustomInput(
                        controller: bcJust,
                        hintText: 'Justification',
                      )
                    ],
                  ),
                ),
                isActive: currentStep.value < BCs.length + 1,
                state: currentStep.value >= BCs.length + 1
                    ? StepState.complete
                    : StepState.disabled,
              );
            }).toList(),
          ),
        ),
        // ElevatedButton(
        //     onPressed: () {
        //       print(bcObj);
        //     },
        //     child: Text('click'))
      ],
    );
  }
}
