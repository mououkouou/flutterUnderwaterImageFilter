import 'dart:io';
import 'package:arable_underwater_filter_v2/Data/data.dart';
import 'package:arable_underwater_filter_v2/Services/FirebaseService.dart';
import 'package:arable_underwater_filter_v2/Services/ImageService.dart';
import 'package:arable_underwater_filter_v2/Views/MainView.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class HelpUsView extends StatelessWidget {
  var firebaseService = Get.find<FirebaseService>();
  RxList<XFile> _pickedImgs =  <XFile>[].obs;
  RxBool _selectedImage = false.obs;
  RxBool uploading = false.obs;

  void selectImages() async{ 
    var imageService = Get.find<ImageService>();
    List<XFile>? imageFileList = await imageService.getImages();
     if(imageFileList!.length !=0)
    {
      _pickedImgs.value = imageFileList;
      _selectedImage.value = true;
    }
  }

  @override
  Widget build(BuildContext context) 
  {
    return Scaffold
    (
      backgroundColor: whiteColor,
      body: SafeArea
      (
        child: Stack
        (
          children:
          [
            GestureDetector
            (
                onTap: () => Get.back(),
                child: Container
                (
                  child: Align
                  (
                    alignment: Alignment.topRight,
                    child: Icon(Icons.close, size: 30),
                  ),
                  padding:EdgeInsets.fromLTRB(0, sh2, sw5, 0)
                ),
            ),
            Center
            (
              child: 
                Container
                (
                  width: sw90,
                  child: Column
                  (
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: 
                    [
                      Padding
                      (
                        padding: EdgeInsets.fromLTRB(sw1, sh5, 0, sh2), 
                        child:
                          Column
                          (
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: 
                            [
                              Text("Help Us", style: GoogleFonts.poppins(textStyle: TextStyle(fontSize: 32, fontWeight: FontWeight.w400))),
                              Text("We want your underwater photographs", style: GoogleFonts.poppins(textStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w200))),
                              
                            ],),
                      ),
                      Text("Underwater photographs are used to develop and test our filtering algorithms.", style: GoogleFonts.poppins(textStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.w300))),
                      SizedBox(height: sh2),
                      _buildPickedPicture(),
                      Obx(() => 
                        _selectedImage.value == true
                        ? GestureDetector
                          (
                            onTap: () 
                            {
                              uploading.value = true;
                              firebaseService.uploadFiles(_pickedImgs, 'HelpUs').then((_) => 
                              Future.delayed(const Duration(milliseconds: 1500),(){ Get.off(MainView()); }));  
                            },
                            child: Container
                            (
                              margin: EdgeInsets.only(top: sh2),
                              decoration: BoxDecoration
                              (
                                borderRadius: BorderRadius.circular(5.0),
                                border: Border.all(width: 0.5,
                                color: greyColor),
                              ),
                              width: sw90,
                              height: sh7,
                              child: Center
                              (
                                child: Text('Upload',style: GoogleFonts.poppins(textStyle:TextStyle(fontSize: 17, fontWeight: FontWeight.w300, color: greyColor)))
                              ),
                            ),
                          )
                        : SizedBox.shrink(),
                      ),
                    ],
                  ),
                ),
            ),
            Obx(()=>
              uploading.value == true
              ? Container
                (
                  width: screenWidth,
                  height: screenHeight,
                  color: defaultColor.withOpacity(0.7),
                  child:
                    Center(child: 
                      SizedBox
                      ( 
                        width: 100,
                        height: 100,
                        child: CircularProgressIndicator
                        (
                          strokeWidth: 4,
                          backgroundColor: whiteColor,
                          valueColor: new AlwaysStoppedAnimation<Color>(pointColor),
                        ),
                      ),
                    ),
                )
              : SizedBox.shrink()
            ),
           
          ],
        ),
      ),
    );
  }

  @override
  Widget _buildPickedPicture()
  {
    List<Widget> _boxContents =
    [     
      GestureDetector
      ( 
        onTap: () => selectImages(),
        child: Container
          (
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration
              (
                color: whiteColor.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
            child: Obx(()=> 
            Icon
              (
                Icons.camera_alt_outlined,
                color: _selectedImage.value ? whiteColor : pointColor,
                size: 35,
              ),
            ),
          )
      ),
      Container(),
      Container(),
      Obx(() => _pickedImgs.length <= 4
      ? Container()
      : FittedBox
        (
          child: Container
            (
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration
                (
                  color: whiteColor.withOpacity(0.3),
                  shape: BoxShape.circle
                ),
              child: Text('+${(_pickedImgs.length-4).toString()}',style: GoogleFonts.poppins(textStyle: TextStyle( color: whiteColor,fontSize: 20, fontWeight: FontWeight.w500, ))),
            )
        ),
      )
    ];
    return 
    GridView.count
      (
        shrinkWrap: true,
        padding: EdgeInsets.all(2),
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        children: List.generate
          (4, 
          (index) =>
            Container
            (
              child: Obx(()=> 
                Container
                (
                  child: Center(child: _boxContents[index]),
                  decoration: BoxDecoration
                    (
                      image: 
                      index <= _pickedImgs.length -1
                      ? DecorationImage
                      (
                        fit: BoxFit.cover,
                        image:FileImage(File(_pickedImgs[index].path))
                      )
                      : null,
                      borderRadius: BorderRadius.circular(5.0),
                      border: Border.all(width: 0.5,
                      color: greyColor),
                    )
                ),
              ),
            )
          ),
    );
  }
}