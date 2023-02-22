import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:e_360/Models/Staff.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:e_360/Widgets/input.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Home extends HookWidget {
  dynamic switchTab;

  Home({super.key, required this.switchTab});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.only(),
      // margin: const EdgeInsets.only(bottom: 30),
      child: ListView(children: [
        Container(
          padding: const EdgeInsets.only(left: 10, right: 10, top: 15, bottom: 15),
          height: 134,
          decoration: const BoxDecoration(color: Color(0xffF9D5B5),
          borderRadius: BorderRadius.vertical(top: Radius.circular(60))
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
            Container(
              padding: const EdgeInsets.only(left: 10, right: 5, top: 10),
              child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Tip for the day', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),),
                const Text('Team work and diligence,\n promotes a healthy work \n environment.', style: TextStyle(fontSize: 11),),
                SizedBox(
                  height: 20,
                  width: 100,
                  child: Material(
                  // color: const Color(0xffEF9545),
                  color: Colors.grey[400],
                  borderRadius: BorderRadius.circular(10),
                  child: MaterialButton(
                    onPressed: (){}, child: const Text('Learn more', style: TextStyle(fontSize: 10, color: Colors.white),),
                ),),
                )
              ],
            ),
            ),
            Container(
              child: SvgPicture.asset('images/onboarding.svg', width: 110, height: 120),
            )
          ]),
        ),

        Container(
          margin: const EdgeInsets.only(top: 30),
          padding: const EdgeInsets.only(left: 10, right: 10, top: 15, bottom: 15),
          height: 94,
          decoration: const BoxDecoration(color: Color(0xffCCEBDB),
          borderRadius: BorderRadius.all(Radius.circular(5)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
              const Text('Core Value for the month', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              const Text('Passion and Commitment.', style: TextStyle(fontSize: 11)),
              SizedBox(
                  height: 20,
                  width: 100,
                  child: Material(
                  // color: const Color(0xff2BAD6A),
                  color: Colors.grey[400],
                  borderRadius: BorderRadius.circular(10),
                  child: MaterialButton(
                    onPressed: (){}, child: const Text('Learn more', style: TextStyle(fontSize: 10, color: Colors.white),),
                ),),
                ),
            ],),
            Image.asset('images/ants.png', width: 100, height: 100,)
          ]),
        ),
        Container(
          margin: const EdgeInsets.only(top: 10),
                  child: Column(children: [
                    Container(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                      const Text('Recent Activities', style: TextStyle(fontWeight: FontWeight.bold),),
                      TextButton(onPressed: (){
                        switchTab(5);
                      }, child: const Text('See all')),
                    ],),
                    ),
                    Container(
                      padding: const EdgeInsets.only(left: 10, right: 10, top: 15, bottom: 15),
                      height: 72,
                      decoration: BoxDecoration(image: DecorationImage(image: const AssetImage('images/books.png'), fit: BoxFit.cover, colorFilter: ColorFilter.mode(Colors.black.withOpacity(1), BlendMode.dstATop),)),
                      child: Align(alignment: Alignment.centerLeft,child: Material(
                  color: const Color(0xff2BAD6A),
                  borderRadius: BorderRadius.circular(10),
                  child: SizedBox(
                  height: 20,
                  width: 140,
                  child: Material(
                  color: const Color(0xff2BAD6A),
                  borderRadius: BorderRadius.circular(10),
                  child: MaterialButton(
                    onPressed: (){
                      switchTab(5);
                    }, child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const[
                      Text('Check Leave Status', style: TextStyle(fontSize: 10, color: Colors.white),),
                      Icon(Icons.east,size: 15, color: Colors.white,)
                    ]),
                ),),
                ),),),
                )
                  ]),
                ),

                Container(
                  margin: const EdgeInsets.only(top: 20),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start,children: [
                  const Padding(padding: EdgeInsets.only(left: 10), child: Text('Upcoming Events',style: TextStyle(fontWeight: FontWeight.bold),),),
                  Container(
                    margin: const EdgeInsets.only(top: 14),
                    height: 148,
                    decoration: const BoxDecoration(color: Color(0xffE4E9E5), borderRadius: BorderRadius.all(Radius.circular(5))),
                    child: Padding(padding: const EdgeInsets.only(left: 10, right: 10, top: 10), child: Column(children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                    Column(
                      children: [
                        Material(
                          elevation: 10,
                          child: Container(
                            height: 68,
                            width: 100,
                            child: Image.asset('images/express.png', fit: BoxFit.contain),
                          ),
                        ),
                        Container(
                          width: 100,
                          color: Colors.white,
                          child: const Text('X-press Raffle Draw', style: TextStyle(fontSize: 10),),
                        )
                    ],),

                    Column(
                      children: [
                        Material(
                          elevation: 10,
                          child: Container(
                            height: 68,
                            width: 100,
                            child: Image.asset('images/carol.png', fit: BoxFit.contain),
                          ),
                        ),
                        Container(
                          width: 100,
                          color: Colors.white,
                          child: const Text('Christmas Carol', style: TextStyle(fontSize: 10),),
                        )
                    ],),

                    Column(
                      children: [
                        Material(
                          elevation: 10,
                          child: Container(
                            height: 68,
                            width: 100,
                            child: Image.asset('images/football.png', fit: BoxFit.contain),
                          ),
                        ),
                        Container(
                          width: 100,
                          color: Colors.white,
                          child: const Text('Football Competition', style: TextStyle(fontSize: 10),),
                        )
                    ],)
                  ]),
                  Container(
                    margin: const EdgeInsets.only(top: 20),
                    child: Align(
                    alignment: Alignment.bottomLeft,
                    child: SizedBox(
                  height: 20,
                  width: 100,
                  child: Material(
                  // color: const Color(0xff2BAD6A),
                  color: Colors.grey[400],
                  borderRadius: BorderRadius.circular(10),
                  child: MaterialButton(
                    onPressed: (){}, child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const[
                      Text('View all', style: TextStyle(fontSize: 10, color: Colors.white),),
                      Icon(Icons.east,size: 15, color: Colors.white,)
                    ]),
                ),),
                ),
                  ),
                  )
                    ],)),),
                  
                ]),)
      ]),
    );
  }
}