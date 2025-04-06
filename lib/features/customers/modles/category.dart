import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Category extends Equatable {
  String? nameAr;
  String? nameEn;
  String? imagePath;
  String? catId;
  Category({this.catId, this.imagePath, this.nameAr, this.nameEn});
  Category.fromMap(Map<String, dynamic> map) {
    this.nameAr = map['nameAr'];
    this.nameEn = map['nameEn'];
    this.imagePath = map['imagePath'];
    this.catId = map['id'];
  }
  Map<String, dynamic> toJson() {
    return {
      'nameAr': this.nameAr,
      'nameEn': this.nameEn,
      'imagePath': this.imagePath
    };
  }

  @override
  // TODO: implement props
  List<Object?> get props => [catId];
}
