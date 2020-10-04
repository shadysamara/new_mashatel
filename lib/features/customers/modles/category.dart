import 'package:cloud_firestore/cloud_firestore.dart';

class Category {
  String nameAr;
  String nameEn;
  String imagePath;
  String catId;
  Category({this.catId, this.imagePath, this.nameAr, this.nameEn});
  Category.fromMap(DocumentSnapshot map) {
    this.nameAr = map.data()['nameAr'];
    this.nameEn = map.data()['nameEn'];
    this.imagePath = map.data()['imagePath'];
    this.catId = map.id;
  }
  Map<String, dynamic> toJson() {
    return {
      'nameAr': this.nameAr,
      'nameEn': this.nameEn,
      'imagePath': this.imagePath
    };
  }

  bool operator ==(dynamic other) =>
      other != null && other is Category && this.catId == other.catId;
}
