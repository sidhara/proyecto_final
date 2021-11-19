//import para la persistencia de datos de configuracion en el sistema
import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService{

  Future saveLoginSettings(LoginSettings settings)async{
    final preferences=await SharedPreferences.getInstance();

    await preferences.setString('email', settings.email!);
    await preferences.setString('password', settings.password!);
    await preferences.setString('username', settings.username!);
  }

  Future deleteLoginSettings()async{
    final preferences=await SharedPreferences.getInstance();
    
    preferences.remove('email');
    preferences.remove('password');
    preferences.remove('username');
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

    return LoginSettings(
      email: email, 
      username: username,
      password: password
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

  LoginSettings({this.email,this.password,this.username});
}

class DarkmodeSetting{
  final bool? darkmode;

  DarkmodeSetting({required this.darkmode});
}