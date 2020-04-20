class BranchList {
  int modelid;
  String name;
  int status;
  int orgId;
  String createDate;
  int createBy;
  String updateDate;
  int updateBy;

  BranchList(
      this.modelid,
      this.name,
      this.status,
      this.orgId,
      this.createDate,
      this.createBy,
      this.updateDate,
      this.updateBy);

  BranchList.fromJson(Map<String, dynamic> json) {
    modelid = json['modelid'];
    name = json['name'];
    status = json['status'];
    orgId = json['orgId'];
    createDate = json['createDate'];
    createBy = json['createBy'];
    updateDate = json['updateDate'];
    updateBy = json['updateBy'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['modelid'] = this.modelid;
    data['name'] = this.name;
    data['status'] = this.status;
    data['orgId'] = this.orgId;
    data['createDate'] = this.createDate;
    data['createBy'] = this.createBy;
    data['updateDate'] = this.updateDate;
    data['updateBy'] = this.updateBy;
    return data;
  }
}