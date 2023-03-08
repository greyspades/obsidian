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

class Kpi extends HookWidget {
  Staff staff;
  ValueNotifier<int> totalKpi;
  ValueNotifier<int?> metricStep;
  ValueNotifier<int> currentStep;
  List<Map<dynamic, dynamic>> kpis;
  ValueNotifier<bool> active;
  dynamic setStep;
  dynamic calculateKpiSum;
  dynamic addKpiValue;
  ValueNotifier<int> kpiVal;
  TextEditingController kpiJust;
  dynamic addKpi;
  dynamic kpiObj;
  String appraiser;
  String appraiserRef;
  Transaction? trans;
  Kpi(
      {super.key,
      required this.kpiVal,
      required this.addKpi,
      required this.kpiJust,
      required this.addKpiValue,
      required this.staff,
      required this.kpis,
      this.kpiObj,
      required this.appraiser,
      required this.totalKpi,
      required this.metricStep,
      required this.currentStep,
      required this.setStep,
      required this.active,
      required this.appraiserRef,
      this.trans,
      required this.calculateKpiSum});

  final _formKey = GlobalKey<FormState>(debugLabel: '');

  final _kpiForm = GlobalKey<FormState>(debugLabel: '');

  MaterialColor colorCustom = MaterialColor(0xff15B77C, color);

  @override
  Widget build(BuildContext context) {
    final currentKpi = useState<Map<dynamic, dynamic>>({});

    final kpiRef = useState<String?>(null);

    final error = useState<String?>(null);

    validateField(String value) {
      if (value == null || value.isEmpty) {
        return "Please fill in the required fields";
      }
    }

    // useEffect(() {
    //   Future.delayed(const Duration(seconds: 3), () async {
    //     if (kpis.isEmpty) {
    //       metricStep.value = 1;
    //     }
    //   });

    //   // print(object)
    // }, []);

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
                  Text('Your current KPI inputs will be discarded'),
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
                  metricStep.value = null;
                  active.value = false;
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }

    return Container(
      child: kpis.isNotEmpty ? ListView(
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
          margin: const EdgeInsets.only(bottom: 10),
          child: const Text(
            'KPI',
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
          child: kpis.isNotEmpty
              ? Stepper(
                  physics: const ClampingScrollPhysics(),
                  controlsBuilder: ((context, details) {
                    return Container(
                        padding:
                            const EdgeInsets.only(left: 100, right: 10, top: 5),
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
                    if (currentStep.value < kpis.length - 1 &&
                        kpiJust.text.isNotEmpty &&
                        kpiVal.value > 0) {
                      totalKpi.value += kpiVal.value;
                      var result = {
                        "xAppraisee": appraiserRef,
                        "xAppraisalBy": staff.userRef,
                        "xAppraiseeScope": appraiser,
                        "xAppraisalItemType": "KPI",
                        "xAppraisalItemRef": kpiRef.value,
                        "xEvaluationScore": kpiVal.value.toString(),
                        "xEvaluationJustify": kpiJust.text
                      };
                      addKpi(result);
                      kpiRef.value = null;
                      kpiVal.value = 0;
                      kpiJust.clear();
                      error.value = null;
                      currentStep.value += 1;
                    } else if (kpiJust.text.isEmpty) {
                      error.value = 'just';
                    } else if (kpiVal.value < 1) {
                      error.value = 'score';
                    } else {
                      totalKpi.value += kpiVal.value;
                      var result = {
                        "xAppraisee": appraiserRef,
                        "xAppraisalBy": staff.userRef,
                        "xAppraiseeScope": appraiser,
                        "xAppraisalItemType": "KPI",
                        "xAppraisalItemRef": kpiRef.value,
                        "xEvaluationScore": kpiVal.value.toString(),
                        "xEvaluationJustify": kpiJust.text
                      };
                      addKpi(result);
                      calculateKpiSum();
                    }
                  },
                  onStepCancel: () {
                    currentStep.value -= 1;
                    kpiVal.value = 0;
                  },
                  onStepTapped: (int step) => setStep(step, 'KPI'),
                  steps: kpis.map<Step>((e) {
                    return Step(
                      title: Container(
                          // height: 60,
                          margin: const EdgeInsets.only(top: 5, bottom: 5),
                          decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(6))),
                          padding: const EdgeInsets.all(10),
                          child: Text(
                            e['Perf_KPI_Desc'],
                            style: const TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 16),
                          )),
                      content: Container(
                        child: Column(
                          children: <Widget>[
                            CustomSlider(
                              // name: e['Perf_KPI_Desc'],
                              value: kpiVal.value.toDouble(),
                              onChange: (value) {
                                kpiVal.value = value.toInt();
                                kpiRef.value = e['KPI_Code'];
                              },
                              max: e['Perf_KPI_WMark'],
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
                              controller: kpiJust,
                              validation: validateField,
                              hintText: 'Justification',
                            )
                          ],
                        ),
                      ),
                      isActive: currentStep.value < kpis.length,
                      state: currentStep.value >= kpis.length
                          ? StepState.complete
                          : StepState.disabled,
                    );
                  }).toList(),
                )
              : Container(),
        ),
        // ElevatedButton(onPressed: () {
        //   print(kpiVal.value);
        //   print(totalKpi.value);
        //   print(kpiJust.text);
        // }, child: Text('click'))
      ],
    ) : Container(
      padding: const EdgeInsets.all(8),
      decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(8)), color: Color.fromARGB(255, 229, 225, 225)),
      child: const Text('You have no KPI set, please contact your line manager'),)
    );
  }
}
