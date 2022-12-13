import 'dart:async';
import 'package:arable_underwater_filter_v2/Services/FirebaseService.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:arable_underwater_filter_v2/Data/NoticeModel.dart';
import 'package:arable_underwater_filter_v2/Services/SharedPreferenceService.dart';

class NoticeService extends GetxService {
  var sharedPreferenceService = Get.find<SharedPreferenceService>();
  var firebaseService = Get.find<FirebaseService>();
  List noticeList = <NoticeModel>[];
  RxBool readAll = false.obs;
  List<String> noticeSharedList = [];
  List<String> tempList = [];

  Future <void> noticeServiceInitialization() async {
    try {
      QuerySnapshot _noticeCollectionData = await firebaseService.getNotice();
      for(var item in _noticeCollectionData.docs)
      {
        noticeList.add(NoticeModel(item.id, item['title'], item['content'], item['createdAt'].toDate(), updatedAt: item['updatedAt'] == null? item['createdAt'].toDate() : item['updatedAt'].toDate()));
      }
      noticeSharedList = sharedPreferenceService.getStringList('Notice');
      tempList = new List<String>.from(noticeSharedList);
      setReadAll();

    } catch (e){
      print(e.toString());
    }

  }

  Future<void> setReadAll() async
  {
    noticeSharedList = sharedPreferenceService.getStringList('Notice');
    for(var i = 0; i< noticeList.length; i++)
    {
      if(noticeSharedList.contains(noticeList[i].id) == false)
      {
        readAll.value = false;
        return;
      }
    }
    readAll.value = true;
  }

  void setNoticeRead(String id, int index) async
  {  
    if(!tempList.contains(id))
    {
      tempList.add(id);
      await sharedPreferenceService.put('Notice', tempList);
      setNoticeChecked(id, index);
      setReadAll();
    }
  }

  void setNoticeChecked(String id, int index){
    if(sharedPreferenceService.getStringList('Notice').contains(id))
    {
      noticeList[index].checked.value = true;
    }
    else
      noticeList[index].checked.value = false;
    }
  }
