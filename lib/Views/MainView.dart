import 'package:arable_underwater_filter_v2/Data/data.dart';
import 'package:arable_underwater_filter_v2/Services/BackgroundService.dart';
import 'package:arable_underwater_filter_v2/Services/FirebaseService.dart';
import 'package:arable_underwater_filter_v2/Services/ImageService.dart';
import 'package:arable_underwater_filter_v2/Services/NoticeService.dart';
import 'package:arable_underwater_filter_v2/Views/HelpUsView.dart';
import 'package:arable_underwater_filter_v2/Views/NoticeView.dart';
import 'package:arable_underwater_filter_v2/Views/FilterView.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';


class MainView extends StatefulWidget 
{
  const MainView({Key? key}) : super(key: key);

  @override
  _MainViewState createState() => _MainViewState();
}

class _MainViewState extends State<MainView> with SingleTickerProviderStateMixin 
{
  // 애니메이션에 사용할 두 개의 클래스 객체 참조 멤버 입니다.
  late Animation<double> _animation;
  late AnimationController _animationController;
  var backgroundService = Get.find<BackgroundService>();
  var firebaseService = Get.find<FirebaseService>();
  var noticeService = Get.find<NoticeService>();

  RxInt idx = 0.obs;

  @override
  void initState() 
  {
    super.initState();
    _animationController = AnimationController(duration: Duration(milliseconds: 500), vsync: this);
    _animation = CurvedAnimation(parent: _animationController, curve: Curves.linear);
    _animation.addStatusListener
    ( 
      (status) 
      {
        if(status == AnimationStatus.completed) 
        {
            idx.value += 1;
          _animationController.reverse();
        } 
        else if (status == AnimationStatus.dismissed) 
        {
          _animationController.forward();
        }
      }
    );
    _animationController.forward();
  }

  @override
  void dispose() 
  {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) 
  {
    return Scaffold(body: _chooseType(context));
  }

  Widget _chooseType(BuildContext context) 
  {
    return Scaffold
    (
      backgroundColor: whiteColor,
      body: SafeArea
      (
        child:Stack
        (
          children: 
          [
            Container
            (
              width: screenWidth,
              height: screenHeight,
              child: Obx
              (
                () => backgroundService.getImage(idx))
            ),
            Padding
            (
              padding: EdgeInsets.fromLTRB(sw10, 0, sw10, 0),
              child: Column
              (
                mainAxisAlignment: MainAxisAlignment.center,
                children: 
                [
                  Container
                  (
                    width: double.infinity,
                    child: Column
                    (
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: 
                      [
                        Image(width: 270, image: AssetImage('assets/logo4.png')), 
                        Container
                        (
                          width: 10,
                          height: 1,
                          color:whiteColor,
                        ),
                        SizedBox
                        (
                        height: 5,
                        ),
                        Text
                        (
                          'Better Picture, Better Experience',
                          style: GoogleFonts.poppins
                          (
                            textStyle: TextStyle
                            (
                              color: whiteColor,
                              fontSize: 12,
                              fontWeight: FontWeight.w200,
                            ),
                          )
                        ),
                      ],
                    ),
                  ),
                  SizedBox
                  (
                    height: sh50,
                  ),
                  GestureDetector
                  (
                    onTap: () => goToFilterView(context),
                    child: Container
                    (
                      decoration: BoxDecoration 
                      (
                        borderRadius: BorderRadius.circular(5.0),
                        color: whiteColor.withOpacity(1),
                        boxShadow: [
                        BoxShadow(
                          color: greyColor.withOpacity(0.7),
                          spreadRadius: 2,
                          blurRadius: 7,
                          offset: Offset(0, 3), 
                        )
                        ],
                      ),
                      width: double.infinity,
                      height: sh7,
                      child: Center
                      (
                        child: Text('GET STARTED',style: GoogleFonts.poppins(textStyle: TextStyle(fontSize: 17, fontWeight: FontWeight.w700,color: defaultColor.withOpacity(0.6))))
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector
                      (
                        onTap: () => Get.to(NoticeView()),
                        child: Stack(
                          alignment: Alignment.center,
                          clipBehavior: Clip.none, 
                          children: 
                          [
                            Container
                            (
                              margin: EdgeInsets.only(top: sh2),
                              decoration: BoxDecoration
                              (
                                borderRadius: BorderRadius.circular(5.0),
                                border: Border.all(width: 0.5,
                                color: whiteColor),
                              ),
                              width: sw30 + sw8,
                              height: sh7,
                              child: Center
                              (
                                child: 
                                  Text('NOTICE',style: GoogleFonts.poppins(textStyle:TextStyle(fontSize: 17, fontWeight: FontWeight.w300, color: whiteColor)))
                              ),
                            ),
                            Obx(()=> noticeService.readAll.value
                            ? SizedBox.shrink()
                            : Positioned(
                              right: 32,
                              child:
                                Container(
                                decoration: BoxDecoration 
                                (
                                  shape: BoxShape.circle, 
                                  color: pointColor.withOpacity(1),
                                ),
                                padding: EdgeInsets.all(3),
                                ),
                              ),
                            ),
                          ]
                          ),
                      ),
                      GestureDetector
                      (
                        onTap: () => Get.to(HelpUsView()),
                        child: Container
                        (
                          margin: EdgeInsets.only(top: sh2),
                          decoration: BoxDecoration
                          (
                            borderRadius: BorderRadius.circular(5.0),
                            border: Border.all(width: 0.5,
                            color: whiteColor),
                          ),
                          width: sw30 + sw8,
                          height: sh7,
                          child: Center
                          (
                            child: Text('HELP US',style: GoogleFonts.poppins(textStyle:TextStyle(fontSize: 17, fontWeight: FontWeight.w300, color: whiteColor)))
                          ),
                        ),
                      ),
                    ]
                  ),
                ],
              ),
            ),
            Align
            (
            alignment: Alignment.bottomCenter, 
            child: 
              Padding(
                padding: EdgeInsets.only(bottom: sh1),
                child:Text('Beta Version 1.0.2', style:TextStyle(fontSize: 12.0, fontWeight: FontWeight.w300, fontStyle: FontStyle.italic, color: whiteColor)),
              ),
            ),          
          ],
        ),
      ),
    );
  }
}

void goToFilterView(BuildContext context) async 
{
  var imageService = Get.find<ImageService>();
  var imagePath = await imageService.getImage();
  if(imagePath != null && imagePath.path != "")
  {
    Get.to(FilterView(imagePath.path));
  }
  else  
  {
    ScaffoldMessenger.of(context).showSnackBar
    (
      SnackBar
      (
        content: Text
        (
          'Error while processing the picture',
          textAlign: TextAlign.center,
        )
      )
    );

  }
}
