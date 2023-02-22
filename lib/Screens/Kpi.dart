// import 'package:flutter/material.dart';
// import 'package:flutter_hooks/flutter_hooks.dart';
// import 'package:e_360/Models/Staff.dart';
// import 'package:hooks_riverpod/hooks_riverpod.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:e_360/Widgets/input.dart';
// import 'package:e_360/Models/DepOfficer.dart';
// import 'package:e_360/Widgets/customSlider.dart';
// import 'package:convert/convert.dart';
// import 'package:e_360/helpers/contract.dart';
// import 'package:e_360/helpers/aes.dart';

// class Kpi extends HookConsumerWidget {
//   Staff staff;
//   int totalBC;
//   int totalKpi;
//   ValueNotifier<int?> metricStep;
//   TextEditingController kp1;
//   TextEditingController kp2;
//   TextEditingController kp3;
//   TextEditingController kp4;
//   TextEditingController kp5;
//   TextEditingController kp6;
//   TextEditingController kp7;

//   dynamic calculateKpiSum;

//   dynamic validateWM;
  
//   Kpi({super.key, required this.staff, required this.totalBC, required this.totalKpi, required this.kp1, required this.kp2, required this.kp3, required this.metricStep, required this.kp4, required this.validateWM, required this.kp5, required this.kp6, required this.kp7, required this.calculateKpiSum});

//   final _formKey = GlobalKey<FormState>(debugLabel: '');

//    final _kpiForm = GlobalKey<FormState>(debugLabel: '');

//   @override 

//   Widget build(BuildContext context, WidgetRef ref) {
//     final Auth auth = ref.watch(authProvider);

//      Future<void> getKpi() async {
//     Uri url = Uri.parse('http://10.0.0.184:8015/perfomance/listkpiforjobfunction');
//     var token = jsonEncode({
//       'tk': auth.token,
//       'us': staff.userRef,
//       'rl': staff.uRole,
//       'src': "AS-IN-D659B-e3M"
//     });
//     var headers = {
//       'x-lapo-eve-proc': base64ToHex(encryption(token, auth.aesKey ?? '', auth.iv ?? '')),
//       'Content-type': 'text/json',
//     };
//     var body = jsonEncode({
//       'tk': auth.token,
//       'us': staff.userRef,
//       'rl': staff.uRole,
//       'src': "AS-IN-D659B-e3M"
//     });

//     final xpayload = base64ToHex(encryption(body, auth.aesKey ?? '', auth.iv ?? ''));
//     var response = await http.post(url,
//         headers: headers, body: xpayload);
//       print(response.body);
//     if (response.statusCode == 200) {
//       var data = jsonDecode(response.body)['data'];
//       var xdata = decryption(base64.encode(hex.decode(data)), auth.aesKey ?? '', auth.iv ?? '');
//       // var divisionResponse =
//       //     Map<dynamic, dynamic>.from(jsonDecode(xdata));
//       // setState(() {
//       //   division = divisionResponse;
//       // });
//     }
//   }

//   useEffect(() {
//     getKpi();
//   }, []);
//     return Form(
//               key: _kpiForm,
//               child: ListView(
          
//               children: [
//                 Container(
//                   alignment: Alignment.center,
//                   margin: const EdgeInsets.only(top: 20, bottom: 20),
//                   child: const Text('KPI', style: TextStyle(color: Color(0xff15B77C), fontSize: 20, fontWeight: FontWeight.bold),),
//                 ),
//                 // Container(
//                 //   margin: const EdgeInsets.only(top: 20, bottom: 20),
//                 //   child: kp1.text != null ? Text((int.parse(kp1.text) + int.parse(kp2.text) + int.parse(kp3.text) + int.parse(kp4.text) + int.parse(kp5.text) + int.parse(kp6.text) + int.parse(kp7.text)).toString(), style: const TextStyle(color: Color(0xff15B77C), fontSize: 16, fontWeight: FontWeight.bold),) : null
//                 // ),
//                 Container(
//                   // height: 120,
//                   margin: const EdgeInsets.only(top: 20),
//                   child: Column(
//                   mainAxisAlignment: MainAxisAlignment.spaceAround,
//                   children: [
//                   Container(
//                     padding: EdgeInsets.all(10),
//                     decoration: BoxDecoration(color: Colors.grey[200], borderRadius: const BorderRadius.all(Radius.circular(8))),
//                     child: Text("T" + ("IMELY DELIVERY BASED ON THE REQUIREMENT WITHIN THE PROJECT TIMELINE.").toLowerCase(), style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16),),
//                   ),
//                   Container(
//                     margin: const EdgeInsets.only(top: 10, bottom: 10),
//                     child: const Text('WM: 10', style: TextStyle(color: Color(0xff15B77C)),),
//                   ),
//                   SizedBox(
//                     width: MediaQuery.of(context).size.width,
//                     height: 60,
//                     child: CustomInput(controller: kp1,
//                     validation: (val) => validateWM(val, 10),
//                     textType: TextInputType.number,
//                     ),
//                   )
//                 ],),),

