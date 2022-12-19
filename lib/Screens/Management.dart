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

class Management extends HookWidget {
  Staff staff;
  Map<dynamic, dynamic> info;
  Management({super.key, required this.staff, required this.info});

  bool isAppraiser = true;
  bool active = false;

  MaterialColor colorCustom = MaterialColor(0xff15B77C, color);

  @override
  Widget build(BuildContext context) {
    final active = useState<bool>(false);
    final currentStep = useState<int>(0);
    final valueOne = useState<int>(0);
    final valueTwo = useState<int>(0);
    final valueThree = useState<int>(0);

    setStep(int step) {
      currentStep.value = step;
    }

    handleDrag(int index, int value) {
      switch(index) {
        case 1:
        valueOne.value = value;
        break;

        case 2:
        valueTwo.value = value;
        break;

        case 3:
        valueThree.value = value;
        break;
      }
    }

    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: active.value == false
          ? Container(
              width: 300,
              height: 200,
              child: Card(
                  // color: const Color(0xffD6EBE3),
                  color: Colors.grey[200],
                  margin: const EdgeInsets.all(30),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      const Text('Begin new Appraisal', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                      SizedBox(
                        width: 200,
                        height: 40,
                          child: ElevatedButton(onPressed: () {
                          active.value = true;
                        },
                        style: ElevatedButton.styleFrom(backgroundColor: const Color(0xff15B77C)),
                        child: const Text('Begin'),
                        ),
                      )
                    ],
                  )),
            )
          : ListView(
              children: [
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
                      onStepTapped: (int step) => setStep(step),
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
                                    next: () {})
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
                                    onChange: handleDrag,
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
                                    value: valueThree.value.toDouble(),
                                    onChange: (value) {
                                      valueThree.value = value.toInt();
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
                                    value: valueThree.value.toDouble(),
                                    onChange: (value) {
                                      valueThree.value = value.toInt();
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
                            child: const Text("Submit Appraisal Request", style: TextStyle(color: Color(0xff15B77C)),)),
                          content: Container(
                            child: Column(
                              children: <Widget>[
                                ElevatedButton(
                                    onPressed: () {},
                                    child: const Text(
                                      'Submit Appraisal Request',
                                      style: TextStyle(
                                          fontSize: 14, color: Colors.white),
                                    ))
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
            ),
    );
  }
}
