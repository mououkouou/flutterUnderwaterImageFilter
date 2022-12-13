import 'dart:async';
import 'dart:io';
import 'package:arable_underwater_filter_v2/Data/FilterList.dart';
import 'package:arable_underwater_filter_v2/Data/ImageBinding.dart';
import 'package:arable_underwater_filter_v2/Data/data.dart';
import 'package:arable_underwater_filter_v2/Services/ImageService.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';

// ignore: must_be_immutable
class FilterView extends StatelessWidget 
{
  ImageService imageService = Get.find<ImageService>();
  RxBool _originalFilter = false.obs;  
  RxBool startLottie = false.obs;
  late Rx<ImageBinding> _bindingObject;
  late String _returnPath;
  late String _originalPath;
  int selected = 0;

  Future <void> selectFilter(int idx) async
  {
    filterList[selected]['selected'] = false;
    selected = idx;
    filterList[selected]['selected'] = true;
    filterList.refresh();
    
    if (idx != 0) 
    {
      imageCache!.clearLiveImages();
      imageCache!.clear();
      _returnPath = imageService.filterExample(_originalPath, idx);
      _bindingObject.value.imagePath = _returnPath;
    } 
    else 
    {
      _bindingObject.value.imagePath=_originalPath;
    }
    _bindingObject.refresh();
  }
  
  FilterView(String path) 
  {
    _originalPath = path;
    _bindingObject = new ImageBinding(path).obs;
  }

  @override
  Widget build(BuildContext context) 
  {
    return content(context);
  }

  Scaffold content(BuildContext context) 
  {
    return Scaffold
    (
      body: SafeArea
      (
      child: Stack
      (
        children: 
        [
          Container
          (
            width: screenWidth,
            height: screenHeight,
            color: defaultColor,
          ),   
          Positioned(top: sh30+sh5, left: sw40+sw5, child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(whiteColor))),
          Container
          (
            width: screenWidth,
            height: screenHeight,
            child: Column
            (
              children: 
              [
                Padding
                (
                  padding: EdgeInsets.all(sh3),
                  child: Row
                  (
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: 
                    [
                      InkWell
                      (
                        onTap: () => Get.back(),
                        child: SizedBox
                        (
                          width: 30.0,
                          height: 30.0,
                          child: Image(image: AssetImage('assets/back.png'))
                        )
                      ),
                      Row(
                        children: [
                          GestureDetector
                          ( 
                            onTapDown: (TapDownDetails tapDownDetails)=> 
                            {
                              _bindingObject.value.imagePath != _originalPath 
                                ? _bindingObject.value.imagePath = _originalPath
                                : _originalFilter.value = true,
                              _bindingObject.refresh(),
                            },
                            onTapUp: (TapUpDetails tapUpDetails)=> 
                            {
                              _originalFilter.value != true
                              ? _bindingObject.value.imagePath = _returnPath
                              : null,
                              _originalFilter.value = false,
                              _bindingObject.refresh(),
                            },
                            child: Icon(Icons.cached_outlined, size: 30, color: whiteColor,),
                          ),
                          SizedBox(width: sw10),
                          InkWell
                          (
                            onTap: () => {
                              startLottie.value = true,
                              Future.delayed(const Duration(milliseconds: 1900),(){
                                  startLottie.value = false;
                               }),
                              imageService.saveFile(XFile(_bindingObject.value.imagePath), context),
                            },
                            child: settingText
                            (
                              'SAVE',
                              weight: FontWeight.bold,
                              size: 15.0,
                              color: whiteColor,
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
                Expanded
                (
                  child:
                  Obx(()=>
                    Image
                    (
                      image: 
                        FileImage(File(_bindingObject.value.imagePath)),
                        fit: BoxFit.contain,
                        loadingBuilder: (context,child,loadingProgress)
                          { 
                            return loadingProgress == null ? 
                                  child : CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(whiteColor));
                          },
                    ),
                  )
                ),
                Container
                (
                  margin: EdgeInsets.only(top: sh4),
                  padding: EdgeInsets.fromLTRB(sw4, 0, sw4, 0),
                  color: whiteColor,
                  height: sw50 + sw5,
                  child: 
                  Obx
                  (
                    () => ListView.builder
                    (
                      scrollDirection: Axis.horizontal,
                      itemCount: filterList.length,
                      itemBuilder: (_, idx) 
                      {
                        return Container
                        (
                          padding: EdgeInsets.fromLTRB(sw4, 0, sw4, 0),
                          child: Column
                          (
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: 
                            [
                            InkWell
                              (
                                onTap: () => selectFilter(idx),
                                child: Container
                                (
                                  alignment: Alignment(0.7, -0.8),
                                  decoration: BoxDecoration
                                  (
                                      borderRadius: BorderRadius.circular(10.0),
                                      image: DecorationImage(image: filterList[idx]['image'] as AssetImage,fit: BoxFit.cover)
                                  ),
                                  width: sw20,
                                  height: sw30,
                                  child: idx == selected ? Image(image: AssetImage('assets/checked.png')) : SizedBox(),
                                ),
                              ),
                              SizedBox
                              (
                                height: sw3
                              ),
                              settingText
                              (
                                filterList[idx]['name'] as String, 
                                color: idx == selected ? pointColor : defaultColor, 
                                size: 12, weight: FontWeight.bold
                              )
                            ],
                          ),
                        );
                      }),
                  ))
              ],
            ),
          ),
          Obx(()=> 
          startLottie.value
          ? Container(
              color: defaultColor.withOpacity(0.85),
              child:
                Center(
                child:
                  Lottie.asset(
                    'assets/savedanimation.json',
                    reverse: false,
                    repeat: false,
                  ),
                ),
            )
          : SizedBox.shrink(),
          ),          
        ],
      ),
    ));
  }
}
