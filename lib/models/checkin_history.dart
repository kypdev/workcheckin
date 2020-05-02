class CheckinHistory {
  int modelid;
  int userId;
  String deviceId;
  int osMobile;
  int locationId;
  int bossId;
  int actionCode;
  String locationName;
  int platform;
  int lateTime;
  int lateFlag;
  int earlyTime;
  int earlyFlag;
  String createDate;
  String createTime;
  int createBy;
  String checkoutDate;
  String checkoutTime;

  CheckinHistory(
      this.modelid,
      this.userId,
      this.deviceId,
      this.osMobile,
      this.locationId,
      this.bossId,
      this.actionCode,
      this.locationName,
      this.platform,
      this.lateTime,
      this.lateFlag,
      this.earlyTime,
      this.earlyFlag,
      this.createDate,
      this.createTime,
      this.createBy,
      this.checkoutDate,
      this.checkoutTime);

  CheckinHistory.fromJson(Map<String, dynamic> json) {
    modelid = json['modelid'];
    userId = json['userId'];
    deviceId = json['deviceId'];
    osMobile = json['osMobile'];
    locationId = json['locationId'];
    bossId = json['bossId'];
    actionCode = json['actionCode'];
    locationName = json['locationName'];
    platform = json['platform'];
    lateTime = json['lateTime'];
    lateFlag = json['lateFlag'];
    earlyTime = json['earlyTime'];
    earlyFlag = json['earlyFlag'];
    createDate = json['createDate'];
    createTime = json['createTime'];
    createBy = json['createBy'];
    checkoutDate = json['checkoutDate'];
    checkoutTime = json['checkoutTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['modelid'] = this.modelid;
    data['userId'] = this.userId;
    data['deviceId'] = this.deviceId;
    data['osMobile'] = this.osMobile;
    data['locationId'] = this.locationId;
    data['bossId'] = this.bossId;
    data['actionCode'] = this.actionCode;
    data['locationName'] = this.locationName;
    data['platform'] = this.platform;
    data['lateTime'] = this.lateTime;
    data['lateFlag'] = this.lateFlag;
    data['earlyTime'] = this.earlyTime;
    data['earlyFlag'] = this.earlyFlag;
    data['createDate'] = this.createDate;
    data['createTime'] = this.createTime;
    data['createBy'] = this.createBy;
    data['checkoutDate'] = this.checkoutDate;
    data['checkoutTime'] = this.checkoutTime;
    return data;
  }
}
