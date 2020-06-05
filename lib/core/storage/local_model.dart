final String storageName = "payroll.json";

final String keyUserLocal = "keyUser";

class UserLocal {
  String token;
  bool isLogin = false;
  String nikEmployee;

  UserLocal({this.token, this.isLogin, this.nikEmployee});

  toJSONEncodeAble() {
    Map<String, dynamic> m = new Map();
    m['token'] = this.token;
    m['isLogin'] = this.isLogin;
    m['nikEmployee'] = this.nikEmployee;
    return m;
  }

  fromJson(Map<String, dynamic> json) {
    print("hasil: $json");
    this.token = json['token'];
    if (json['isLogin'] != null) {
      this.isLogin = json['isLogin'];
    }
    this.nikEmployee = json['nikEmployee'];
  }
}

final String keyCustomerVisitLocal = "keyCustomer";

class LocalCustomerVisit {
  String status;
  String startIn;
  List<TodoIn> items;

  LocalCustomerVisit(
      {this.status, this.startIn}){
    items = new List();
  }

  toJsonEncodeAble() {
    Map<String, dynamic> m = new Map();
    m['status'] = this.status;
    m['startIn'] = this.startIn;
    m['items'] = items.map((e) => e.toJsonEncodeAble()).toList();
    return m;
  }

  fromJson(Map<String, dynamic> json) {
    if (json['status'] != null) {
      this.status = json['status'];
    }
    this.startIn = json['startIn'];
    var localItems = json['items'];
    if (localItems != null) {
      this.items = List<TodoIn>.from((localItems as List).map((item) => TodoIn(
          latitude: item['latitude'],
          longitude: item['longitude'],
          message: item['message'])));
    }
  }
}

class TodoIn {
  String message;
  double latitude;
  double longitude;

  TodoIn({this.message, this.latitude, this.longitude});

  toJsonEncodeAble() {
    Map<String, dynamic> m = new Map();
    m['message'] = this.message;
    m['latitude'] = this.latitude;
    m['longitude'] = this.longitude;
    return m;
  }
}
