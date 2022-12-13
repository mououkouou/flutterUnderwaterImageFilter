import 'package:get/get.dart';

class NoticeModel {
  String id, title, content;
  DateTime createdAt;
  DateTime? updatedAt;
  RxBool checked = false.obs;

  NoticeModel(this.id,this.title,this.content,this.createdAt,{this.updatedAt});
}