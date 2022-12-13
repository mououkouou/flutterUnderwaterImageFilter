import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BackgroundService extends GetxService
{
  final List<String> _backgroundAssetImagePaths = 
  [
    'assets/original.png',
    'assets/mainImage_1.jpg',
    'assets/mainImage_2.jpg',
    'assets/mainImage_3.jpg',
    'assets/mainImage_4.jpg',
    'assets/mainImage_5.jpg'
  ];
  final List<Image> _backgroundImageList =[];
  late int length;

  BackgroundService()
  {
    for(String asset in _backgroundAssetImagePaths)
    {
      _backgroundImageList.add(Image.asset(asset,fit: BoxFit.cover,gaplessPlayback: true));
    }
    length = _backgroundAssetImagePaths.length;
  }

  Image getImage(RxInt index)
  {
    return _backgroundImageList[index.value % length];
  }
}