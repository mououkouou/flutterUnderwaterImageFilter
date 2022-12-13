import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

final screenWidth = Get.width;
final screenHeight = Get.height;

//ColorData
const mainColor = Color(0xFF1B9898);
const pointColor = Color(0xFF24E0E0);

const whiteColor = Color(0xFFFFFFFF);
const defaultColor = Color(0xFF000000);
const greyColor = Color(0xFF7A7A7A);
const lightGreyColor = Color(0xFFDEDEDE);
// background - Main화면, 코인화면,
const mainBackgroundColor = Color(0xFFF0EFF0);
// background - 포스트화면
const subBackgroundColor = Color(0xFFEEF2F5);

//width,height Data
final sw1 = screenWidth * 0.01;
final sw2 = screenWidth * 0.02;
final sw3 = screenWidth * 0.03;
final sw4 = screenWidth * 0.04;
final sw5 = screenWidth * 0.05;
final sw6 = screenWidth * 0.06;
final sw7 = screenWidth * 0.07;
final sw8 = screenWidth * 0.08;
final sw9 = screenWidth * 0.09;

final sh1 = screenHeight * 0.01;
final sh2 = screenHeight * 0.02;
final sh3 = screenHeight * 0.03;
final sh4 = screenHeight * 0.04;
final sh5 = screenHeight * 0.05;
final sh6 = screenHeight * 0.06;
final sh7 = screenHeight * 0.07;
final sh8 = screenHeight * 0.08;
final sh9 = screenHeight * 0.09;

final sw10 = screenWidth * 0.1;
final sw20 = screenWidth * 0.2;
final sw30 = screenWidth * 0.3;
final sw40 = screenWidth * 0.4;
final sw50 = screenWidth * 0.5;
final sw60 = screenWidth * 0.6;
final sw70 = screenWidth * 0.7;
final sw80 = screenWidth * 0.8;
final sw90 = screenWidth * 0.9;

final sh10 = screenHeight * 0.1;
final sh20 = screenHeight * 0.2;
final sh30 = screenHeight * 0.3;
final sh40 = screenHeight * 0.4;
final sh50 = screenHeight * 0.5;
final sh60 = screenHeight * 0.6;
final sh70 = screenHeight * 0.7;
final sh80 = screenHeight * 0.8;
final sh90 = screenHeight * 0.9;

//TextStyleData
// Main화면 타이틀
TextStyle titleTextStyle(Color color) 
{
  return GoogleFonts.poppins(textStyle:TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: color));
}

TextStyle subTextStyle(Color color) 
{
  return GoogleFonts.poppins(textStyle:TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: color));
}

TextStyle highlightTextStyle(Color color) 
{
  return GoogleFonts.poppins(textStyle:TextStyle(fontSize: 25, fontWeight: FontWeight.w800, color: color));
}

TextStyle etcTextStyle(Color color) 
{
  return GoogleFonts.poppins(textStyle:TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: color));
}

Text settingText(String text,{double size = 14,
  FontWeight weight = FontWeight.normal,
  Color color = defaultColor,
  TextAlign align = TextAlign.center
}) 
{
  return Text( text, style: GoogleFonts.poppins(textStyle: TextStyle(fontSize: size, fontWeight: weight, color: color)));
}
Widget buildProfileCircle(AssetImage assetImage, double size) 
{
  return Container( width: size, height: size, child: CircleAvatar( backgroundImage: assetImage));
}
