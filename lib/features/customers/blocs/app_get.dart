import 'dart:io';
import 'package:get/get.dart';
import 'package:mashatel/features/customers/modles/about.dart';
import 'package:mashatel/features/customers/modles/advertisment.dart';
import 'package:mashatel/features/customers/modles/category.dart';
import 'package:mashatel/features/customers/modles/product_model.dart';
import 'package:mashatel/features/customers/modles/terms.dart';
import 'package:mashatel/features/customers/repositories/mashatel_client.dart';
import 'package:mashatel/features/sign_in/models/userApp.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

class AppGet {
  var allCategories = <Category>[].obs;
  var markets = <AppUser>[].obs;
  var imagePath = ''.obs;
  var catId = ''.obs;
  var appUser = AppUser().obs;
  var localImageFilePath = ''.obs;
  var marketId = ''.obs;
  var images = <Asset>[].obs;
  var products = <ProductModel>[].obs;
  var advertisments = <Advertisment>[].obs;
  AboutAppModel aboutAppModel;
  TermsModel termsModel;

  setAdvertisments(List<Advertisment> ads) {
    this.advertisments.value = ads;
  }

  setImagesAssets(List<Asset> images) {
    this.images.value = images;
  }

  deleteAssetImage(Asset asset) {
    int index = this.images.indexOf(asset);

    this.images.removeAt(index);
  }

  setAppUser(AppUser appUser) {
    this.appUser.value = appUser;
  }

  setAboutModel(AboutAppModel aboutAppModel) {
    this.aboutAppModel = aboutAppModel;
  }

  setTermsModel(TermsModel termsModel) {
    this.termsModel = termsModel;
  }

  setMarketId(String marketId) {
    this.marketId.value = marketId;
  }

  clearMarketId() {
    this.marketId.value = '';
  }

  clearVariables() {
    this.imagePath = ''.obs;
    this.catId = ''.obs;
    this.appUser = AppUser().obs;
    this.localImageFilePath = ''.obs;
    this.marketId = ''.obs;
    this.products = <ProductModel>[].obs;
  }

  setLocalImageFile(File file) {
    this.localImageFilePath.value = file.path;
  }

  setUserId(AppUser appUser) {
    this.appUser.value = appUser;
  }

  getAllCategories() async {
    print('hi');
    List<Category> categories =
        await MashatelClient.mashatelClient.getAllCategories();
    this.allCategories.value = categories;
    print(categories.length);
  }

  getAllMarkets(String catId) async {
    List<AppUser> markets =
        await MashatelClient.mashatelClient.getAllMarkets(catId);
    this.markets.value = markets;
  }

  getMarketProducts(String marketId) async {
    List<ProductModel> products =
        await MashatelClient.mashatelClient.getAllProducts(marketId);

    this.products.value = products;
  }

  Future<String> addNewCategory(Category category) async {
    category.imagePath = this.imagePath.value;
    String catId =
        await MashatelClient.mashatelClient.insertNewCategory(category);
    this.catId.value = catId;
    this.imagePath.value = '';
    return catId;
  }

  Future<String> uploadImage(File file) async {
    String imageUrl = await MashatelClient.mashatelClient.uploadImage(file);
    this.imagePath.value = imageUrl;
    return imageUrl;
  }

  setCatId(String id) {
    this.catId.value = id;
  }

  // getRandomAd() {
  //   final _random = new Random();
  //   String element = miniAdsUrls[_random.nextInt(miniAdsUrls.length)];
  //   this.minAd.value = element;
  // }

}
