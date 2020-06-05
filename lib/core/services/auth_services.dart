import 'package:payroll/core/config/endpoint.dart';
import 'package:payroll/core/models/auth_model.dart';
import 'package:payroll/core/models/user_model.dart';
import 'package:payroll/core/storage/local_model.dart';
import 'package:payroll/core/utils/toast_utils.dart';
import 'package:dio/dio.dart';
import 'package:localstorage/localstorage.dart';
class AuthServices {
  static Dio dio = new Dio();

  static Future<auth_model> login(Map loginData) async {
    var model;
    try {
      var response = await dio.post(Endpoint.login,
          data: FormData.fromMap(loginData),
          options: Options(headers: {"Accept": "application/json"}));
      model = auth_model.fromJson(response.data, response.statusCode);
    } catch (e) {
      print(e);
    }
    return model;
  }

  static Future<UserModel> getUserInformation(String token) async {
    var model;
    try {
      var response = await dio.get(Endpoint.employeeInformation,
          options: Options(headers: {
            "Accept": "application/json",
            "Authorization": "Bearer $token"
          }));
      model = UserModel.fromJson(response.data, response.statusCode);
    } catch (e) {
      print(e);
    }
    return model;
  }

  static Future<bool> checkStillAuth(UserLocal userLocal) async {
    var _response = await AuthServices.getUserInformation(userLocal.token);
    if(_response == null){
      ToastUtils.show("Your account has been logged in another device, please login again");
      LocalStorage localStorage = new LocalStorage(storageName);
      if(await localStorage.ready){
        await localStorage.clear();
      }
      return false;
    }else{
      return true;
    }
  }
}


