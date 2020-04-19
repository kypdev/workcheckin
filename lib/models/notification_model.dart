class NotificationModel {
  int modelid;
  int userId;
  String bossId;
  String noti;
  String createDate;
  int createBy;

  NotificationModel(
      this.modelid,
      this.userId,
      this.bossId,
      this.noti,
      this.createDate,
      this.createBy);

  NotificationModel.fromJson(Map<String, dynamic> json) {
    modelid = json['modelid'];
    userId = json['userId'];
    bossId = json['bossId'];
    noti = json['noti'];
    createDate = json['createDate'];
    createBy = json['createBy'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['modelid'] = this.modelid;
    data['userId'] = this.userId;
    data['bossId'] = this.bossId;
    data['noti'] = this.noti;
    data['createDate'] = this.createDate;
    data['createBy'] = this.createBy;
    return data;
  }
}