//                 Container(
//                   // height: 120,
//                   margin: const EdgeInsets.only(top: 20),
//                   child: Column(
//                   mainAxisAlignment: MainAxisAlignment.spaceAround,
//                   children: [
//                   Container(
//                     padding: EdgeInsets.all(10),
//                     decoration: BoxDecoration(color: Colors.grey[200], borderRadius: const BorderRadius.all(Radius.circular(8))),
//                     child: Text( "E" + "NSURE ALL STAKEHOLDERS’ REQUEST FOR DEVELOPMENT MEETS THE REQUIREMENT.".toLowerCase(), style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16)),
//                   ),
//                   Container(
//                     margin: const EdgeInsets.only(top: 10, bottom: 10),
//                     child: const Text('WM: 10', style: TextStyle(color: Color(0xff15B77C)),),
//                   ),
//                   SizedBox(
//                     width: MediaQuery.of(context).size.width,
//                     height: 60,
//                     child: CustomInput(controller: kp2,
//                     validation: (val) => validateWM(val, 10),
//                     textType: TextInputType.number,
//                     ),
//                   )
//                 ],),),

//                 Container(
//                   // height: 120,
//                   margin: const EdgeInsets.only(top: 20),
//                   child: Column(
//                   mainAxisAlignment: MainAxisAlignment.spaceAround,
//                   children: [
//                   Container(
//                     padding: EdgeInsets.all(10),
//                     decoration: BoxDecoration(color: Colors.grey[200], borderRadius: const BorderRadius.all(Radius.circular(8))),
//                     child: Text("N" + "UMBER OF NEW INNOVATION FOR IMPROVED OPERATION AND ACTIVITIES RECOMMENDED.".toLowerCase(), style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16)),
//                   ),
//                   Container(
//                     margin: const EdgeInsets.only(top: 10, bottom: 10),
//                     child: const Text('WM: 10', style: TextStyle(color: Color(0xff15B77C)),),
//                   ),
//                   SizedBox(
//                     width: MediaQuery.of(context).size.width,
//                     height: 60,
//                     child: CustomInput(controller: kp3,
//                     validation: (val) => validateWM(val, 10),
//                     textType: TextInputType.number,
//                     ),
//                   )
//                 ],),),

//                 Container(
//                   // height: 120,
//                   margin: const EdgeInsets.only(top: 20),
//                   child: Column(
//                   mainAxisAlignment: MainAxisAlignment.spaceAround,
//                   children: [
//                   Container(
//                     padding: EdgeInsets.all(10),
//                     decoration: BoxDecoration(color: Colors.grey[200], borderRadius: const BorderRadius.all(Radius.circular(8))),
//                     child: Text("E" + "FFECTIVE COMMUNICATION OF PROJECT MILESTONES WITH STAKEHOLDERS.".toLowerCase(), style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16)),
//                   ),
//                   Container(
//                     margin: const EdgeInsets.only(top: 10, bottom: 10),
//                     child: const Text('WM: 10', style: TextStyle(color: Color(0xff15B77C)),),
//                   ),
//                   SizedBox(
//                     width: MediaQuery.of(context).size.width,
//                     height: 60,
//                     child: CustomInput(controller: kp4,
//                     validation: (val) => validateWM(val, 10),
//                     textType: TextInputType.number,
//                     ),
//                   )
//                 ],),),

//                 Container(
//                   // height: 120,
//                   margin: const EdgeInsets.only(top: 20),
//                   child: Column(
//                   mainAxisAlignment: MainAxisAlignment.spaceAround,
//                   children: [
//                   Container(
//                     padding: EdgeInsets.all(10),
//                     decoration: BoxDecoration(color: Colors.grey[200], borderRadius: const BorderRadius.all(Radius.circular(8))),
//                     child: Text("U" + "NIT SUPERVISION.".toLowerCase(), style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16)),
//                   ),
//                   Container(
//                     margin: const EdgeInsets.only(top: 10, bottom: 10),
//                     child: const Text('WM: 10', style: TextStyle(color: Color(0xff15B77C)),),
//                   ),
//                   SizedBox(
//                     width: MediaQuery.of(context).size.width,
//                     height: 60,
//                     child: CustomInput(controller: kp5,
//                     validation: (val) => validateWM(val, 10),
//                     textType: TextInputType.number,
//                     ),
//                   )
//                 ],),),

