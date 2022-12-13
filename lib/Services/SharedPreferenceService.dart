import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceService extends GetxService
{

  //Initialize할 때 SharedPreference.getInstance() 자체가 비동기 메소드라서
  //이니셜라이즈 되는 시점을 잡아오기 위한 Future
  late Future _doneInit;
  
  //서비스에서 사용할 SharedPref 인스턴스
  late SharedPreferences _sharedPreferences;

  //시점을 잡아오기 위한 future, getter
  Future get initializationDone => _doneInit;


  SharedPreferenceService()
  {
    //_doneInit 퓨처에 init을 걸어놓음
    _doneInit = init();
  }
  
  //이니셜라이즈는 인스턴스를 잡아와 로컬변수에 저장하는거로 끝남
  Future<void> init() async 
  {
     _sharedPreferences = await SharedPreferences.getInstance();
  }

  //아래는 _sharedPreference가 private 변수이기 때문에 원래 기능을 열어주기 위해서 오버라이드 함.
  //차후 기능을 확장하는 부분은 여기에서 진행할 수 있음
  //예를들어 키가 매칭이 안되는 경우 null을 리턴하지 않고 특정 기초값을 반환하는 방식으로 수정함
  bool getBool(String key)
  {
    return _sharedPreferences.getBool(key) ?? false;
  }
  int getInt(String key)
  {
    return _sharedPreferences.getInt(key) ?? 0;
  }
  double getDouble(String key)
  {
    return _sharedPreferences.getDouble(key) ?? 0.0;
  }
  String getString(String key)
  {
    return _sharedPreferences.getString(key) ?? '';
  }
  List<String> getStringList(String key)
  {
    return _sharedPreferences.getStringList(key) ?? List.empty();
  }

  //다른 예시로 _sharedPreferences.set***()메소드를 한군데로 모아
  //put메소드를 만들고 타입에 따라서 알아서 SharedPreference 데이터를 집어넣도록 수정함
  Future<bool> put(String key,dynamic d) async
  {
    switch(d.runtimeType)
    {
      case double:
        return _sharedPreferences.setDouble(key,d);
      case int:
        return _sharedPreferences.setInt(key,d);
      case String:
        return _sharedPreferences.setString(key,d);
      case bool:
        return _sharedPreferences.setBool(key,d);
      default:
        if(d is List<String>)
          return _sharedPreferences.setStringList(key,d);
        else
          return false;
    }
  }

}