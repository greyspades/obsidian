class Transaction {
  final String? itemCode;
  final String? itemName;
  final String? precRef;
  final String? titleDesc;
  final String? module;
  final String? createdBy;
  final String? fullName;
  final int? xStageNo;
  final String? buName;
  final String? xStageStatus;
  final String? xApprovalStatus;
  final int? applvStatusId;
  final String? xTransStatus;
  final String? xRecordState;
  final String? timeStamp;
  final String? tReviewer;
  final String? xAppOriginRef;
  final String? xAssignTo;
  final String? expandedValue;

  bool? isExpanded;

  Transaction(
      {required this.itemCode,
      required this.itemName,
      required this.precRef,
      required this.titleDesc,
      required this.module,
      required this.createdBy,
      required this.fullName,
      required this.xStageNo,
      required this.buName,
      required this.xStageStatus,
      required this.xApprovalStatus,
      required this.applvStatusId,
      required this.xTransStatus,
      required this.xRecordState,
      required this.timeStamp,
      required this.tReviewer,
      required this.xAssignTo,
      required this.xAppOriginRef,
      this.isExpanded = false,
      this.expandedValue
      });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
        itemCode: json['ItemCode'],
        itemName: json['ItemName'],
        precRef: json['Proc_Ref'],
        titleDesc: json['Item_Title_Desc'],
        module: json['Module'],
        createdBy: json['CreatedBy'],
        fullName: json['FullName'],
        xStageNo: json['xStageNo'],
        buName: json['Bu_Name'],
        xStageStatus: json['xStageStatus'],
        xApprovalStatus: json['xApprovalStatus'],
        applvStatusId: json['Appvl_Sts_Id'],
        xRecordState: json['xRecordState'],
        xTransStatus: json['xTransStatus'],
        xAssignTo: json['xAssignTo'],
        timeStamp: json['Trans_TimeStamp'],
        tReviewer: json['tReviewer'],
        xAppOriginRef: json['xOriginRef'],
        );
  }
}