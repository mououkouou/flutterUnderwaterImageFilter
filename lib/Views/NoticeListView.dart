import 'package:arable_underwater_filter_v2/Data/data.dart';
import 'package:arable_underwater_filter_v2/Services/SharedPreferenceService.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class NoticeListView extends StatelessWidget
{
  SharedPreferenceService sharedPreferencService = Get.find<SharedPreferenceService>();

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
                        padding: EdgeInsets.fromLTRB(sw3, sh10, sw3, sh2), 
                        child:
                          Column
                          (
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: 
                            [
                              Text('${Get.arguments['title']}', style: GoogleFonts.poppins(textStyle: TextStyle(fontSize: 26, fontWeight: FontWeight.w400))),
                              Padding(padding: EdgeInsets.fromLTRB(2, 1, 0, sh3), child: Text('${Get.arguments['updatedAt']}',style: GoogleFonts.poppins(textStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w200)))),
                              Text('${Get.arguments['content'].replaceAll("\\n", "\n")}',style: GoogleFonts.poppins(textStyle: TextStyle(fontSize: 13, fontWeight: FontWeight.w300))),
                            ],),
                      ),
                    ],
                  ),
                ),
            ),
          ],
        ),
      ),
    );
  }
}