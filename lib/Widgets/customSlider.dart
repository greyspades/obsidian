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

  dynamic? next;

  dynamic? prev;

  String? name;

  num max;

  CustomSlider(
      {super.key,
      required this.value,
      required this.onChange,
      this.next,
      this.prev,
      this.name,
      required this.max
      });

  @override
  Widget build(BuildContext context) {

    return Container(
      child: Card(
          color: Colors.grey[200],
          child: Container(
            padding: const EdgeInsets.all(5),
            child: Column(
              children: [
                Container(
                    alignment: Alignment.center,
                    child: Text(
                      name ?? '',
                      style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          height: 1.5),
                    )),
                Container(
                  height: 230,
                  child: SfRadialGauge(
          axes: <RadialAxis>[
            RadialAxis(minimum: 0, maximum: max + 1,

            ranges: [
              GaugeRange(startValue: 0, endValue: 4, color: const Color(0xffD6EBE3),startWidth: 0.06, sizeUnit: GaugeSizeUnit.factor,
              endWidth: 0.06),
              GaugeRange(startValue: 4,endValue: 7,color:const Color(0xff6BDCB1),startWidth: 0.06, sizeUnit: GaugeSizeUnit.factor,
              endWidth: 0.06),
              GaugeRange(startValue: 7,endValue: 11,color: const Color(0xff15B77C),startWidth: 0.06, sizeUnit: GaugeSizeUnit.factor,
              endWidth: 0.06)],

            pointers: <GaugePointer>[
              MarkerPointer(value: value,
              color: const Color(0xffFEB388),

              enableAnimation: true,
              enableDragging: true,
              markerHeight: 20,
              markerWidth: 20,
              overlayColor: Color.fromARGB(126, 221, 133, 2,),
              borderColor: Color.fromARGB(126, 221, 133, 2,),
              borderWidth: 1,
              overlayRadius: 5,
              onValueChanged: onChange
              )],

            annotations: <GaugeAnnotation>[
              GaugeAnnotation(widget: Container(child: 
                 Text(value.toInt().toString(),style: const TextStyle(fontSize: 25,fontWeight: FontWeight.bold))),
                 angle: 90, positionFactor: 0.5
              )]
          )]),
                )
              ],
            ),
          )),
    );
  }
}
