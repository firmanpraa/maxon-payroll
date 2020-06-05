import 'package:payroll/core/config/endpoint.dart';
import 'package:dio/dio.dart';

class CustomerVisitService {
  static Dio dio = new Dio();
  static Future<bool> submitVisit(Map submitData, String token) async {
    bool _isSuccess = false;
    try {
      var response = await dio.post(Endpoint.customerVisit,
          data: FormData.fromMap(submitData),
          options: Options(headers: {
            "Authorization": "Bearer $token"
          }));
      if(response.statusCode == 200){
        _isSuccess = true;
      }
    } catch (e) {
      print("miss exception $e");
    }
    return _isSuccess;
  }
}
