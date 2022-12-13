import 'dart:ffi';
import 'package:arable_underwater_filter_v2/Data/FilterList.dart';
import 'package:ffi/ffi.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'dart:io';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

///picker, filter service를 ImageService로 통합
///수정이력:
///2021 10 27
///
class ImageService extends GetxService 
{
  //네이티브 라이브러리 땡겨오는 코드. 안드로이드 IOS 둘다 핸들링
  final lib = Platform.isAndroid ? DynamicLibrary.open("libOpenCV_ffi.so") : DynamicLibrary.process();
  //이미지 피커 객체
  final ImagePicker _imagePicker = new ImagePicker();

  //필터 라이브러리에 메소드 호출
  String filterExample(String path, int idx) 
  {
    RegExp directoryReg = new RegExp(r"(?=\/)(.*)(?<=\/)");
    String? dir = directoryReg.firstMatch(path)!.group(0);
    final timeStamp = "${DateTime.now().year}${DateTime.now().month}${DateTime.now().day}${DateTime.now().hour}${DateTime.now().minute}${DateTime.now().second}";
    String returnPath = "$dir${filterList[idx]['name']}$timeStamp.jpg";
    var filter = lib.lookupFunction<Void Function(Pointer<Utf8>,Pointer<Utf8>),void Function(Pointer<Utf8>,Pointer<Utf8>)>(filterList[idx]['name'] as String);
    filter(path.toNativeUtf8(),returnPath.toNativeUtf8());
    return returnPath;
  }

  //이미지 피커 사진찍기
  Future<XFile?> getPhoto() async 
  {
    return await _imagePicker.pickImage(source: ImageSource.camera) ?? new XFile('');
  }

  //이미지 피커 앨범사진 가져오기
  Future<XFile?> getImage() async 
  {
    return await _imagePicker.pickImage(source: ImageSource.gallery) ?? new XFile('');
  }

  //앨범사진 들 가져오기
  Future<List<XFile>?> getImages() async 
  {
    return await _imagePicker.pickMultiImage() ?? List.empty();
  }

  Future saveFile(XFile? image, BuildContext context) async 
  {
    GallerySaver.saveImage(image!.path, albumName: 'DiveFlash');
  }
}
