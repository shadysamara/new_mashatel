class BigAds {
  String contentAr;
  String contentEn;
  String imageUrl;
  BigAds({this.contentAr, this.contentEn, this.imageUrl});
  BigAds.fromMap(Map map) {
    this.contentAr = map['contentAr'];
    this.contentEn = map['contentEn'];
    this.imageUrl = map['imageUrl'];
  }
  Map<String, dynamic> toJson() {
    return {
      'contentAr': this.contentAr,
      'contentEn': this.contentEn,
      'imageUrl': this.imageUrl,
    };
  }
}
