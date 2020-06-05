class UserModel {
  String name = "";
  String photo = "";
  String department = "";
  String position = "";
  int codeStatus;

  UserModel();

  UserModel.fromJson(Map<String, dynamic> json, int codeStatus) {
    var employee = json['data']['employee_information'];
    name = employee['name'];
    photo = employee['photo'];
    department = employee['department'];
    position = employee['position'];
    this.codeStatus = codeStatus;
  }
}
