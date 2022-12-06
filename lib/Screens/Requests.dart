import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:e_360/Models/Staff.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:e_360/Widgets/input.dart';

class Requests extends HookWidget {
  final Staff staff;
  final Map<String, dynamic> info;
  Requests({super.key, required this.staff, required this.info});

  Future<void> getLeaveTypes() async {
    Uri url = Uri.parse('http://10.0.0.184:8015/requisition/leave/leavetypes');
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
    var response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      return jsonDecode(response.body)['data'];
    }
  }

  static final _formKey = GlobalKey<FormState>(debugLabel: '');

  @override
  Widget build(BuildContext context) {
    final leaveType = useState<String>('Annual Leave');
    final payLtg = useState<bool>(false);

    final _deputizingOfficerController = useTextEditingController();
    final _startDateController = useTextEditingController();
    final _endDateController = useTextEditingController();
    final _resumptionDateController = useTextEditingController();
    final _mobileController = useTextEditingController();
    final _emailController = useTextEditingController();
    final _addressController = useTextEditingController();

    final startDate = useState<DateTime>(DateTime.now());

    final endDate = useState<DateTime>(DateTime.now());

    final resumptionDate = useState<DateTime>(DateTime.now());

    final setLoading = useState<bool>(false);

    Future<void> _selectStartDate(BuildContext context) async {
      final DateTime? picked = await showDatePicker(
          context: context,
          initialDate: startDate.value,
          firstDate: DateTime(2015, 8),
          lastDate: DateTime(2101));
      if (picked != null && picked != startDate.value) {
        startDate.value = picked;
      }
    }

    Future<void> _selectResumptiontDate(BuildContext context) async {
      final DateTime? picked = await showDatePicker(
          context: context,
          initialDate: resumptionDate.value,
          firstDate: DateTime(2015, 8),
          lastDate: DateTime(2101));
      if (picked != null && picked != resumptionDate.value) {
        resumptionDate.value = picked;
      }
    }

    Future<void> _selectEndDate(BuildContext context) async {
      final DateTime? picked = await showDatePicker(
          context: context,
          initialDate: endDate.value,
          firstDate: DateTime(2015, 8),
          lastDate: DateTime(2101));
      if (picked != null && picked != endDate.value) {
        endDate.value = picked;
      }
    }

    validateField(String value) {
      if (value == null || value.isEmpty) {
        return 'Please enter a username';
      }
      return null;
    }

    getCurrentDate(String type) {
      var date = type == 'start' ? startDate.toString() : endDate.toString();

      var dateParse = DateTime.parse(date);

      var formattedDate = "${dateParse.day}";

      return formattedDate;
    }

    void submit() {
      setLoading.value = !setLoading.value;
    }

    return Container(
      color: Colors.white,
      child: ListView(children: [
        Container(
          margin: const EdgeInsets.only(top: 5, bottom: 20, left: 20),
          child: const Text(
            'Requisition Details',
            style: TextStyle(color: Color(0xff88A59A)),
          ),
        ),
        Container(
          child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Container(
                      width: MediaQuery.of(context).size.width,
                      height: 130,
                      color: const Color(0xffD6EBE3),
                      child: FutureBuilder(
                        future: getLeaveTypes(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            if (snapshot.hasError) {
                              return const Text('An error occured');
                            } else if (snapshot.hasData) {
                              List<dynamic> data =
                                  snapshot.data as List<dynamic>;

                              return Container(
                                margin: const EdgeInsets.only(
                                    top: 40, left: 20, bottom: 20, right: 70),
                                width: 100,
                                height: 40,
                                child: DropdownButtonFormField(
                                  decoration: const InputDecoration(
                                    fillColor: Colors.white,
                                    filled: true,
                                    border: OutlineInputBorder(
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(10.0),
                                      ),
                                    ),
                                  ),
                                  value: leaveType.value,
                                  icon: const Icon(Icons.keyboard_arrow_down),
                                  items: data.map<DropdownMenuItem>((item) {
                                    return DropdownMenuItem(
                                      child: Text(item['Item']),
                                      value: item['Item'],
                                    );
                                  }).toList(),
                                  onChanged: (item) {
                                    leaveType.value = item!;
                                  },
                                ),
                              );
                            }
                          }
                          return Container();
                        },
                      )),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 10, top: 20, bottom: 30, right: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(bottom: 20),
                          child: const Text('Leave transport grant',
                              style: TextStyle(
                                  color: Color(0xff88A59A),
                                  fontWeight: FontWeight.bold)),
                        ),
                        const Text(
                            'Indicate whether or not you want your LTG paid in this requisition'),
                        Row(
                          children: [
                            const Text('Pay LTG ?'),
                            Container(
                                margin: const EdgeInsets.only(left: 20),
                                child: SizedBox(
                                  width: 100,
                                  height: 70,
                                  child: FittedBox(
                                    fit: BoxFit.fill,
                                    child: Switch(
                                      value: payLtg.value,
                                      onChanged: (bool value) {
                                        payLtg.value = value;
                                      },
                                      activeColor: const Color(0xff15B77C),
                                      activeTrackColor: const Color(0xffD6EBE3),
                                      inactiveThumbColor:
                                          const Color(0xffD6EBE3),
                                      inactiveTrackColor:
                                          const Color(0xffD9D9D9),
                                    ),
                                  ),
                                ))
                          ],
                        ),
                        Container(
                          margin: const EdgeInsets.only(bottom: 10, top: 10),
                          child: const Divider(
                              color: Color(0xffD6EBE3),
                              height: 1,
                              thickness: 2),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 10, bottom: 10),
                          child: CustomInput(
                            controller: _deputizingOfficerController,
                            validation: validateField,
                            hintText: 'Deputizing Officer',
                            prefixIcon: const Icon(Icons.assignment_ind,
                                color: Color(0xffF88A4C)),
                          ),
                        ),
                        Container(
                          child: const Text(
                              'Select a leave deputizing officer. This staff should be within your reporting line'),
                        ),
                        Container(
                          margin: const EdgeInsets.only(bottom: 10, top: 15),
                          child: const Divider(
                              color: Color(0xffD6EBE3),
                              height: 1,
                              thickness: 2),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 10),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                    child: Padding(
                                        padding:
                                            const EdgeInsets.only(right: 10),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                                margin: const EdgeInsets.only(
                                                    bottom: 5),
                                                decoration: const BoxDecoration(
                                                    color: Color(0xffDFEEE9),
                                                    border: Border(
                                                        bottom: BorderSide(
                                                            color: Color(
                                                                0xff15B77C),
                                                            width: 3))),
                                                child: SizedBox(
                                                  height: 50,
                                                  child: ListTile(
                                                    leading: const Icon(
                                                      Icons.today,
                                                      color: Color(0xffF88A4C),
                                                    ),
                                                    title: Text(
                                                        DateTime.parse(startDate
                                                                .value
                                                                .toString())
                                                            .toString()
                                                            .split(" ")[0],
                                                        style: const TextStyle(
                                                            fontSize: 14)),
                                                    onTap: () =>
                                                        _selectStartDate(
                                                            context),
                                                  ),
                                                )),
                                            const Text('Start Date')
                                          ],
                                        ))),
                                Expanded(
                                    child: Padding(
                                        padding:
                                            const EdgeInsets.only(left: 10),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                                margin: const EdgeInsets.only(
                                                    bottom: 5),
                                                decoration: const BoxDecoration(
                                                    color: Color(0xffDFEEE9),
                                                    border: Border(
                                                        bottom: BorderSide(
                                                            color: Color(
                                                                0xff15B77C),
                                                            width: 3))),
                                                child: SizedBox(
                                                  height: 50,
                                                  child: ListTile(
                                                    leading: const Icon(
                                                      Icons.today,
                                                      color: Color(0xffF88A4C),
                                                    ),
                                                    title: Text(
                                                      DateTime.parse(endDate
                                                              .value
                                                              .toString())
                                                          .toString()
                                                          .split(" ")[0],
                                                      style: const TextStyle(
                                                          fontSize: 14),
                                                    ),
                                                    onTap: () =>
                                                        _selectEndDate(context),
                                                  ),
                                                )),
                                            const Text('End Date')
                                          ],
                                        )))
                              ]),
                        ),
                        Container(
                            margin: const EdgeInsets.only(top: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                    margin: const EdgeInsets.only(bottom: 5),
                                    decoration: const BoxDecoration(
                                        color: Color(0xffDFEEE9),
                                        border: Border(
                                            bottom: BorderSide(
                                                color: Color(0xff15B77C),
                                                width: 3))),
                                    child: SizedBox(
                                      height: 50,
                                      child: ListTile(
                                        leading: const Icon(
                                          Icons.today,
                                          color: Color(0xffF88A4C),
                                        ),
                                        title: Text(
                                            DateTime.parse(resumptionDate.value
                                                    .toString())
                                                .toString()
                                                .split(" ")[0],
                                            style:
                                                const TextStyle(fontSize: 14)),
                                        onTap: () =>
                                            _selectResumptiontDate(context),
                                      ),
                                    )),
                                const Text('Resumption Date')
                              ],
                            )),
                        Container(
                          margin: const EdgeInsets.only(bottom: 10, top: 15),
                          child: const Divider(
                              color: Color(0xffD6EBE3),
                              height: 1,
                              thickness: 2),
                        ),
                        Container(
                          height: 130,
                          margin: const EdgeInsets.only(top: 10),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              // mainAxisSize: MainAxisSize.max,
                              children: [
                                CustomInput(
                                  controller: _mobileController,
                                  validation: validateField,
                                  hintText: 'Mobile during leave',
                                  prefixIcon: const Icon(Icons.call,
                                      color: Color(0xffF88A4C)),
                                ),
                                CustomInput(
                                  controller: _emailController,
                                  validation: validateField,
                                  hintText: 'Email during leave',
                                  prefixIcon: const Icon(Icons.email,
                                      color: Color(0xffF88A4C)),
                                ),
                              ]),
                        )
                      ],
                    ),
                  )
                ],
              )),
        ),
        Padding(
            padding: const EdgeInsets.only(left: 10, right: 10, bottom: 20),
            child: SizedBox(
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff15B77C),
                  ),
                  onPressed: () {
                    submit();
                  },
                  child: setLoading.value != true
                      ? const Text(
                          'Submit',
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        )
                      : CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 5,
                        )),
              height: 60,
            ))
      ]),
    );
  }
}
