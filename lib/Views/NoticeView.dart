import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:arable_underwater_filter_v2/Data/data.dart';
import 'package:arable_underwater_filter_v2/Services/NoticeService.dart';
import 'package:arable_underwater_filter_v2/Services/SharedPreferenceService.dart';
import 'package:arable_underwater_filter_v2/Views/NoticeListView.dart';

class NoticeView extends StatelessWidget {
  var sharedPreferenceService = Get.find<SharedPreferenceService>();
  var noticeService = Get.find<NoticeService>();
  
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
                              Text("Notice", style: GoogleFonts.poppins(textStyle: TextStyle(fontSize: 32, fontWeight: FontWeight.w400))),
                              Text("Now, We're updating!", style: GoogleFonts.poppins(textStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w200))),
                              
                            ],),
                      ),
                      Expanded(child: _buildNotice(),),
                    ],
                  ),
                ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotice() {
    return ListView.separated(
            separatorBuilder: (context, index){
             return new Divider(color: lightGreyColor);
            },
            itemCount: noticeService.noticeList.length,
            itemBuilder: (context, index) {
                noticeService.setNoticeChecked(noticeService.noticeList[index].id, index);
                return 
                  ListTile(
                    onTap: (){
                      Get.to(NoticeListView(), arguments: {
                        'title': noticeService.noticeList[index].title,
                        'content': noticeService.noticeList[index].content,
                        'updatedAt' : DateFormat.yMMMd().format((noticeService.noticeList[index].updatedAt)).toString(),
                      });
                      noticeService.setNoticeRead(noticeService.noticeList[index].id,index);
                    },
                    title: Text(noticeService.noticeList[index].title),
                    subtitle: Text(
                      DateFormat.yMMMd().format((noticeService.noticeList[index].updatedAt)).toString(),
                      style: TextStyle(fontSize: 13.0),),
                      trailing: Obx(()=> noticeService.noticeList[index].checked.value
                      ? Icon(Icons.done_all_outlined, color: pointColor)
                      : Icon(Icons.arrow_forward_ios, color: lightGreyColor),
                    )
                  );
            },
          );
  }
}