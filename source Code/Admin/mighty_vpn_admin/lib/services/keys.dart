class CommonKeys {
  String uid = "uid";
  String createdAt = "createdAt";
  String updatedAt = "updatedAt";
}

CommonKeys commonKeys = CommonKeys();

class Collection {
  String user = "user";
  String server = "server";
}

Collection collections = Collection();

class UserKeys {
  String uid = commonKeys.uid;
  String firstName = "firstName";
  String email = "email";
  String photoUrl = "photoUrl";
  String password = "password";
  String isEmailLogin = "isEmailLogin";
  String isTester = "isTester";
  String userRole = "userRole";
  String createdAt = commonKeys.createdAt;
  String updatedAt = commonKeys.updatedAt;
}

UserKeys userKeys = UserKeys();

class ServerKey {
  String uid = commonKeys.uid;
  String name = "name";
  String flag = "flag";
  String ovpnFile = "ovpnFile";
  String userName = "userName";
  String password = "password";
  String isActive = "isActive";
  String createdAt = commonKeys.createdAt;
  String updatedAt = commonKeys.updatedAt;
}

ServerKey serverKey = ServerKey();
