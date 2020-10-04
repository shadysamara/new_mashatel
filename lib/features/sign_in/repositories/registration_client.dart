import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:mashatel/features/sign_in/models/sp_user.dart';

import 'package:mashatel/features/sign_in/models/userApp.dart';
import 'package:mashatel/features/sign_in/providers/signInGetx.dart';
import 'package:mashatel/services/auth.dart';
import 'package:mashatel/utils/custom_dialoug.dart';
import 'package:string_validator/string_validator.dart';

enum userType { admin, market, customer, unDefined }

class RegistrationClient {
  RegistrationClient._();
  static RegistrationClient registrationIntance = RegistrationClient._();
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseStorage firebaseStorage = FirebaseStorage.instance;
  final SignInGetx signInGetx = Get.put(SignInGetx());
/////////////////////////////////////////////////////////////////////////////
  Future<AppUser> registerAsMarket(AppUser appUser) async {
    try {
      // ensure that the phone number is uniqye in the firestore

      QuerySnapshot querySnapshot = await firestore
          .collection('users')
          .where('phoneNumber', isEqualTo: appUser.phoneNumber)
          .get();

      assert(querySnapshot.docs.length == 0);
      appUser.isAdmin = false;
      appUser.isMarket = true;
      appUser.isCustomer = false;

      Map<String, dynamic> map = appUser.toMarketJson();
      SpUser user = await Auth.authInstance.registerUsingEmailAndPassword(
          email: appUser.email,
          password: appUser.password,
          isAdmin: false,
          isCustomer: false,
          isMarket: true);
      File file = map['imageFile'];
      String companyName = map['phoneNumber'];
      String imagePath = await addMarketImage(file, companyName);

      map['imagePath'] = imagePath;
      map['userId'] = user.userId;
      map.remove('imageFile');
      appUser.imagePath = imagePath;
      appUser.userId = user.userId;

      await firestore.collection('users').doc(user.userId).set(map);
      // AppUser appUser = AppUser.fromMarketJson(map);

      return appUser;
    } catch (error) {
      signInGetx.pr.hide();
      if (error.toString() == 'used_email') {
        CustomDialougs.utils
            .showDialoug(messageKey: 'exist_account', titleKey: 'alert');
      } else {
        CustomDialougs.utils
            .showDialoug(messageKey: 'user_phone_number', titleKey: 'alert');
      }

      return null;
    }
  }

/////////////////////////////////////////////////////////////////////////////
  Future<AppUser> getMarketFromFirestore(String marketId) async {
    QuerySnapshot querySnapshot = await firestore
        .collection('users')
        .where('userId', isEqualTo: marketId)
        .get();
    QueryDocumentSnapshot queryDocumentSnapshot = querySnapshot.docs.single;
    AppUser appUser = AppUser.fromMarketJson(queryDocumentSnapshot.data());
    return appUser;
  }

/////////////////////////////////////////////////////////////////////////////
  Future<String> registerAsCustomer(AppUser appUser) async {
    try {
      // ensure that the phone number is uniqye in the firestore

      QuerySnapshot querySnapshot = await firestore
          .collection('users')
          .where('phoneNumber', isEqualTo: appUser.phoneNumber)
          .get();

      assert(querySnapshot.docs.length == 0);
      appUser.isAdmin = false;
      appUser.isMarket = false;
      appUser.isCustomer = true;

      Map<String, dynamic> map = appUser.toCustomerJson();
      SpUser user = await Auth.authInstance.registerUsingEmailAndPassword(
          email: appUser.email,
          password: appUser.password,
          isAdmin: false,
          isCustomer: true,
          isMarket: false);

      map['userId'] = user.userId;

      await firestore.collection('users').doc(user.userId).set(map);
      return user.userId;
    } catch (error) {
      signInGetx.pr.hide();
      if (error.toString() == 'used_email') {
        CustomDialougs.utils
            .showDialoug(messageKey: 'exist_account', titleKey: 'alert');
      } else {
        CustomDialougs.utils
            .showDialoug(messageKey: 'user_phone_number', titleKey: 'alert');
      }

      return null;
    }
  }

/////////////////////////////////////////////////////////////////////////////////

/////////////////////////////////////////////////////////////////////////////////
  updateMarketProfile(String userId, AppUser appUser) {
    firestore.collection('users').doc(userId).update(appUser.toMarketJson());
  }

