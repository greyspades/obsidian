import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:e_360/Models/Staff.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:e_360/Widgets/input.dart';
import 'package:e_360/Models/DepOfficer.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class CustomSlider extends HookWidget {
  double value;

  dynamic onChange;

  dynamic next;

  dynamic prev;

  String name;

  CustomSlider(
      {super.key,
      required this.value,
      required this.onChange,
      required this.next,
      required this.prev,
      required this.name});

  @override
  Widget build(BuildContext context) {
    final rangeValue = useState<double>(2);

    return Container(
      // height: 190,
      child: Card(
          color: Colors.grey[200],
          child: Container(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                Container(
                    alignment: Alignment.center,
                    child: Text(
                      name,
                      style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          height: 1.5),
                    )),
                // Container(
                //   width: 60,
                //   decoration: const BoxDecoration(
                //       borderRadius: BorderRadius.all(Radius.circular(10)),
                //       color: Color(0xff15B77C)),
                //   alignment: Alignment.center,
                //   margin: const EdgeInsets.all(20),
                //   child: Text(
                //     value.toString(),
                //     style: const TextStyle(
                //         color: Colors.white,
                //         fontSize: 18,
                //         fontWeight: FontWeight.bold),
                //   ),
                // ),

                Container(
                  height: 200,
                  child: SfRadialGauge(
          axes: <RadialAxis>[
            RadialAxis(minimum: 0, maximum: 11,

            ranges: [
              GaugeRange(startValue: 0, endValue: 4, color: const Color(0xffD6EBE3),startWidth: 0.06, sizeUnit: GaugeSizeUnit.factor,
              endWidth: 0.06),
              GaugeRange(startValue: 4,endValue: 7,color:const Color(0xff6BDCB1),startWidth: 0.06, sizeUnit: GaugeSizeUnit.factor,
              endWidth: 0.06),
              GaugeRange(startValue: 7,endValue: 11,color: const Color(0xff15B77C),startWidth: 0.06, sizeUnit: GaugeSizeUnit.factor,
              endWidth: 0.06)],
            pointers: <GaugePointer>[
              MarkerPointer(value: rangeValue.value,
              color: const Color(0xffFEB388),
              enableAnimation: true,
              enableDragging: true,
              markerHeight: 20,
              markerWidth: 20,
              overlayColor: Color.fromARGB(126, 221, 133, 2,),
              borderColor: Color.fromARGB(126, 221, 133, 2,),
              borderWidth: 1,
              overlayRadius: 5,
              onValueChanged: (value) => rangeValue.value = value,
              )],
            annotations: <GaugeAnnotation>[
              GaugeAnnotation(widget: Container(child: 
                 Text(rangeValue.value.toInt().toString(),style: const TextStyle(fontSize: 25,fontWeight: FontWeight.bold))),
                 angle: 90, positionFactor: 0.5
              )]
          )]),
                )

                // Row(
                //   crossAxisAlignment: CrossAxisAlignment.center,
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: [
                //     const Text(
                //       '1',
                //       style:
                //           TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                //     ),
                //     SizedBox(
                //       width: 200,
                //       child: Slider(
                //         thumbColor: const Color.fromRGBO(21, 183, 124, 1),
                //         activeColor: const Color(0xffD6EBE3),
                //         divisions: 3,
                //         inactiveColor: Colors.grey[300],
                //         value: value,
                //         onChanged: (value) => onChange(value),
                //         min: 0,
                //         max: 10,
                //       ),
                //     ),
                //     const Text(
                //       '10',
                //       style:
                //           TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                //     ),
                //   ],
                // ),
                // Container(
                //   height: 40,
                //   child: Padding(child: Row(
                //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: [
                //   ElevatedButton(style:ElevatedButton.styleFrom(backgroundColor: const Color(0xffD6EBE3)),onPressed: () =>next(), child: const Text('Prev', style: TextStyle(fontSize: 14, color: Colors.black),)),
                //   ElevatedButton(style:ElevatedButton.styleFrom(backgroundColor: const Color(0xffD6EBE3)),onPressed: () =>next(), child: const Text('Next', style: TextStyle(fontSize: 14, color: Colors.black),))
                // ],),
                // padding: const EdgeInsets.only(left: 100, right: 5, top: 10),
                // ),)
              ],
            ),
          )),
    );
  }
}
