class Advertisment {
  String? imageUrl;
  String? url;
  String? id;
  bool? isActive;
  Advertisment({this.imageUrl, this.url});
  Advertisment.fromMap(Map map) {
    this.imageUrl = map['imageUrl'];
    this.url = map['url'];
    this.id = map['adId'];
    this.isActive = map['isActive'];
  }
  Map<String, dynamic> toJson() {
    return {'imageUrl': this.imageUrl, 'url': this.url, 'isActive': true};
  }
}
