import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class FirebaseService extends GetxService{
  late FirebaseStorage storage;
  late Reference storageRef;

  // firebase 초기화
  Future firebaseInitialization() async 
  {
    await Firebase.initializeApp();
    //firebase 익명인증
    await FirebaseAuth.instance.signInAnonymously();
  }

  Future<QuerySnapshot> getNotice() async
  {
    QuerySnapshot _noticeSnap = await FirebaseFirestore.instance
      .collection('Notice')
      .orderBy('createdAt', descending: true)
      .where('active', isEqualTo : true)
      .get();
      
    return _noticeSnap;
  }

  Future uploadFile(String filePath, String uploadPath) async {
    File file = File(filePath);
    try
    {
      storageRef = FirebaseStorage.instance.ref().child(uploadPath).child("${DateTime.now().year}_${DateTime.now().month}_${DateTime.now().day}_${DateTime.now().hour}:${DateTime.now().minute}.png");
      await storageRef.putFile(file);
    } on FirebaseException catch (e){
      print(e.toString());
    }
  }

  Future uploadFiles(List<XFile> files, String uploadPath) async{
    int i = 1;
    String filePath = "${DateTime.now().year}_${DateTime.now().month}_${DateTime.now().day}_${DateTime.now().hour}_${DateTime.now().minute}_${DateTime.now().second}_${DateTime.now().millisecond}";
    try
    {
      files.forEach((element) async{
        File file = File(element.path);
        storageRef = FirebaseStorage.instance.ref().child(uploadPath).child(filePath + "_${i++}");
        await storageRef.putFile(file);
      });
    } on FirebaseException catch (e){
      print(e.toString());
    }
  }
}