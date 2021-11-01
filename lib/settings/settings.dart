//import para la persistencia de datos de configuracion en el sistema
import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService{

  Future saveLoginSettings(LoginSettings settings)async{
    final preferences=await SharedPreferences.getInstance();

    await preferences.setString('email', settings.email!);
    await preferences.setString('password', settings.password!);
  }

  Future saveDarkmodeSettings(DarkmodeSetting settings)async{
    final preferences=await SharedPreferences.getInstance();
    await preferences.setBool('darkmode', settings.darkmode!);
  } 

  Future<LoginSettings>getLoginSettings()async{
    final preferences=await SharedPreferences.getInstance();
    final String? email=preferences.getString('email');
    final String? password=preferences.getString('password');

    return LoginSettings(
      email: email, 
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
  final String? password;

  LoginSettings({this.email,this.password});
}

class DarkmodeSetting{
  final bool? darkmode;

  DarkmodeSetting({required this.darkmode});
}