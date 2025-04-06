class TermsModel {
  String? nameAr;
  String? nameEn;
  TermsModel({this.nameAr, this.nameEn});
  TermsModel.fromMap(Map map) {
    print('hi');
    this.nameAr = map['nameAr'];
    this.nameEn = map['nameEn'];
  }
  toJson() {
    return {'nameAr': this.nameAr, 'nameEn': this.nameEn};
  }
}
