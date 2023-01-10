import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:e_360/Models/Staff.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:e_360/Widgets/input.dart';
import 'package:e_360/Models/DepOfficer.dart';
import 'package:e_360/Models/Transaction.dart';


class Transactions extends StatefulWidget {
  Staff staff;
  Map<dynamic, dynamic> info;
  List<Transaction>? transactions;
  Transactions({super.key, required this.staff, required this.info, required this.transactions});

  @override

  State<Transactions> createState() => TransactionState();
}



class TransactionState extends State<Transactions> {

  @override 
  Widget build(BuildContext context) {

    return SingleChildScrollView(
      child: Container(
        color: Colors.white,
        height: MediaQuery.of(context).size.height,
        child: widget.transactions != null ? Container(
        child: ExpansionPanelList(
          expansionCallback: (int index, bool isExpanded) {
            setState(() {
              widget.transactions?[index].isExpanded = !isExpanded;
            });
      },
      children: widget.transactions!.map<ExpansionPanel>((Transaction trans) {
        return ExpansionPanel(headerBuilder: ((context, isExpanded) {
          // return Container();
          return ListTile(
                  title: Text(trans.itemCode.toString(), style: const TextStyle(overflow: TextOverflow.ellipsis),),
                  leading: Text(trans.itemName.toString()),
                  trailing: trans.xTransStatus == 'Pending' ? const Icon(Icons.pending, color: Color(0xff15B77C),) : const Icon(Icons.check_circle, color: Color(0xff15B77C),)
                );
        }), body: Container(
                height: 250,
                padding: const EdgeInsets.all(10),
                color: Colors.grey[200],
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [const Text('Initiated By', style: TextStyle(),), Text(trans.fullName.toString(), style: TextStyle(),)],),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [const Text('Description', style: TextStyle(),), Text(trans.titleDesc.toString(), style: TextStyle(),)],),
                     Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [const Text('Originating Bu', style: TextStyle(),), Text(trans.buName.toString(), style: TextStyle(),)],),
                     Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [const Text('Time Stamp', style: TextStyle(),), Text(trans.timeStamp.toString(), style: TextStyle(),)],),
                     Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [const Text('Approval Stage', style: TextStyle(),), Text(trans.xStageNo.toString(), style: TextStyle(),)],),
                     Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [const Text('Stage Status', style: TextStyle(),), Text(trans.xStageStatus.toString(), style: TextStyle(),)],),
                     Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [const Text('Record State', style: TextStyle(),), Text(trans.xRecordState.toString(), style: TextStyle(),)],),
                     Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [const Text('Transaction Status', style: TextStyle(),), Text(trans.xTransStatus.toString(), style: TextStyle(),)],),
                     Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [const Text('Assigned To', style: TextStyle(),), Text(trans.xAssignTo.toString(), style: TextStyle(),)],),
                     Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [const Text('Reviewed By', style: TextStyle(),), Text(trans.tReviewer.toString(), style: TextStyle(),)],)
                ]),
              ),
               isExpanded: trans.isExpanded as bool
        );
      }).toList(),
        ),
      ) : null
      ),
    );

    // return Container(
    //   child: Container(
    //       // width: MediaQuery.of(context).size.width,
    //       // height: 800,
    //       child: widget.transactions != null ? Expanded(child: ListView(children: [
    //         Container(
    //           child: ExpansionPanelList(
    //         expansionCallback: (int index, bool isExpanded) {
    //         setState(() {
    //           widget.transactions?[index].isExpanded = !isExpanded;
    //         });
    //   },
    //         children: widget.transactions!.map<ExpansionPanel>((Transaction trans) {
    //           return ExpansionPanel(
    //             headerBuilder: (context, isExpanded) {
    //             return ListTile(
    //               title: Flexible(child: Text(trans.itemCode.toString(), style: const TextStyle(overflow: TextOverflow.ellipsis),),),
    //               leading: Text(trans.itemName.toString()),
    //               trailing: trans.xTransStatus == 'Pending' ? const Icon(Icons.pending, color: Color(0xff15B77C),) : const Icon(Icons.check_circle, color: Color(0xff15B77C),)
    //             );
    //           },
    //           body: Container(
    //             height: 250,
    //             padding: const EdgeInsets.all(10),
    //             color: Colors.grey[200],
    //             // child: Column(
    //             //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //             //   crossAxisAlignment: CrossAxisAlignment.start,
    //             //   children: [
    //             //   Row(
    //             //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //             //     children: [const Text('Initiated By', style: TextStyle(),), Text(trans.fullName.toString(), style: TextStyle(),)],),
    //             //   Row(
    //             //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //             //     children: [const Text('Description', style: TextStyle(),), Text(trans.titleDesc.toString(), style: TextStyle(),)],),
    //             //      Row(
    //             //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //             //     children: [const Text('Originating Bu', style: TextStyle(),), Text(trans.buName.toString(), style: TextStyle(),)],),
    //             //      Row(
    //             //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //             //     children: [const Text('Time Stamp', style: TextStyle(),), Text(trans.timeStamp.toString(), style: TextStyle(),)],),
    //             //      Row(
    //             //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //             //     children: [const Text('Approval Stage', style: TextStyle(),), Text(trans.xStageNo.toString(), style: TextStyle(),)],),
    //             //      Row(
    //             //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //             //     children: [const Text('Stage Status', style: TextStyle(),), Text(trans.xStageStatus.toString(), style: TextStyle(),)],),
    //             //      Row(
    //             //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //             //     children: [const Text('Record State', style: TextStyle(),), Text(trans.xRecordState.toString(), style: TextStyle(),)],),
    //             //      Row(
    //             //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //             //     children: [const Text('Transaction Status', style: TextStyle(),), Text(trans.xTransStatus.toString(), style: TextStyle(),)],),
    //             //      Row(
    //             //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //             //     children: [const Text('Assigned To', style: TextStyle(),), Text(trans.xAssignTo.toString(), style: TextStyle(),)],),
    //             //      Row(
    //             //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //             //     children: [const Text('Reviewed By', style: TextStyle(),), Text(trans.tReviewer.toString(), style: TextStyle(),)],)
    //             // ]),
    //           ),
    //           isExpanded: trans.isExpanded as bool
    //           );
    //         }).toList(),
    //         ),
    //         )
    //       ],)) : null
    //     ),
    // );
  }
}