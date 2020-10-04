import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mashatel/features/customers/modles/bigAds.dart';
import 'package:mashatel/features/customers/modles/category.dart';
import 'package:mashatel/features/customers/modles/product.dart';
import 'package:mashatel/features/customers/modles/subCategory.dart';
import 'package:mashatel/features/customers/repositories/mashatel_client.dart';
import 'package:mashatel/features/sign_in/models/userApp.dart';
import 'package:mashatel/utils/custom_dialoug.dart';

class MashatelRepository {
  MashatelRepository._();
  static MashatelRepository mashatelRepository = MashatelRepository._();
  Future<List<Category>> getAllCategories() async {
    try {
      List<QueryDocumentSnapshot> snapshots =
          await MashatelClient.mashatelClient.getAllCategories();
      List<Category> categories =
          snapshots.map((e) => Category.fromMap(e)).toList();
      return categories;
    } on Exception catch (e) {
      CustomDialougs.utils
          .showDialoug(messageKey: e.toString(), titleKey: 'alert');
      return null;
    }
  }

  Future<List<AppUser>> getAllMarkets(String catId) async {
    try {
      List<QueryDocumentSnapshot> snapshots =
          await MashatelClient.mashatelClient.getAllMarkets(catId);
      List<AppUser> markets =
          snapshots.map((e) => AppUser.fromMarketJson(e.data())).toList();
      return markets;
    } on Exception catch (e) {
      CustomDialougs.utils
          .showDialoug(messageKey: e.toString(), titleKey: 'alert');
      return null;
    }
  }

  Future<List<Product>> getAllProducts(String marketId) async {
    try {
      List<QueryDocumentSnapshot> snapshots =
          await MashatelClient.mashatelClient.getAllProducts(marketId);
      List<Product> products =
          snapshots.map((e) => Product.fromMap(e.data())).toList();
      return products;
    } on Exception catch (e) {
      CustomDialougs.utils
          .showDialoug(messageKey: e.toString(), titleKey: 'alert');
      return null;
    }
  }

  Future<List<BigAds>> getAllBigAdsImages() async {
    try {
      List<QueryDocumentSnapshot> querySnapshots =
          await MashatelClient.mashatelClient.getAllBigAds();
      List<BigAds> bigads =
          querySnapshots.map((e) => BigAds.fromMap(e.data())).toList();
      return bigads;
    } on Exception catch (e) {
      CustomDialougs.utils
          .showDialoug(messageKey: e.toString(), titleKey: 'alert');
      return null;
    }
  }

  Future<List<String>> getAllMiniAds() async {
    List<QueryDocumentSnapshot> snapshots =
        await MashatelClient.mashatelClient.getAllMiniAds();
    List<String> ads =
        snapshots.map((e) => e.data()['adContent'].toString()).toList();
    return ads;
  }
}
