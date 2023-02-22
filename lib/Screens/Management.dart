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
  Management({super.key, required this.staff, required this.info});

  bool isAppraiser = true;
  bool active = false;

  MaterialColor colorCustom = MaterialColor(0xff15B77C, color);

  // final kp1 = TextEditingController();
  // final kp2 = TextEditingController();
  // final kp3 = TextEditingController();
  // final kp4 = TextEditingController();
  // final kp5 = TextEditingController();
  // final kp6 = TextEditingController();
  // final kp7 = TextEditingController();

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

    final active = useState<bool>(false);
    final currentStep = useState<int>(0);
    final valueOne = useState<int>(0);
    final valueTwo = useState<int>(0);
    final valueThree = useState<int>(0);
    final valueFour = useState<int>(0);
    final valueFive = useState<int>(0);
    final appraiser = useState<String?>(null);
    final downlines = useState<List<dynamic>?>(null);
    final metricStep = useState<int?>(null);
    final totalKpi = useState<int?>(null);
    final totalBC = useState<int?>(null);

    final kpi1 = useState<int>(0);
    final kpi2 = useState<int>(0);
    final kpi3 = useState<int>(0);
    final kpi4 = useState<int>(0);
    final kpi5 = useState<int>(0);
    final kpiStep = useState<int>(0);

    final currentAppraiser = useState<String?>(null);

    final _formKey = GlobalKey<FormState>(debugLabel: '');

    Future<void> getKpi() async {
    Uri url = Uri.parse(
        'http://10.0.0.184:8015/perfomance/listappraisalkpis');
    var token = jsonEncode({
      'tk': auth.token,
      'us': staff.userRef,
      'rl': staff.uRole,
      'src': "AS-IN-D659B-e3M"
    });
    var headers = {
      'x-lapo-eve-proc': base64ToHex(encryption(token, auth.aesKey ?? '', auth.iv ?? '')) + (auth.token ?? ''),
      'Content-type': 'text/json',
    };
    var body = jsonEncode({
      'tk': auth.token,
      'us': staff.userRef,
      'rl': staff.uRole,
      'src': "AS-IN-D659B-e3M"
    });
    var response =
        await http.post(url, headers: headers, body: base64ToHex(encryption(body, auth.aesKey ?? '', auth.iv ?? '')));
    print(response.body);
    if (response.statusCode == 200) {
      var xdata = decryption(base64.encode(hex.decode(jsonDecode(response.body)['data'])), auth.aesKey ?? '', auth.iv ?? '');
      var data =
          Map<dynamic, dynamic>.from(jsonDecode(xdata));
      // setState(() {
      //   utilDetails = data;
      // });
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

    // void calculateKpiSum() {
    //   var total = int.parse(kp1.text) +
    //       int.parse(kp2.text) +
    //       int.parse(kp3.text) +
    //       int.parse(kp4.text) +
    //       int.parse(kp5.text) +
    //       int.parse(kp6.text) +
    //       int.parse(kp7.text);
    //   totalKpi.value = total;
    //   _showMyDialog(1, 'Total KPI Score', totalKpi.value as int);
    // }

    void calculateKpiSum() {
      var sum = kpi1.value +
          kpi2.value +
          kpi3.value +
          kpi4.value +
          kpi5.value;
      var total = sum * 0.10 * 2;
      totalKpi.value = total.toInt();
      _showMyDialog(
          1, 'Total KPI Score', totalKpi.value as int);
    }

    void calculateBCSum() {
      var sum = valueOne.value +
          valueTwo.value +
          valueThree.value +
          valueFour.value +
          valueFive.value;
      var total = sum * 0.10 * 2;
      totalBC.value = total.toInt();
      _showMyDialog(
          2, 'Total Behavioral Competencies Score', totalBC.value as int);
    }

    void getDownline() async {
      Uri url = Uri.parse("http://10.0.0.184:8015/userservices/mydownline");
      var token = {
        'br':
            "66006500390034006200650036003400390065006500630063006400380063006600330062003200300030006200630061003300330062003300640030006300",
        'us': staff.userRef,
        'rl': staff.uRole
      };
      var headers = {
        'x-lapo-eve-proc': jsonEncode(token),
        'Content-type': 'text/json',
      };
      var result = await http.get(url, headers: headers);
      if (result.statusCode == 200) {
        var data = jsonDecode(result.body)['data'];
        List<dynamic> downlineData = List<dynamic>.from(data);
        print(data);
        downlines.value = downlineData;
      }
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
      getDownline();
      getKpi();
    }, []);

    setStep(int step, String type) {
      if(type == 'KPI') {
        kpiStep.value = step;
      }
      else {
        currentStep.value = step;
      }
    }

    handleDrag(int index, int value) {
      switch (index) {
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
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(60))),
        alignment: Alignment.center,
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: active.value == false
            ? Container(
                width: 400,
                height: 200,
                child: Card(
                    // color: const Color(0xffD6EBE3),
                    color: Colors.grey[200],
                    margin: const EdgeInsets.all(30),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        const Text(
                          'Begin new Appraisal',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        Container(
                          padding: const EdgeInsets.only(left: 30, right: 30),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width: 100,
                                  height: 40,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      active.value = true;
                                      appraiser.value = 'self';
                                      metricStep.value = 0;
                                    },
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            const Color(0xff15B77C)),
                                    child: const Text('Self'),
                                  ),
                                ),
                                SizedBox(
                                  width: 100,
                                  height: 40,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      active.value = true;
                                      appraiser.value = 'other';
                                      // metricStep.value = 0;
                                    },
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            const Color(0xff15B77C)),
                                    child: const Text('Downliner'),
                                  ),
                                )
                              ]),
                        )
                      ],
                    )),
              )
            : metricStep.value == 1
                ? BehaviouralComp(
                    staff: staff,
                    totalBC: totalBC,
                    metricStep: metricStep,
                    currentStep: currentStep,
                    setStep: setStep,
                    valueOne: valueOne,
                    valueTwo: valueTwo,
                    valueThree: valueThree,
                    valueFour: valueFour,
                    valueFive: valueFive,
                    calculateBCSum: calculateBCSum)
                : metricStep.value == 0
                    ? Kpi(
                        // staff: staff,
                        // totalBC: totalBC.value ?? 0,
                        // totalKpi: totalKpi.value ?? 0,
                        // kp1: kp1,
                        // kp2: kp2,
                        // kp3: kp3,
                        // metricStep: metricStep,
                        // kp4: kp4,
                        // validateWM: validateWM,
                        // kp5: kp5,
                        // kp6: kp6,
                        // kp7: kp7,
                        // calculateKpiSum: calculateKpiSum
                        staff: staff,
                    totalKpi: totalKpi,
                    metricStep: metricStep,
                    currentStep: kpiStep,
                    setStep: setStep,
                    kpi1: kpi1,
                    kpi2: kpi2,
                    kpi3: kpi3,
                    kpi4: kpi4,
                    kpi5: kpi5,
                    calculateKpiSum: calculateKpiSum
                        )
                    : metricStep.value == 2
                        ? Recommendations(
                            staff: staff,
                            totalBC: totalBC.value ?? 0,
                            totalKpi: totalKpi.value ?? 0,
                            re1: re1,
                            re2: re2,
                            re3: re3,
                            metricStep: metricStep,
                            re4: re4)
                        : metricStep.value == 3
                            ? Summary(
                                staff: staff,
                                totalBC: totalBC.value ?? 0,
                                totalKpi: totalKpi.value ?? 0,
                                ad1: ad1,
                                ad2: ad2,
                                ad3: ad3,
                                appraiser: appraiser
                                )
                            : appraiser.value == "other"
                                ? ListView(
                                    children: dummyDownlines.map<Widget>(
                                        ((Map<String, String> data) {
                                      return Container(
                                          padding: const EdgeInsets.all(10),
                                          // decoration: BoxDecoration(
                                          //   color: Colors.grey[200],
                                          //   borderRadius: const BorderRadius.all(Radius.circular(8))
                                          // ),
                                          margin:
                                              const EdgeInsets.only(top: 20),
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xffDFEEE9), padding: const EdgeInsets.all(10)),
                                            onPressed: (() {
                                              currentAppraiser.value = data['ref'];
                                              metricStep.value = 0;
                                            }),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Container(
                                                  child: Row(children: [
                                                    const CircleAvatar(
                                                  backgroundColor: Colors.white,
                                                  radius: 30,
                                                ),
                                                Container(
                                                  margin: const EdgeInsets.only(
                                                      right: 20,left: 10),
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
                                                          data['name'] ?? '',
                                                          style: const TextStyle(
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                                    color: Colors.black  
                                                                    ),
                                                        ),
                                                      ),
                                                      Flexible(
                                                        child: Text(
                                                          data['desc'] ?? '',
                                                          style: const TextStyle(
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                                      color: Colors.black  
                                                                      ),
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
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                          color: Colors.black  
                                                          ),
                                                )),
                                              ],
                                            ),
                                          ));
                                    })).toList(),
                                  )
                                : null);
  }
}
