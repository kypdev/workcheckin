class RequestByBoss {
  int modelid;
  int userId;
  String employeeName;
  int leaveTypeCode;
  String leaveTypeName;
  String leaveDate;
  int leaveHour;
  String remark;
  int approveFlag;
  String approveRejectDate;
  String approveRejectBy;
  String createDate;
  int createBy;
  String updateDate;
  String updateBy;

  RequestByBoss(
      this.modelid,
      this.userId,
      this.employeeName,
      this.leaveTypeCode,
      this.leaveTypeName,
      this.leaveDate,
      this.leaveHour,
      this.remark,
      this.approveFlag,
      this.approveRejectDate,
      this.approveRejectBy,
      this.createDate,
      this.createBy,
      this.updateDate,
      this.updateBy);

  RequestByBoss.fromJson(Map<String, dynamic> json) {
    modelid = json['modelid'];
    userId = json['userId'];
    userId = json['employeeName'];
    leaveTypeCode = json['leaveTypeCode'];
    leaveTypeName = json['leaveTypeName'];
    leaveDate = json['leaveDate'];
    leaveHour = json['leaveHour'];
    remark = json['remark'];
    approveFlag = json['approveFlag'];
    approveRejectDate = json['approveRejectDate'];
    approveRejectBy = json['approveRejectBy'];
    createDate = json['createDate'];
    createBy = json['createBy'];
    updateDate = json['updateDate'];
    updateBy = json['updateBy'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['modelid'] = this.modelid;
    data['userId'] = this.userId;
    data['employeeName'] = this.userId;
    data['leaveTypeCode'] = this.leaveTypeCode;
    data['leaveTypeName'] = this.leaveTypeName;
    data['leaveDate'] = this.leaveDate;
    data['leaveHour'] = this.leaveHour;
    data['remark'] = this.remark;
    data['approveFlag'] = this.approveFlag;
    data['approveRejectDate'] = this.approveRejectDate;
    data['approveRejectBy'] = this.approveRejectBy;
    data['createDate'] = this.createDate;
    data['createBy'] = this.createBy;
    data['updateDate'] = this.updateDate;
    data['updateBy'] = this.updateBy;
    return data;
  }
}
