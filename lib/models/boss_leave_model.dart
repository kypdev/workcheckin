class BossLeaveModel {
  int modelid;
  int userId;
  int leaveTypeCode;
  String leaveDate;
  int leaveHour;
  String remark;
  String approveFlag;
  String approveRejectDate;
  String approveRejectBy;
  String createDate;
  int createBy;
  String updateDate;
  String updateBy;

  BossLeaveModel(
      this.modelid,
      this.userId,
      this.leaveTypeCode,
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

  BossLeaveModel.fromJson(Map<String, dynamic> json) {
    modelid = json['modelid'];
    userId = json['userId'];
    leaveTypeCode = json['leaveTypeCode'];
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
    data['leaveTypeCode'] = this.leaveTypeCode;
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