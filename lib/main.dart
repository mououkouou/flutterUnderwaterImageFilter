import 'package:arable_underwater_filter_v2/Services/BackgroundService.dart';
import 'package:arable_underwater_filter_v2/Views/MainView.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'Services/FirebaseService.dart';
import 'Services/ImageService.dart';
import 'Services/NoticeService.dart';
import 'Services/SharedPreferenceService.dart';

void main() 
{
  WidgetsFlutterBinding.ensureInitialized();
  initServices().then((_) => runApp(MyApp()));
}

Future<void> initFirebaseService() async{
  var sharedPrefService = new SharedPreferenceService();
  await sharedPrefService.initializationDone; 
  Get.put(sharedPrefService);

  var firebaseService = new FirebaseService();
  await firebaseService.firebaseInitialization();
  Get.put(firebaseService);
}

Future<void> initNoticeService() async{
  var noticeService = new NoticeService();
  await noticeService.noticeServiceInitialization();
  Get.put(noticeService);
}

Future<void> initServices() async 
{
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await initFirebaseService();
  await initNoticeService();
  Get.put(new ImageService());
  Get.put(new BackgroundService());
}

class MyApp extends StatelessWidget 
{
  @override
  Widget build(BuildContext context) 
  {
    return GetMaterialApp
    (
      title: 'DiveFlash',
      theme: ThemeData
      (
        primaryColor: Colors.white,
        accentColor: Colors.black,
      ),
      debugShowCheckedModeBanner: false,
      home: MainView()
    );
  }
}
