// import 'dart:io';

// class Market {
//   String companyName;

//   String userName;

//   String password;

//   String email;

//   String phoneNumber;

//   File marketLogo;

//   String imagePath;

//   double lat;

//   double lon;

//   String comapnyActivity;

//   Market(
//       {this.comapnyActivity,
//       this.companyName,
//       this.email,
//       this.imagePath,
//       this.marketLogo,
//       this.password,
//       this.phoneNumber,
//       this.lat,
//       this.lon,
//       this.userName});

//   Market.fromJson(Map map) {
//     this.companyName = map['companyName'];
//     this.comapnyActivity = map['companyActivity'];
//     this.email = map['email'];
//     this.phoneNumber = map['phoneNumber'];
//     this.userName = map['userName'];
//     this.lat = map['latitude'];
//     this.lon = map['longitude'];
//     this.imagePath = map['imagePath'];
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'companyName': this.companyName,
//       'companyActivity': this.comapnyActivity,
//       'email': this.email,
//       'imageFile': this.marketLogo,
//       'phoneNumber': this.phoneNumber,
//       'userName': this.userName,
//       'latitude': this.lat,
//       'longitude': this.lon,
//       'type': 'market'
//     };
//   }
// }
