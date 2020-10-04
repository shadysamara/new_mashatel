class SubCategory {
  String nameAr;
  String nameEn;
  String descAr;
  String descEn;
  String imageUrl;
  String subCatId;
  String catId;
  SubCategory(
      {this.descAr, this.descEn, this.imageUrl, this.nameAr, this.nameEn});
  SubCategory.fromMap(Map map) {
    this.nameAr = map['nameAr'];
    this.nameEn = map['nameEn'];
    this.descAr = map['descAr'];
    this.descEn = map['descEn'];
    this.imageUrl = map['imageUrl'];
    this.subCatId = map['subCatId'];
    this.catId = map['catId'];
  }
  Map<String, dynamic> toJson() {
    return {
      'nameAr': this.nameAr,
      'nameEn': this.nameEn,
      'descAr': this.descAr,
      'descEn': this.descEn,
      'catId': this.catId,
      'imageUrl': this.imageUrl,
    };
  }
}
