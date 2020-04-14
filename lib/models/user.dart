class User {
  String responseCode;
  String responseDesc;
  CwiUser cwiUser;
  Null branch;
  Null locationList;

  User(
      {this.responseCode,
      this.responseDesc,
      this.cwiUser,
      this.branch,
      this.locationList});

  User.fromJson(Map<String, dynamic> json) {
    responseCode = json['responseCode'];
    responseDesc = json['responseDesc'];
    cwiUser =
        json['cwiUser'] != null ? new CwiUser.fromJson(json['cwiUser']) : null;
    branch = json['branch'];
    locationList = json['locationList'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['responseCode'] = this.responseCode;
    data['responseDesc'] = this.responseDesc;
    if (this.cwiUser != null) {
      data['cwiUser'] = this.cwiUser.toJson();
    }
    data['branch'] = this.branch;
    data['locationList'] = this.locationList;
    return data;
  }
}

class CwiUser {
  int modelid;
  int employeeId;
  String username;
  Null password;
  String name;
  String lastname;
  int position;
  int orgId;
  int branchId;
  int status;
  int bossId;
  String createDate;
  int createBy;
  Null updateDate;
  Null updateBy;

  CwiUser(
      {this.modelid,
      this.employeeId,
      this.username,
      this.password,
      this.name,
      this.lastname,
      this.position,
      this.orgId,
      this.branchId,
      this.status,
      this.bossId,
      this.createDate,
      this.createBy,
      this.updateDate,
      this.updateBy});

  CwiUser.fromJson(Map<String, dynamic> json) {
    modelid = json['modelid'];
    employeeId = json['employeeId'];
    username = json['username'];
    password = json['password'];
    name = json['name'];
    lastname = json['lastname'];
    position = json['position'];
    orgId = json['orgId'];
    branchId = json['branchId'];
    status = json['status'];
    bossId = json['bossId'];
    createDate = json['createDate'];
    createBy = json['createBy'];
    updateDate = json['updateDate'];
    updateBy = json['updateBy'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['modelid'] = this.modelid;
    data['employeeId'] = this.employeeId;
    data['username'] = this.username;
    data['password'] = this.password;
    data['name'] = this.name;
    data['lastname'] = this.lastname;
    data['position'] = this.position;
    data['orgId'] = this.orgId;
    data['branchId'] = this.branchId;
    data['status'] = this.status;
    data['bossId'] = this.bossId;
    data['createDate'] = this.createDate;
    data['createBy'] = this.createBy;
    data['updateDate'] = this.updateDate;
    data['updateBy'] = this.updateBy;
    return data;
  }
}