//                  Container(
//                   // height: 120,
//                   margin: const EdgeInsets.only(top: 20),
//                   child: Column(
//                   mainAxisAlignment: MainAxisAlignment.spaceAround,
//                   children: [
//                   Container(
//                     padding: EdgeInsets.all(10),
//                     decoration: BoxDecoration(color: Colors.grey[200], borderRadius: const BorderRadius.all(Radius.circular(8))),
//                     child: Text("E" + "NSURE TIMELY COMPLETION OF DELIVERABLES WITH STAKEHOLDERS AND TECHNICAL RESOURCES WITHIN THE PROJECT TIMELINE.".toLowerCase(), style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16)),
//                   ),
//                   Container(
//                     margin: const EdgeInsets.only(top: 10, bottom: 10),
//                     child: const Text('WM: 10', style: TextStyle(color: Color(0xff15B77C)),),
//                   ),
//                   SizedBox(
//                     width: MediaQuery.of(context).size.width,
//                     height: 60,
//                     child: CustomInput(controller: kp6,
//                     validation: (val) => validateWM(val, 10),
//                     textType: TextInputType.number,
//                     ),
//                   )
//                 ],),),

//                 Container(
//                   // height: 120,
//                   margin: const EdgeInsets.only(top: 20),
//                   child: Column(
//                   mainAxisAlignment: MainAxisAlignment.spaceAround,
//                   children: [
//                   Container(
//                     padding: const EdgeInsets.all(10),
//                     decoration: BoxDecoration(color: Colors.grey[200], borderRadius: const BorderRadius.all(Radius.circular(8))),
//                     child: Text("T" + "IMELY DELIVERY OF DESIGNED ARCHITECTURE AND TECHNICAL REQUIREMENT WITHIN THE PROJECT TIMELINE".toLowerCase(), style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16)),
//                   ),
//                   Container(
//                     margin: const EdgeInsets.only(top: 10, bottom: 10),
//                     child: const Text('WM: 10', style: TextStyle(color: Color(0xff15B77C)),),
//                   ),
//                   SizedBox(
//                     width: MediaQuery.of(context).size.width,
//                     height: 60,
//                     child: CustomInput(controller: kp7,
//                     validation: (val) => validateWM(val, 10),
//                     textType: TextInputType.number,
//                     ),
//                   )
//                 ],),),
          
