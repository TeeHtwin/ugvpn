import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mighty_vpn_admin/services/keys.dart';

class ServerModel {
  Timestamp? createdAt;
  String? flag;
  bool? isActive;
  String? name;
  String? ovpnFile;
  String? password;
  String? uid;
  Timestamp? updatedAt;
  String? userName;

  ServerModel({
    this.createdAt,
    this.flag,
    this.isActive,
    this.name,
    this.ovpnFile,
    this.password,
    this.uid,
    this.updatedAt,
    this.userName,
  });

  factory ServerModel.fromJson(Map<String, dynamic> json) {
    return ServerModel(
      createdAt: json[serverKey.createdAt],
      flag: json[serverKey.flag],
      isActive: json[serverKey.isActive],
      name: json[serverKey.name],
      ovpnFile: json[serverKey.ovpnFile],
      password: json[serverKey.password],
      uid: json[serverKey.uid],
      updatedAt: json[serverKey.updatedAt],
      userName: json[serverKey.userName],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data[serverKey.createdAt] = this.createdAt;
    data[serverKey.flag] = this.flag;
    data[serverKey.isActive] = this.isActive;
    data[serverKey.name] = this.name;
    data[serverKey.ovpnFile] = this.ovpnFile;
    data[serverKey.password] = this.password;
    data[serverKey.uid] = this.uid;
    data[serverKey.updatedAt] = this.updatedAt;
    data[serverKey.userName] = this.userName;
    return data;
  }
}
