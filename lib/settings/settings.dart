//import para la persistencia de datos de configuracion en el sistema
import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService{

  Future saveLoginSettings(LoginSettings settings)async{
    final preferences=await SharedPreferences.getInstance();

    await preferences.setString('email', settings.email!);
    await preferences.setString('password', settings.password!);
    await preferences.setString('username', settings.username!);
  }

  Future saveDeviceId(String deviceId)async{
    final preferences=await SharedPreferences.getInstance();
    await preferences.setString('deviceId', deviceId);
  }

  Future deleteLoginSettings()async{
    final preferences=await SharedPreferences.getInstance();
    
    preferences.remove('email');
    preferences.remove('password');
    preferences.remove('username');
    preferences.remove('deviceId');
    preferences.remove('darkmode');
  }

  Future saveDarkmodeSettings(DarkmodeSetting settings)async{
    final preferences=await SharedPreferences.getInstance();
    await preferences.setBool('darkmode', settings.darkmode!);
  } 

  Future<LoginSettings>getLoginSettings()async{
    final preferences=await SharedPreferences.getInstance();
    final String? email=preferences.getString('email');
    final String? username=preferences.getString('username');
    final String? password=preferences.getString('password');
    final String? deviceId=preferences.getString('deviceId');

    return LoginSettings(
      email: email, 
      username: username,
      password: password,
      deviceId: deviceId
    );
  }

  Future<DarkmodeSetting>getDarkmodeSettings()async{
    final preferences=await SharedPreferences.getInstance();
    final bool? darkmode=preferences.getBool('darkmode');

    return DarkmodeSetting(darkmode: darkmode);
  }
}

class LoginSettings{
  final String? email;
  final String? username;
  final String? password;
  final String? deviceId;

  LoginSettings({this.email,this.password,this.username,this.deviceId});
}

class DarkmodeSetting{
  final bool? darkmode;

  DarkmodeSetting({required this.darkmode});
}