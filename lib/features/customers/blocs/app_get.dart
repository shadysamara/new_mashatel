import 'dart:developer';
import 'dart:io';
import 'package:get/get.dart';
import 'package:mashatel/features/customers/modles/about.dart';
import 'package:mashatel/features/customers/modles/advertisment.dart';
import 'package:mashatel/features/customers/modles/category.dart';
import 'package:mashatel/features/customers/modles/product_model.dart';
import 'package:mashatel/features/customers/modles/terms.dart';
import 'package:mashatel/features/customers/repositories/mashatel_client.dart';
import 'package:mashatel/features/sign_in/models/userApp.dart';
import 'package:mashatel/utils/custom_dialoug.dart';
import 'package:multi_image_picker_plus/multi_image_picker_plus.dart';

class AppGet {
  bool isFromDynamic = false;
  var allCategories = <Category>[].obs;
  var markets = <AppUser>[].obs;
  var imagePath = ''.obs;
  var catId = ''.obs;
  var appUser = AppUser().obs;
  var localImageFilePath = ''.obs;
  var marketId = ''.obs;
  var images = <Asset>[].obs;
  var products = <ProductModel>[].obs;
  var bannedProducts = <ProductModel>[].obs;
  var advertisments = <Advertisment>[].obs;
  AboutAppModel? aboutAppModel;
  TermsModel? termsModel;
  var allChats = <Map<String, dynamic>>[].obs;
  updateCategory(Category category) async {
    await MashatelClient.mashatelClient.updateCategory(category);
    imagePath.value = '';
    getAllCategories();
    localImageFilePath.value = '';
    CustomDialougs.utils.showDialoug(
        messageKey: 'success_edit',
        titleKey: 'sucecess',
        function: () {
          Get.back();
          Get.back();
        });
  }

  resetMarkets() {
    this.markets.value = [];
    this.products.value = [];
  }

  setBannedProducts(List<ProductModel> products) {
    this.bannedProducts.value = products;
  }

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
    List<Category>? categories =
        await MashatelClient.mashatelClient.getAllCategories();
    this.allCategories.value = categories ?? [];
  }

  getAllMarkets(String catId) async {
    List<AppUser>? markets =
        await MashatelClient.mashatelClient.getAllMarkets();
    log("markets: ${markets?.length.toString()}");
    this.markets.value = markets ?? [];
  }

  getMarketProducts(String? marketId) async {
    List<ProductModel>? products =
        await MashatelClient.mashatelClient.getAllProducts(marketId);

    this.products.value = products ?? [];
  }

  Future<String?> addNewCategory(Category category) async {
    category.imagePath = this.imagePath.value;
    String? catId =
        await MashatelClient.mashatelClient.insertNewCategory(category);
    this.catId.value = catId ?? '';
    this.imagePath.value = '';
    getAllCategories();
    return catId;
  }

  Future<String?> uploadImage(File file) async {
    String? imageUrl = await MashatelClient.mashatelClient.uploadImage(file);
    this.imagePath.value = imageUrl ?? '';
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
