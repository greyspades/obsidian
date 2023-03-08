import 'package:e_360/Models/Transaction.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:e_360/Models/Staff.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:e_360/Widgets/input.dart';
import 'package:e_360/Models/DepOfficer.dart';
import 'package:e_360/Widgets/customSlider.dart';
import 'package:e_360/Screens/AppraisalSummary.dart';
import 'package:e_360/Screens/ApReccomendations.dart';
import 'package:e_360/Screens/Kpi.dart';
import 'package:e_360/Screens/AppraisalBC.dart';
import 'package:convert/convert.dart';
import 'package:e_360/helpers/contract.dart';
import 'package:e_360/helpers/aes.dart';

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

class Management extends HookConsumerWidget {
  Staff staff;
  Map<dynamic, dynamic> info;
  String appraiser;
  String appraiserRef;
  Transaction? trans;
  Management(
      {super.key,
      required this.staff,
      required this.info,
      required this.appraiser,
      required this.appraiserRef,
      this.trans});

  bool isAppraiser = true;

  bool active = false;

  MaterialColor colorCustom = MaterialColor(0xff15B77C, color);

  final re1 = TextEditingController();
  final re2 = TextEditingController();
  final re3 = TextEditingController();
  final re4 = TextEditingController();
  final re5 = TextEditingController();

  final ad1 = TextEditingController();
  final ad2 = TextEditingController();
  final ad3 = TextEditingController();

