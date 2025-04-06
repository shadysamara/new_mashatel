import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:mashatel/features/customers/blocs/app_get.dart';
import 'package:mashatel/features/sign_in/models/sp_user.dart';
import 'package:mashatel/features/sign_in/models/userApp.dart';
import 'package:mashatel/features/sign_in/providers/signInGetx.dart';
import 'package:mashatel/services/auth.dart';
import 'package:mashatel/utils/custom_dialoug.dart';
import 'package:string_validator/string_validator.dart';

enum UserType { admin, market, customer, unDefined }

class RegistrationClient {
  RegistrationClient._();
  static final RegistrationClient registrationIntance = RegistrationClient._();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseStorage firebaseStorage = FirebaseStorage.instance;
  final SignInGetx signInGetx = Get.put(SignInGetx());

  ///////////////////////////////////////////////////////////////////////////////
  Future<AppUser?> registerAsMarket(AppUser appUser) async {
    try {
      // Ensure the phone number is unique in Firestore
      final QuerySnapshot querySnapshot = await firestore
          .collection('users')
          .where('phoneNumber', isEqualTo: appUser.phoneNumber)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        throw Exception('Phone number already exists');
      }

      appUser.isAdmin = false;
      appUser.isMarket = true;
      appUser.isCustomer = false;

      final Map<String, dynamic> map = appUser.toMarketJson();
      final SpUser? user =
          await Auth.authInstance.registerUsingEmailAndPassword(
        email: appUser.email!,
        password: appUser.password!,
        isAdmin: false,
        isCustomer: false,
        isMarket: true,
      );

      final File file = map['imageFile'] as File;
      final String companyName = map['phoneNumber'] as String;
      final String imagePath = await addMarketImage(file, companyName);

      map['imagePath'] = imagePath;
      map['userId'] = user?.userId;
      map.remove('imageFile');
      appUser.imagePath = imagePath;
      appUser.userId = user?.userId;

      await firestore.collection('users').doc(user?.userId).set(map);
      signInGetx.pr.hide();
      return appUser;
    } catch (error) {
      signInGetx.pr.hide();
      if (error.toString().contains('used_email')) {
        CustomDialougs.utils
            .showDialoug(messageKey: 'exist_account', titleKey: 'alert');
      } else {
        CustomDialougs.utils
            .showDialoug(messageKey: 'user_phone_number', titleKey: 'alert');
      }
      return null;
    }
  }

  ///////////////////////////////////////////////////////////////////////////////
  Future<AppUser> getMarketFromFirestore(String? marketId) async {
    final QuerySnapshot querySnapshot = await firestore
        .collection('users')
        .where('userId', isEqualTo: marketId)
        .get();
    final QueryDocumentSnapshot queryDocumentSnapshot =
        querySnapshot.docs.single;
    return AppUser.fromMarketJson(
        queryDocumentSnapshot.data() as Map<String, dynamic>);
  }

  ///////////////////////////////////////////////////////////////////////////////
  Future<String?> registerAsCustomer(AppUser appUser) async {
    try {
      // Ensure the phone number is unique in Firestore
      final QuerySnapshot querySnapshot = await firestore
          .collection('users')
          .where('phoneNumber', isEqualTo: appUser.phoneNumber)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        throw Exception('Phone number already exists');
      }

      appUser.isAdmin = false;
      appUser.isMarket = false;
      appUser.isCustomer = true;

      final Map<String, dynamic> map = appUser.toCustomerJson();
      final SpUser? user =
          await Auth.authInstance.registerUsingEmailAndPassword(
        email: appUser.email!,
        password: appUser.password!,
        isAdmin: false,
        isCustomer: true,
        isMarket: false,
      );

      map['userId'] = user?.userId;

      await firestore.collection('users').doc(user?.userId).set(map);
      signInGetx.pr.hide();
      return user?.userId;
    } catch (error) {
      signInGetx.pr.hide();
      if (error.toString().contains('used_email')) {
        CustomDialougs.utils
            .showDialoug(messageKey: 'exist_account', titleKey: 'alert');
      } else {
        CustomDialougs.utils
            .showDialoug(messageKey: 'user_phone_number', titleKey: 'alert');
      }
      return null;
    }
  }

  ///////////////////////////////////////////////////////////////////////////////
  Future<void> updateMarketProfile(String userId, AppUser appUser) async {
    try {
      signInGetx.pr.show();
      final Map<String, dynamic> map = appUser.toMarketJson();
      final File file = map['imageFile'] as File;
      final String companyName = map['phoneNumber'] as String;
      final String imagePath = appUser.marketLogo != null
          ? await addMarketImage(file, companyName)
          : appUser.imagePath!;

      map['imagePath'] = imagePath;
      map['userId'] = appUser.userId;
      map.remove('imageFile');
      appUser.imagePath = imagePath;

      await firestore.collection('users').doc(userId).update(map);
      signInGetx.pr.hide();
      await getMarketFromFirestore(userId);
      CustomDialougs.utils.showDialoug(
        messageKey: 'update_success',
        titleKey: 'success',
        function: () {
          Get.back();
          Get.back();
        },
      );
    } catch (e) {
      signInGetx.pr.hide();
      CustomDialougs.utils
          .showDialoug(messageKey: 'update_failed', titleKey: 'alert');
    }
  }

  ///////////////////////////////////////////////////////////////////////////////
  Future<String> addMarketImage(File file, String marketName) async {
    final UploadTask uploadTask =
        firebaseStorage.ref().child('Logos/$marketName.png').putFile(file);
    final TaskSnapshot snapshot = await uploadTask;
    final String imageUrl = await snapshot.ref.getDownloadURL();
    return imageUrl;
  }

  ///////////////////////////////////////////////////////////////////////////////
  Future<AppUser?> loginToApp(String userName, String password) async {
    signInGetx.pr.show();
    try {
      QuerySnapshot event;
      if (isNumeric(userName)) {
        event = await firestore
            .collection("users")
            .where("phoneNumber", isEqualTo: userName)
            .get();
      } else {
        event = await firestore
            .collection("users")
            .where("email", isEqualTo: userName)
            .get();
      }

      if (event.docs.isNotEmpty) {
        final Map<String, dynamic> userData =
            event.docs.single.data() as Map<String, dynamic>;
        final Map<String, bool> userTypeMap = {
          'isAdmin': userData['isAdmin'] as bool,
          'isMarket': userData['isMarket'] as bool,
          'isCustomer': userData['isCustomer'] as bool,
        };
        final UserType type = getUserType(userTypeMap);

        final AppUser _user = type == UserType.market
            ? AppUser.fromMarketJson(userData)
            : AppUser.fromCustomerJson(userData);
        final SpUser? user = await Auth.authInstance.signInWithEmailAndPassword(
          email: _user.email!,
          password: password,
          isAdmin: userData['isAdmin'] as bool,
          isMarket: userData['isMarket'] as bool,
          isCustomer: userData['isCustomer'] as bool,
        );

        signInGetx.pr.hide();
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
      return null;
    }
  }

  ///////////////////////////////////////////////////////////////////////////////
  UserType getUserType(Map<String, bool> map) {
    final bool isAdmin = map['isAdmin']!;
    final bool isMarket = map['isMarket']!;
    // final bool isCustomer = map['isCustomer']!;
    if (isAdmin) {
      return UserType.admin;
    } else if (isMarket) {
      return UserType.market;
    } else {
      return UserType.customer;
    }
  }

  ///////////////////////////////////////////////////////////////////////////////
  Future<void> signOut() async {
    await Auth.authInstance.signOut();
  }
}
