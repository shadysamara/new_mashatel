class AboutAppModel {
  String? nameAr;
  String? nameEn;
  AboutAppModel({this.nameAr, this.nameEn});
  AboutAppModel.fromMap(Map map) {
    this.nameAr = map['nameAr'];
    this.nameEn = map['nameEn'];
  }
  toJson() {
    return {'nameAr': this.nameAr, 'nameEn': this.nameEn};
  }
}
