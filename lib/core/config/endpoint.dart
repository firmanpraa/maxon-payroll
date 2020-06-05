class Endpoint {
  static String _baseURL =
      'http://maxon.zapto.org:8080/api/';
  static String login = '$_baseURL/auth/login';
  static String employeeInformation = '$_baseURL/employee/employee-information';
  static String logout = '$_baseURL/auth/logout';
  static String customerVisit = '$_baseURL/employee/customer-visit';
  static String basePhotoUrl = 'http://maxon.zapto.org:8080/uploads/employee-photo/';
}
