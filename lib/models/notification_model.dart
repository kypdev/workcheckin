class BossNotifyModel {
  int modelid;
  int userId;
  String name;
  int bossId;
  String noti;
  String createDate;
  int createBy;

  BossNotifyModel(this.modelid, this.userId, this.name, this.bossId, this.noti, this.createDate, this.createBy);

  BossNotifyModel.fromJson(Map<String, dynamic> json) {
    modelid = json['modelid'];
    userId = json['userId'];
    name = json['name'];
    bossId = json['bossId'];
    noti = json['noti'];
    createDate = json['createDate'];
    createBy = json['createBy'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['modelid'] = this.modelid;
    data['userId'] = this.userId;
    data['name'] = this.name;
    data['bossId'] = this.bossId;
    data['noti'] = this.noti;
    data['createDate'] = this.createDate;
    data['createBy'] = this.createBy;
    return data;
  }
}
