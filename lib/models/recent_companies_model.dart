import 'package:cloud_firestore/cloud_firestore.dart';

class RecentCompanyModel {
  String id;
  String name;
  String pic;
  DateTime time;

  String firstName;
  String secondName;
  String email;
  String postCode;
  String address;
  String accountNumber;

  RecentCompanyModel({
    this.id,
    this.name,
    this.time,
    this.pic,
    this.email,
    this.address,
    this.accountNumber,
    this.firstName,
    this.postCode,
    this.secondName,
  });

  RecentCompanyModel.fromMap(Map<dynamic, dynamic> map) {
    this.id = map['id'] ?? '';
    this.name = map['companyName'] ?? '';
    this.pic = map['companyPic'] ?? '';
    this.time =
        Timestamp.fromMillisecondsSinceEpoch(map['time'].millisecondsSinceEpoch)
                .toDate() ??
            '';
    this.firstName = map['firstName'] ?? '';
    this.secondName = map['secondName'] ?? '';
    this.address = map['address'] ?? '';
    this.postCode = map['postCode'] ?? '';
    this.accountNumber = map['accountNumer'] ?? '';
    this.email = map['email'] ?? '';
  }
}
