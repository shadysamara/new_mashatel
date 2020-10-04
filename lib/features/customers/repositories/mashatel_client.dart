import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:mashatel/features/customers/modles/bigAds.dart';
import 'package:mashatel/features/customers/modles/category.dart';
import 'package:mashatel/features/customers/modles/complaint_model.dart';
import 'package:mashatel/features/customers/modles/product.dart';
import 'package:mashatel/features/customers/modles/subCategory.dart';
import 'package:mashatel/features/customers/modles/terms.dart';

import 'package:mashatel/features/sign_in/providers/signInGetx.dart';
import 'package:mashatel/utils/custom_dialoug.dart';
import 'package:mashatel/features/customers/modles/about.dart';

class MashatelClient {
  MashatelClient._();
  static MashatelClient mashatelClient = MashatelClient._();
  SignInGetx signInGetx = Get.put(SignInGetx());
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseStorage firebaseStorage = FirebaseStorage.instance;
  String collectionName = 'categories';
  String subCollectionName = 'subCategories';
  String productsCollectionName = 'products';
  String miniAdsCollectionName = 'miniAdvertisment';
  String bigAdsCollectionName = 'bigAdvertisment';

  Future<String> uploadImage(File file) async {
    try {
      DateTime dateTime = DateTime.now();
      signInGetx.pr.show();
      StorageTaskSnapshot snapshot = await firebaseStorage
          .ref()
          .child('Images/$dateTime.png')
          .putFile(file)
          .onComplete;
      String imageUrl = await snapshot.ref.getDownloadURL();
      signInGetx.pr.hide();
      return imageUrl;
    } on Exception catch (e) {
      signInGetx.pr.hide();
      CustomDialougs.utils
          .showDialoug(messageKey: e.toString(), titleKey: 'alert');
      return null;
    }
  }

  Future<List<QueryDocumentSnapshot>> getAllCategories() async {
    try {
      // signInGetx.pr.show();
      QuerySnapshot querySnapshot =
          await firestore.collection(collectionName).get();
      List<QueryDocumentSnapshot> queryDocumentSnapshot = querySnapshot.docs;
      // signInGetx.pr.hide();
      return queryDocumentSnapshot;
    } on Exception catch (e) {
      // signInGetx.pr.hide();
      CustomDialougs.utils
          .showDialoug(messageKey: e.toString(), titleKey: 'alert');
      return null;
    }
  }

  Future<String> insertNewCategory(Category category) async {
    try {
      signInGetx.pr.show();
      DocumentReference documentReference =
          await firestore.collection(collectionName).add(category.toJson());
      signInGetx.pr.hide();
      return documentReference.id;
    } on Exception catch (e) {
      signInGetx.pr.hide();
      CustomDialougs.utils
          .showDialoug(messageKey: e.toString(), titleKey: 'alert');
      return null;
    }
  }

  Future<List<QueryDocumentSnapshot>> getAllMarkets(String catId) async {
    try {
      QuerySnapshot querySnapshot = await firestore
          .collection('users')
          .where('isMarket', isEqualTo: true)
          .where('catId', isEqualTo: catId)
          .get();
      List<QueryDocumentSnapshot> queryDocumentSnapshot = querySnapshot.docs;
      signInGetx.pr.hide();
      return queryDocumentSnapshot;
    } on Exception catch (e) {
      signInGetx.pr.hide();
      CustomDialougs.utils
          .showDialoug(messageKey: e.toString(), titleKey: 'alert');
      return null;
    }
  }

  Future<String> addNewSubCategory(SubCategory subCategory) async {
    try {
      signInGetx.pr.show();
      DocumentReference documentReference = await firestore
          .collection(subCollectionName)
          .add(subCategory.toJson());
      signInGetx.pr.hide();
      return documentReference.id;
    } on Exception catch (e) {
      signInGetx.pr.hide();
      CustomDialougs.utils
          .showDialoug(messageKey: e.toString(), titleKey: 'alert');
      return null;
    }
  }

  Future<List<QueryDocumentSnapshot>> getAllProducts(String marketId) async {
    try {
      QuerySnapshot querySnapshot = await firestore
          .collection(productsCollectionName)
          .where('marketId', isEqualTo: marketId)
          .get();
      List<QueryDocumentSnapshot> queryDocumentSnapshot = querySnapshot.docs;
      signInGetx.pr.hide();
      return queryDocumentSnapshot;
    } on Exception catch (e) {
      signInGetx.pr.hide();
      CustomDialougs.utils
          .showDialoug(messageKey: e.toString(), titleKey: 'alert');
      return null;
    }
  }

