class Advertisment {
  String imageUrl;
  String url;
  Advertisment({this.imageUrl, this.url});
  Advertisment.fromMap(Map map) {
    this.imageUrl = map['imageUrl'];
    this.url = map['url'];
  }
  Map<String, dynamic> toJson() {
    return {'imageUrl': this.imageUrl, 'url': this.url};
  }
}