//                 SizedBox(
//                   width: MediaQuery.of(context).size.width,
//                   height: 60,
//                   child: ElevatedButton(child: Text('Next'), onPressed: () {
//                     if(_kpiForm.currentState!.validate()) {
//                       // print('got here');
//                       calculateKpiSum();
//                     }
//                   }, style: ElevatedButton.styleFrom(backgroundColor: const Color(0xff15B77C))),
//                 )
//               ],
//             ));
//   }
// }

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
  ValueNotifier<int?> totalKpi;
  ValueNotifier<int?> metricStep;
  ValueNotifier<int> currentStep;
  ValueNotifier<int> kpi1;
  ValueNotifier<int> kpi2;
  ValueNotifier<int> kpi3;
  ValueNotifier<int> kpi4;
  ValueNotifier<int> kpi5;
  dynamic setStep;
  dynamic calculateKpiSum;
  
  Kpi({super.key, required this.staff, required this.totalKpi, required this.metricStep, required this.currentStep, required this.setStep, required this.kpi1, required this.kpi2, required this.kpi3, required this.kpi4, required this.kpi5, required this.calculateKpiSum});

  final _formKey = GlobalKey<FormState>(debugLabel: '');

   final _kpiForm = GlobalKey<FormState>(debugLabel: '');

   MaterialColor colorCustom = MaterialColor(0xff15B77C, color);

  @override 

  Widget build(BuildContext context) {
    return ListView(
              children: [
                Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.only(bottom: 10),
                  child: const Text('KPI', style: TextStyle(color: Color(0xff15B77C), fontSize: 20, fontWeight: FontWeight.bold),),
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
                      onStepTapped: (int step) => setStep(step, 'KPI'),
                      steps: <Step>[
                        Step(
                          title: currentStep.value == 0 ? const Center(child: Text("1", style: TextStyle(color: Color(0xff15B77C), fontSize: 20, fontWeight: FontWeight.bold)),) : Container(
                            margin: const EdgeInsets.only(top: 5, bottom: 5),
                            decoration: BoxDecoration(color: Colors.grey[200], borderRadius: const BorderRadius.all(Radius.circular(6))),
                            padding: const EdgeInsets.all(10),
                            child: Text("T" + ("IMELY DELIVERY BASED ON THE REQUIREMENT WITHIN THE PROJECT TIMELINE.").toLowerCase(), style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16),)
                            ),
                          content: Container(
                            // color: Colors.grey[200],
                            child: Column(
                              children: <Widget>[
                                CustomSlider(
                                    name: "T" + ("IMELY DELIVERY BASED ON THE REQUIREMENT WITHIN THE PROJECT TIMELINE").toLowerCase(),
                                    value: kpi1.value.toDouble(),
                                    onChange: (value) {
                                      kpi1.value = value.toInt();
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
                          
                          title: currentStep.value == 1 ? const Center(child: Text("2", style: TextStyle(color: Color(0xff15B77C), fontSize: 20, fontWeight: FontWeight.bold)),) : Container(
                            margin: const EdgeInsets.only(top: 5, bottom: 5),
                            decoration: BoxDecoration(color: Colors.grey[200], borderRadius: const BorderRadius.all(Radius.circular(6))),
                            padding: const EdgeInsets.all(10),
                            child: Text("E" + "NSURE ALL STAKEHOLDERS’ REQUEST FOR DEVELOPMENT MEETS THE REQUIREMENT.".toUpperCase(), style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16),)
                            ),
                          content: Container(
                            // color: Colors.grey[200],
                            child: Column(
                              children: <Widget>[
                                CustomSlider(
                                    name:
                                        "E" + "NSURE ALL STAKEHOLDERS’ REQUEST FOR DEVELOPMENT MEETS THE REQUIREMENT.".toLowerCase(),
                                    value: kpi2.value.toDouble(),
                                    onChange: (value) {
                                      kpi2.value = value.toInt();
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
                          title: currentStep.value == 2 ? const Center(child: Text("3", style: TextStyle(color: Color(0xff15B77C), fontSize: 20, fontWeight: FontWeight.bold)),) : Container(
                            margin: const EdgeInsets.only(top: 5, bottom: 5),
                            decoration: BoxDecoration(color: Colors.grey[200], borderRadius: const BorderRadius.all(Radius.circular(6))),
                            padding: const EdgeInsets.all(10),
                            child: Text("N" + "UMBER OF NEW INNOVATION FOR IMPROVED OPERATION AND ACTIVITIES RECOMMENDED.".toLowerCase(), style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16),)
                            ),
                          content: Container(
                            // color: Colors.grey[200],
                            child: Column(
                              children: <Widget>[
                                CustomSlider(
                                    name:
                                        "N" + "UMBER OF NEW INNOVATION FOR IMPROVED OPERATION AND ACTIVITIES RECOMMENDED.".toLowerCase(),
                                    value: kpi3.value.toDouble(),
                                    onChange: (value) {
                                      kpi3.value = value.toInt();
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
                          title: currentStep.value == 3 ? const Center(child: Text("4", style: TextStyle(color: Color(0xff15B77C), fontSize: 20, fontWeight: FontWeight.bold)),) : Container(
                            margin: const EdgeInsets.only(top: 5, bottom: 5),
                            decoration: BoxDecoration(color: Colors.grey[200], borderRadius: const BorderRadius.all(Radius.circular(6))),
                            padding: const EdgeInsets.all(10),
                            child: Text("E" + "FFECTIVE COMMUNICATION OF PROJECT MILESTONES WITH STAKEHOLDERS.".toLowerCase(), style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16),)
                            ),
                          content: Container(
                            // color: Colors.grey[200],
                            child: Column(
                              children: <Widget>[
                                CustomSlider(
                                    name: "E" + "FFECTIVE COMMUNICATION OF PROJECT MILESTONES WITH STAKEHOLDERS.".toLowerCase(),
                                    value: kpi4.value.toDouble(),
                                    onChange: (value) {
                                      kpi4.value = value.toInt();
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
                            child: Column(
                              children: <Widget>[
                                CustomSlider(
                                    name: "Innovative Orientation",
                                    value: kpi3.value.toDouble(),
                                    onChange: (value) {
                                      kpi3.value = value.toInt();
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
                                      calculateKpiSum();
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