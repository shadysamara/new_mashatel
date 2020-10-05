import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:mashatel/features/customers/modles/product_model.dart';
import 'package:mashatel/features/customers/modles/bigAds.dart';
import 'package:mashatel/features/customers/modles/category.dart';
import 'package:mashatel/features/customers/modles/complaint_model.dart';
import 'package:mashatel/features/customers/modles/product.dart';
import 'package:mashatel/features/customers/modles/subCategory.dart';
import 'package:mashatel/features/customers/modles/terms.dart';
import 'package:mashatel/features/sign_in/models/userApp.dart';

import 'package:mashatel/features/sign_in/providers/signInGetx.dart';
import 'package:mashatel/utils/custom_dialoug.dart';
import 'package:mashatel/features/customers/modles/about.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

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

  ///  ///////////////////////////////////////////////////////////
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

  ///  ///////////////////////////////////////////////////////////
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

  ///  ///////////////////////////////////////////////////////////
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

  ///  ///////////////////////////////////////////////////////////
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
      if (documentReference.data() != null) {
        TermsModel terms = TermsModel.fromMap(documentReference.data());
        signInGetx.pr.hide();
        return terms;
      } else {
        return null;
      }
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
      if (documentReference.data() != null) {
        AboutAppModel aboutApp =
            AboutAppModel.fromMap(documentReference.data());
        signInGetx.pr.hide();
        return aboutApp;
      } else {
        return null;
      }
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

///////////////////////////////////////////////////////////////////////
  Future<List<ProductModel>> getAllAddvertisments() async {
    try {
      QuerySnapshot documentReference =
          await firestore.collection('advertisments').get();
      List<ProductModel> ads = documentReference.docs
          .map((e) => ProductModel.fromMap(e.data()))
          .toList();
      signInGetx.pr.hide();
      return ads;
    } on Exception catch (e) {
      signInGetx.pr.hide();
      CustomDialougs.utils
          .showDialoug(messageKey: e.toString(), titleKey: 'alert');
      return null;
    }
  }

  ///////////////////////////////////////////////////////////////////
  Future<String> saveAssetImage(Asset asset, String marketId) async {
    try {
      DateTime dateTime = DateTime.now();

      ByteData byteData =
          await asset.getByteData(); // requestOriginal is being deprecated
      List<int> imageData = byteData.buffer.asUint8List();
      StorageTaskSnapshot snapshot = await firebaseStorage
          .ref()
          .child('products/$marketId/$dateTime.png')
          .putData(imageData)
          .onComplete;
      String imageUrl = await snapshot.ref.getDownloadURL();

      return imageUrl;
    } on Exception catch (e) {
      CustomDialougs.utils
          .showDialoug(messageKey: e.toString(), titleKey: 'alert');
      return null;
    }
  }

  ////////////////////////////////////////////////////////////////
  Future<List<String>> uploadAllImages(
      List<Asset> assets, String marketName) async {
    List<String> urls = [];
    for (int i = 0; i < assets.length; i++) {
      String url = await saveAssetImage(assets[i], marketName);
      urls.add(url);
    }
    return urls;
  }

  ///   ///////////////////////////////////////////////////////////
  Future<String> addNewProductWithManyImages(
      ProductModel productModel, AppUser appUser) async {
    try {
      List<Asset> assetImages = productModel.assetImages;
      List<String> urls = await uploadAllImages(assetImages, appUser.userName);

      productModel.imagesUrls = urls;

      print(productModel.toJson());
      DocumentReference documentReference =
          await firestore.collection('products').add(productModel.toJson());

      return 'documentReference.id';
    } on Exception catch (e) {
      CustomDialougs.utils
          .showDialoug(messageKey: e.toString(), titleKey: 'alert');
      return null;
    }
  }
}