  Future<String> addMarketImage(File file, String marketName) async {
    StorageTaskSnapshot snapshot = await firebaseStorage
        .ref()
        .child('Logos/$marketName.png')
        .putFile(file)
        .onComplete;
    String imageUrl = await snapshot.ref.getDownloadURL();
    return imageUrl;
  }

//////////////////////////////////////////////////////////////////////////////
  Future<AppUser> loginToApp(String userName, String password) async {
    signInGetx.pr.show();
    if (isNumeric(userName)) {
      try {
        QuerySnapshot event = await firestore
            .collection("users")
            .where("phoneNumber", isEqualTo: userName)
            .get();
        if (event.docs.isNotEmpty) {
          Map<String, dynamic> userData = event.docs.single.data();
          Map userTypeMap = {
            'isAdmin': userData['isAdmin'],
            'isMarket': userData['isMarket'],
            'isCustomer': userData['isCustomer'],
          };
          userType type = getUserType(userTypeMap);

          AppUser _user = type == userType.market
              ? AppUser.fromMarketJson(userData)
              : AppUser.fromCustomerJson(userData);
          SpUser user = await Auth.authInstance.signInWithEmailAndPassword(
            email: _user.email,
            password: password,
            isAdmin: userData['isAdmin'],
            isMarket: userData['isMarket'],
            isCustomer: userData['isCustomer'],
          );

          return user != null ? _user : null;
        } else {
          signInGetx.pr.hide();
          CustomDialougs.utils
              .showDialoug(messageKey: 'username_not_found', titleKey: 'alert');

          return null;
        }
      } catch (e) {
        signInGetx.pr.hide();
        CustomDialougs.utils
            .showDialoug(messageKey: e.toString(), titleKey: 'alert');
      }
    } else {
      try {
        QuerySnapshot event = await firestore
            .collection("users")
            .where("email", isEqualTo: userName)
            .get();

        if (event.docs.isNotEmpty) {
          Map<String, dynamic> userData = event.docs.single.data();
          Map userTypeMap = {
            'isAdmin': userData['isAdmin'],
            'isMarket': userData['isMarket'],
            'isCustomer': userData['isCustomer'],
          };
          userType type = getUserType(userTypeMap);

          AppUser _user = type == userType.market
              ? AppUser.fromMarketJson(userData)
              : AppUser.fromCustomerJson(userData);
          SpUser user = await Auth.authInstance.signInWithEmailAndPassword(
            email: _user.email,
            password: password,
            isAdmin: userData['isAdmin'],
            isMarket: userData['isMarket'],
            isCustomer: userData['isCustomer'],
          );

          return user != null ? _user : null;
        } else {
          signInGetx.pr.hide();
          CustomDialougs.utils
              .showDialoug(messageKey: 'username_not_found', titleKey: 'alert');

          return null;
        }
      } catch (e) {
        signInGetx.pr.hide();
        CustomDialougs.utils
            .showDialoug(messageKey: e.toString(), titleKey: 'alert');
      }
    }
  }

  //////////////////////////////////////////////////////////
  userType getUserType(Map map) {
    bool isAdmin = map['isAdmin'];
    bool isMarket = map['isMarket'];
    // bool isCustomer = map['isCustomer'];
    if (isAdmin) {
      return userType.admin;
    } else if (isMarket) {
      return userType.market;
    } else {
      return userType.customer;
    }
  }

  ///////////////////////////////////////////////////////////
  signOut() {
    Auth.authInstance.signOut();
  }
}
