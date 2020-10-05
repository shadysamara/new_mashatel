import 'dart:io';
import 'dart:math';

import 'package:get/get.dart';
import 'package:mashatel/features/customers/modles/about.dart';
import 'package:mashatel/features/customers/modles/bigAds.dart';
import 'package:mashatel/features/customers/modles/category.dart';
import 'package:mashatel/features/customers/modles/product.dart';
import 'package:mashatel/features/customers/modles/subCategory.dart';
import 'package:mashatel/features/customers/modles/terms.dart';
import 'package:mashatel/features/customers/repositories/mashatel_client.dart';
import 'package:mashatel/features/customers/repositories/mashatel_repository.dart';
import 'package:mashatel/features/sign_in/models/userApp.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

class AppGet {
  var allCategories = <Category>[].obs;
  var markets = <AppUser>[].obs;
  var allProducts = <Product>[].obs;
  var imagePath = ''.obs;
  var catId = ''.obs;
  var subCatId = ''.obs;
  var productId = ''.obs;
  var mainAdsImagesUrls = <BigAds>[].obs;
  var miniAdsUrls = <String>[].obs;
  var minAd = ''.obs;
  var appUser = AppUser().obs;
  var localImageFilePath = ''.obs;
  var marketId = ''.obs;
  var images = <Asset>[].obs;
  AboutAppModel aboutAppModel;
  TermsModel termsModel;
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
    this.subCatId = ''.obs;
    this.productId = ''.obs;
    this.minAd = ''.obs;
    this.appUser = AppUser().obs;
    this.localImageFilePath = ''.obs;
    this.marketId = ''.obs;
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
        await MashatelRepository.mashatelRepository.getAllCategories();
    this.allCategories.value = categories;
    print(categories.length);
  }

  getAllMarkets(String catId) async {
    List<AppUser> markets =
        await MashatelRepository.mashatelRepository.getAllMarkets(catId);
    this.markets.value = markets;
  }

  getAllProducts(String marketId) async {
    List<Product> products =
        await MashatelRepository.mashatelRepository.getAllProducts(marketId);
    print(products.length);
    this.allProducts.value = products;
  }

  Future<String> addNewCategory(Category category) async {
    category.imagePath = this.imagePath.value;
    String catId =
        await MashatelClient.mashatelClient.insertNewCategory(category);
    this.catId.value = catId;
    this.imagePath.value = '';
    return catId;
  }

  Future<String> addNewProduct(Product product) async {
    product.imageUrl = this.imagePath.value;
    String productId =
        await MashatelClient.mashatelClient.addNewProduct(product);
    this.productId.value = productId;
    this.imagePath.value = '';
    getAllProducts(this.marketId.value);
    return productId;
  }

  Future<String> uploadImage(File file) async {
    String imageUrl = await MashatelClient.mashatelClient.uploadImage(file);
    this.imagePath.value = imageUrl;
    return imageUrl;
  }

  setCatId(String id) {
    this.catId.value = id;
  }

  setSubCatId(String id) {
    this.subCatId.value = id;
  }

  setProductId(String id) {
    this.productId.value = id;
  }

  getAllMainAdsImagesUrls() async {
    List<BigAds> bigAds =
        await MashatelRepository.mashatelRepository.getAllBigAdsImages();
    this.mainAdsImagesUrls.value = bigAds;
  }

  getAllMiniAds() async {
    List<String> miniAds =
        await MashatelRepository.mashatelRepository.getAllMiniAds();
    this.miniAdsUrls.value = miniAds;
  }

  getRandomAd() {
    final _random = new Random();
    String element = miniAdsUrls[_random.nextInt(miniAdsUrls.length)];
    this.minAd.value = element;
  }

  Future<String> addNewBigAd(BigAds bigAds) async {
    bigAds.imageUrl = this.imagePath.value;
    String bigAdAd = await MashatelClient.mashatelClient.addBigAds(bigAds);
    this.imagePath.value = '';
    return bigAdAd;
  }

  Future<String> addBannerAd(String contentAr, String contentEn) async {
    String bigAdAd = await MashatelClient.mashatelClient
        .addNewAdvertisment(contentAr, contentEn);
    return bigAdAd;
  }
}