  final _kpiForm = GlobalKey<FormState>(debugLabel: '');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authProvider);
    //if an appraisal is currently active
    final active = useState<bool>(false);
    //the current step of the appraisal item
    final currentStep = useState<int>(0);
    //the stage of the appraisal process
    final metricStep = useState<int?>(null);
    //total kpi
    final totalKpi = useState<int>(0);
    //total behavioural competencies
    final totalBC = useState<int>(0);

    final kpiStep = useState<int>(0);

    final kpiVal = useState<int>(0);

    final BCVal = useState<int>(0);

    final bcStep = useState<int>(0);

    final staffKpi = useState<List<Map<dynamic, dynamic>>?>(null);

    final staffBC = useState<List<Map<dynamic, dynamic>>?>(null);

    final currentAppraiser = useState<String?>(null);

    final selfDetails = useState<List<Map>?>(null);

    final kpiJust = useTextEditingController();

    final bcJust = useTextEditingController();

    final kpiObj = useState<List<Map<dynamic, dynamic>>?>(null);

    final bcObj = useState<List<Map<dynamic, dynamic>>?>(null);

    final _formKey = GlobalKey<FormState>(debugLabel: '');

    final appariserInfo = useState<Map?>(null);

    final promRec = useState<bool>(false);

    void addKpiValue(int val) {
      totalKpi.value += val;
    }

    void addKpi(Map<dynamic, dynamic> val) {
      kpiObj.value = [...?kpiObj.value, val];
    }

    void addBc(Map<dynamic, dynamic> val) {
      bcObj.value = [...?bcObj.value, val];
    }

    // useEffect(() {
    //   // getData();
    //   // print(appraiserRef);
    //   return null;
    // }, []);

    Future<void> getKpi() async {
      Uri url =
          Uri.parse('https://e360.lapo-nigeria.org/perfomance/listappraisalkpis');
      var token = jsonEncode({
        'tk': auth.token,
        'us': staff.userRef,
        'rl': staff.uRole,
        'src': "AS-IN-D659B-e3M"
      });
      var headers = {
        'x-lapo-eve-proc':
            base64ToHex(encryption(token, auth.aesKey ?? '', auth.iv ?? '')) +
                (auth.token ?? ''),
        'Content-type': 'text/json',
      };
      var body = jsonEncode({
        'us': appraiserRef,
      });
      var response = await http.post(url,
          headers: headers,
          body:
              base64ToHex(encryption(body, auth.aesKey ?? '', auth.iv ?? '')));
      if (response.statusCode == 200) {
        var xdata = decryption(
            base64.encode(hex.decode(jsonDecode(response.body)['data'])),
            auth.aesKey ?? '',
            auth.iv ?? '');
        var data = List<Map<dynamic, dynamic>>.from(jsonDecode(xdata));
        staffKpi.value = data;
      }
    }

      Future<void> getSelfEvaluation() async {
      Uri url = Uri.parse(
          'https://e360.lapo-nigeria.org/perfomance/retrieveselfevaluation');
      var token = jsonEncode({
        'tk': auth.token,
        'us': staff.userRef,
        'rl': staff.uRole,
        'src': "AS-IN-D659B-e3M"
      });
      var headers = {
        'x-lapo-eve-proc':
            base64ToHex(encryption(token, auth.aesKey ?? '', auth.iv ?? '')) +
                (auth.token ?? ''),
        'Content-type': 'text/json',
      };
      var body = jsonEncode({
        "xTransRef": trans?.itemCode.toString(),
        // 'TRFAPRSLR0V7LBH43VU5',
  "xTransScope": "129dekekddkffmf2sv25",
  "xAppTransScope": "9e9efefech009eee",
  "xAppSource": "AS-IN-D659B-e3M",
  "xRecTargetSection": "string"
      });
      var response = await http.post(url,
          headers: headers,
          body:
              base64ToHex(encryption(body, auth.aesKey ?? '', auth.iv ?? '')));
      if (response.statusCode == 200) {
        var xdata = decryption(
            base64.encode(hex.decode(jsonDecode(response.body)['data'])),
            auth.aesKey ?? '',
            auth.iv ?? '');
        var data = List<Map<dynamic, dynamic>>.from(jsonDecode(xdata));
        selfDetails.value = data;
      }
    }

    Future<void> getBC() async {
      Uri url = Uri.parse(
          'https://e360.lapo-nigeria.org/perfomance/listappraisalbehaviouralcomp');
      var token = jsonEncode({
        'tk': auth.token,
        'us': staff.userRef,
        'rl': staff.uRole,
        'src': "AS-IN-D659B-e3M"
      });
      var headers = {
        'x-lapo-eve-proc':
            base64ToHex(encryption(token, auth.aesKey ?? '', auth.iv ?? '')) +
                (auth.token ?? ''),
        'Content-type': 'text/json',
      };
      var body = jsonEncode({
        'us': appraiserRef,
      });
      var response = await http.post(url,
          headers: headers,
          body:
              base64ToHex(encryption(body, auth.aesKey ?? '', auth.iv ?? '')));
      if (response.statusCode == 200) {
        var xdata = decryption(
            base64.encode(hex.decode(jsonDecode(response.body)['data'])),
            auth.aesKey ?? '',
            auth.iv ?? '');
        var data = List<Map<dynamic, dynamic>>.from(jsonDecode(xdata));
        staffBC.value = data;
      }
    }

    Future<void> _showMyDialog(int nextStep, String title, int score) async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text(
              'Successful',
              style: TextStyle(
                  color: Color(0xff15B77C),
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
            content: SingleChildScrollView(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                ),
                Text(
                  score.toString(),
                  style: const TextStyle(
                      color: Color(0xff15B77C),
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                )
              ],
            )),
            actions: <Widget>[
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff15B77C)),
                child: const Text(
                  'Cancel',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff15B77C)),
                child: const Text(
                  'Next Step',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  metricStep.value = nextStep;
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }

    Future<void> _showResponse(Map<dynamic, dynamic> data) async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: data['status'] == 200 ? const Text(
              'Successful',
              style: TextStyle(
                  color: Color(0xff15B77C),
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ) : const Text(
              'Unsuccessful',
              style: TextStyle(
                  color: Color(0xff15B77C),
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
            content: SingleChildScrollView(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  data['message_description'],
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                ),
              ],
            )),
            actions: <Widget>[
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff15B77C)),
                child: const Text(
                  'Cancel',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  metricStep.value = null;
                  Navigator.of(context).pop();
                  active.value = false;
                },
              ),
            ],
          );
        },
      );
    }

    List<Map<String, String>> dummyDownlines = [
      {
        "name": "peter ojo",
        "ref": "402795845",
        "desc": "Quality Assurance Officer",
        "bu": "Lagos"
      },
      {
        "name": "john ojo",
        "ref": "4ffwfffwf5",
        "desc": "Project Manager",
        "bu": "Lagos"
      },
      {
        "name": "nina ojo",
        "ref": "54767857465",
        "desc": "Data Entry Officer",
        "bu": "Benin"
      },
      {
        "name": "juliet ojo",
        "ref": "7489754985",
        "desc": "Data Analyst",
        "bu": "benin"
      }
    ];

    void calculateKpiSum() {
      // var sum = totalKpi.value * 0.10 * 2;
      // totalKpi.value = sum.toInt();
      _showMyDialog(1, 'Total KPI Score', totalKpi.value);
    }

    void calculateBCSum() {
      var sum = totalBC.value * 0.10 * 2;
      totalBC.value = sum.toInt();
      int nextStep = appraiser == 'Self' ? 3 : 2;
      _showMyDialog(
          nextStep, 'Total Behavioral Competencies Score', totalBC.value);
    }

    void submitAppraisl() async {
      Uri url = Uri.parse(
          'https://e360.lapo-nigeria.org/perfomance/poastappraisalevaluation');
      var token = jsonEncode({
        'tk': auth.token,
        'us': staff.userRef,
        'rl': staff.uRole,
        'src': "AS-IN-D659B-e3M"
      });
      var headers = {
        'x-lapo-eve-proc':
            base64ToHex(encryption(token, auth.aesKey ?? '', auth.iv ?? '')) +
                (auth.token ?? ''),
        'Content-type': 'text/json',
      };
      var body = jsonEncode({
        "xAppraisalEvaluationData": [...?bcObj.value, ...?kpiObj.value],
        "xRecommendedForPromotion": promRec.value == true ? '' : '',
        "xAppraisalTrainingNeedsData": re2.text,
        "xAreaOfImprovement": re1.text,
        "xAppraisalComment": re4.text,
        "xTrans": {
          "xTransScope": "129dekekddkffmf2sv25",
          "xAppTransScope": "9e9efefech009eee",
          "xAppSource": "AS-IN-D659B-e3M",
          "xTransRef": "",
          "xRecTargetSection": ""
        }
      });
      var response = await http.post(url,
          headers: headers,
          body:
              base64ToHex(encryption(body, auth.aesKey ?? '', auth.iv ?? '')));
      var data = jsonDecode(response.body);
      // print(body);
      //   print(data);
        _showResponse(data);
      // if (response.statusCode == 200) {
        // var data = jsonDecode(response.body);
        // print('success yaza!!!!!');
        // print(data);
        // _showResponse(data);
      // }
    }

    validateWM(String value, int max) {
      if (value == null || value.isEmpty) {
        return 'Please fill in the required Field';
      } else if (int.parse(value) > max) {
        return 'You cannot enter a value greater than the WM of ${max.toString()}';
      } else if (int.parse(value) < 1) {
        return 'Please enter a value greater than 0';
      }
      return null;
    }

    useEffect(() {
      getKpi();
      getBC();
      return null;
    }, []);

    useEffect(() {
      if(trans != null) {
        getSelfEvaluation();
      }

      return null;
    }, []);

    setStep(int step, String type) {
      if (type == 'KPI') {
        kpiStep.value = step;
      } else {
        currentStep.value = step;
      }
    }

    var token = jsonEncode({
      'tk': auth.token,
      'us': staff.userRef,
      'rl': staff.uRole,
      'src': "AS-IN-D659B-e3M"
    });

    var headers = {
      'x-lapo-eve-proc':
          base64ToHex(encryption(token, auth.aesKey ?? '', auth.iv ?? '')) +
              (auth.token ?? ''),
      'Content-type': 'text/json',
    };

    return Scaffold(
        appBar: appraiser == 'Superior'
            ? AppBar(
                backgroundColor: Colors.white,
                iconTheme: const IconThemeData(color: Colors.black),
              )
            : null,
        body: Container(
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(60))),
            alignment: Alignment.center,
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: active.value == false
                ? Container(
                    width: 400,
                    height: 140,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius:
                            const BorderRadius.all(Radius.circular(5))),
                    child: Column(children: [
                      Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.grey[400],
                          radius: 30,
                          backgroundImage: NetworkImage(
                            'http://10.0.0.184:8015/userservices/retrievephoto/${appraiserRef}/retrievephoto',
                            headers: headers,
                          ),
                        ),
                        Container(
                          child: Text(
                            trans?.createdBy ??
                                (staff.firstName! +
                                    " " +
                                    staff.lastName.toString()),
                            style: const TextStyle(
                                fontSize: 18, color: Colors.black),
                          ),
                        ),
                        Container(
                          width: 100,
                          height: 40,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xff15B77C)
                            ),
                            child: const Text('Appraise'),
                            onPressed: () {
                              metricStep.value = 0;
                              active.value = true;
                            },
                          ),
                        )
                      ],
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 20),
                      child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,  
                      children: [
                      Text(staff.buName.toString(), style: const TextStyle(fontSize: 18)),
                      Container(
                        padding: const EdgeInsets.all(5),
                        alignment: Alignment.center,
                        width: 100,
                        height: 30,
                        decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(4)), color: Color.fromARGB(255, 189, 189, 189),),
                        child: Text((DateTime.now().year -1).toString(), style: const TextStyle(fontSize: 18),),
                      )
                    ],),
                    )
                    ],)
                    )
                : metricStep.value == 1
                    ? BehaviouralComp(
                        staff: staff,
                        totalBC: totalBC,
                        metricStep: metricStep,
                        currentStep: bcStep,
                        setStep: setStep,
                        BCs: staffBC.value ?? [],
                        active: active,
                        calculateBCSum: calculateBCSum,
                        BCVal: BCVal,
                        bcJust: bcJust,
                        addBc: addBc,
                        bcObj: bcObj,
                        appraiserRef: appraiserRef,
                        appraiser: appraiser,
                      )
                    : metricStep.value == 0
                        ? Kpi(
                            staff: staff,
                            totalKpi: totalKpi,
                            metricStep: metricStep,
                            currentStep: kpiStep,
                            setStep: setStep,
                            kpis: staffKpi.value ?? [],
                            active: active,
                            calculateKpiSum: calculateKpiSum,
                            addKpiValue: addKpiValue,
                            kpiVal: kpiVal,
                            kpiJust: kpiJust,
                            addKpi: addKpi,
                            kpiObj: kpiObj,
                            appraiser: appraiser,
                            appraiserRef: appraiserRef,
                          )
                        : metricStep.value == 2
                            ? Recommendations(
                                staff: staff,
                                totalBC: totalBC.value,
                                totalKpi: totalKpi.value,
                                re1: re1,
                                re2: re2,
                                re3: re3,
                                promRec: promRec,
                                metricStep: metricStep,
                                re4: re4)
                            : metricStep.value == 3
                                ? Summary(
                                    staff: staff,
                                    totalBC: totalBC.value,
                                    totalKpi: totalKpi.value,
                                    ad1: ad1,
                                    ad2: ad2,
                                    ad3: ad3,
                                    appraiser: appraiser,
                                    submit: submitAppraisl,
                                    trans: trans,
                                    selfDetails: selfDetails.value,
                                  )
                                : appraiser == "other"
                                    ? ListView(
                                        children: dummyDownlines.map<Widget>(
                                            ((Map<String, String> data) {
                                          return Container(
                                              padding: const EdgeInsets.all(10),
                                              // decoration: BoxDecoration(
                                              //   color: Colors.grey[200],
                                              //   borderRadius: const BorderRadius.all(Radius.circular(8))
                                              // ),
                                              margin: const EdgeInsets.only(
                                                  top: 20),
                                              child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        const Color(0xffDFEEE9),
                                                    padding:
                                                        const EdgeInsets.all(
                                                            10)),
                                                onPressed: (() {
                                                  currentAppraiser.value =
                                                      data['ref'];
                                                  metricStep.value = 0;
                                                }),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Container(
                                                      child: Row(children: [
                                                        const CircleAvatar(
                                                          backgroundColor:
                                                              Colors.white,
                                                          radius: 30,
                                                        ),
                                                        Container(
                                                          margin:
                                                              const EdgeInsets
                                                                      .only(
                                                                  right: 20,
                                                                  left: 10),
                                                          height: 45,
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Flexible(
                                                                child: Text(
                                                                  data['name'] ??
                                                                      '',
                                                                  style: const TextStyle(
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                      fontSize:
                                                                          14,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                      color: Colors
                                                                          .black),
                                                                ),
                                                              ),
                                                              Flexible(
                                                                child: Text(
                                                                  data['desc'] ??
                                                                      '',
                                                                  style: const TextStyle(
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                      fontSize:
                                                                          14,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                      color: Colors
                                                                          .black),
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      ]),
                                                    ),
                                                    Flexible(
                                                        child: Text(
                                                      data['bu'] ?? '',
                                                      style: const TextStyle(
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: Colors.black),
                                                    )),
                                                  ],
                                                ),
                                              ));
                                        })).toList(),
                                      )
                                    : null));
  }
}
