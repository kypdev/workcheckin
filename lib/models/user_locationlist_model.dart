class UserLocationListModel {
  int modelid;
  String name;
  int orgId;
  int branchId;
  double latitude;
  double longitude;
  int far;
  int status;
  String createDate;
  int createBy;
  String updateDate;
  int updateBy;
  String defaultInTime;
  String defaultOutTime;

  UserLocationListModel(this.modelid, this.name, this.orgId, this.branchId, this.latitude, this.longitude, this.far, this.status, this.createDate, this.createBy, this.updateDate, this.updateBy, this.defaultInTime, this.defaultOutTime);

  UserLocationListModel.fromJson(Map<String, dynamic> json) {
    modelid = json['modelid'];
    name = json['name'];
    orgId = json['org_id'];
    branchId = json['branch_id'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    far = json['far'];
    status = json['status'];
    createDate = json['createDate'];
    createBy = json['createBy'];
    updateDate = json['updateDate'];
    updateBy = json['updateBy'];
    defaultInTime = json['defaultInTime'];
    defaultOutTime = json['defaultOutTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['modelid'] = this.modelid;
    data['name'] = this.name;
    data['org_id'] = this.orgId;
    data['branch_id'] = this.branchId;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['far'] = this.far;
    data['status'] = this.status;
    data['createDate'] = this.createDate;
    data['createBy'] = this.createBy;
    data['updateDate'] = this.updateDate;
    data['updateBy'] = this.updateBy;
    data['defaultInTime'] = this.defaultInTime;
    data['defaultOutTime'] = this.defaultOutTime;
    return data;
  }
}
