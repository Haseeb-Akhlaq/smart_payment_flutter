import 'package:cloud_firestore/cloud_firestore.dart';

class LocalCompanyModel {
  String id;
  String name;
  String pic;
  List tags;
  DateTime time;

  LocalCompanyModel({
    this.id,
    this.name,
    this.tags,
    this.pic,
  });

  LocalCompanyModel.fromMap(map) {
    this.id = map['id'] ?? '';
    this.name = map['companyName'] ?? '';
    this.pic = map['companyPic'] ?? '';
    this.time =
        Timestamp.fromMillisecondsSinceEpoch(map['time'].millisecondsSinceEpoch)
                .toDate() ??
            '';
  }
}