  Future<String> addNewProduct(Product product) async {
    try {
      signInGetx.pr.show();
      DocumentReference documentReference = await firestore
          .collection(productsCollectionName)
          .add(product.toJson());
      signInGetx.pr.hide();
      return documentReference.id;
    } on Exception catch (e) {
      signInGetx.pr.hide();
      CustomDialougs.utils
          .showDialoug(messageKey: e.toString(), titleKey: 'alert');
      return null;
    }
  }

  Future<String> addNewAdvertisment(String contentAr, String contentEn) async {
    try {
      signInGetx.pr.show();
      DocumentReference documentReference = await firestore
          .collection(miniAdsCollectionName)
          .add({'adContentAr': contentAr, 'adContentEn': contentEn});
      signInGetx.pr.hide();
      return documentReference.id;
    } on Exception catch (e) {
      signInGetx.pr.hide();
      CustomDialougs.utils
          .showDialoug(messageKey: e.toString(), titleKey: 'alert');
      return null;
    }
  }

  Future<List<QueryDocumentSnapshot>> getAllMiniAds() async {
    try {
      QuerySnapshot documentReference =
          await firestore.collection(miniAdsCollectionName).get();
      signInGetx.pr.hide();
      return documentReference.docs;
    } on Exception catch (e) {
      signInGetx.pr.hide();
      CustomDialougs.utils
          .showDialoug(messageKey: e.toString(), titleKey: 'alert');
      return null;
    }
  }

  Future<String> addBigAds(BigAds bigAds) async {
    try {
      signInGetx.pr.show();
      DocumentReference documentReference =
          await firestore.collection(bigAdsCollectionName).add(bigAds.toJson());
      signInGetx.pr.hide();
      return documentReference.id;
    } on Exception catch (e) {
      signInGetx.pr.hide();
      CustomDialougs.utils
          .showDialoug(messageKey: e.toString(), titleKey: 'alert');
      return null;
    }
  }

  Future<List<QueryDocumentSnapshot>> getAllBigAds() async {
    try {
      QuerySnapshot documentReference =
          await firestore.collection(bigAdsCollectionName).get();

      signInGetx.pr.hide();
      return documentReference.docs;
    } on Exception catch (e) {
      signInGetx.pr.hide();
      CustomDialougs.utils
          .showDialoug(messageKey: e.toString(), titleKey: 'alert');
      return null;
    }
  }

  ///////////////////////////////////////////////////////////
  Future<bool> addTermsAndConditions(TermsModel content) async {
    try {
      await firestore.collection('terms').doc('terms').set(content.toJson());
      signInGetx.pr.hide();
      return true;
    } on Exception catch (e) {
      signInGetx.pr.hide();
      CustomDialougs.utils
          .showDialoug(messageKey: e.toString(), titleKey: 'alert');
      return false;
    }
  }

  ///  ///////////////////////////////////////////////////////////
  Future<TermsModel> getTermsAndConditions() async {
    try {
      DocumentSnapshot documentReference =
          await firestore.collection('terms').doc('terms').get();
      TermsModel terms = TermsModel.fromMap(documentReference.data());
      signInGetx.pr.hide();
      return terms;
    } on Exception catch (e) {
      signInGetx.pr.hide();
      CustomDialougs.utils
          .showDialoug(messageKey: e.toString(), titleKey: 'alert');
      return null;
    }
  }

  ///   ///////////////////////////////////////////////////////////
  Future<bool> addAboutApp(AboutAppModel content) async {
    try {
      await firestore
          .collection('aboutApp')
          .doc('aboutApp')
          .set(content.toJson());
      signInGetx.pr.hide();
      return true;
    } on Exception catch (e) {
      signInGetx.pr.hide();
      CustomDialougs.utils
          .showDialoug(messageKey: e.toString(), titleKey: 'alert');
      return false;
    }
  }

  ///   ///////////////////////////////////////////////////////////
  Future<AboutAppModel> getAboutApp() async {
    try {
      DocumentSnapshot documentReference =
          await firestore.collection('aboutApp').doc('aboutApp').get();
      AboutAppModel aboutApp = AboutAppModel.fromMap(documentReference.data());
      signInGetx.pr.hide();
      return aboutApp;
    } on Exception catch (e) {
      signInGetx.pr.hide();
      CustomDialougs.utils
          .showDialoug(messageKey: e.toString(), titleKey: 'alert');
      return null;
    }
  }

  ///   ///////////////////////////////////////////////////////////
  Future<String> addComplaint(ComplaintModel complaintModel) async {
    try {
      DocumentReference documentReference =
          await firestore.collection('complaints').add(complaintModel.toJson());

      signInGetx.pr.hide();
      return documentReference.id;
    } on Exception catch (e) {
      signInGetx.pr.hide();
      CustomDialougs.utils
          .showDialoug(messageKey: e.toString(), titleKey: 'alert');
      return null;
    }
  }
}
