import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:mashatel/features/customers/blocs/app_get.dart';
import 'package:mashatel/features/customers/modles/advertisment.dart';
import 'package:mashatel/features/customers/modles/product_model.dart';
import 'package:mashatel/features/customers/modles/category.dart';
import 'package:mashatel/features/customers/modles/complaint_model.dart';
import 'package:mashatel/features/customers/modles/terms.dart';
import 'package:mashatel/features/customers/ui/pages/market_page.dart';
import 'package:mashatel/features/messanger/models/message_model.dart';
import 'package:mashatel/features/sign_in/models/userApp.dart';
import 'package:mashatel/features/sign_in/providers/signInGetx.dart';
import 'package:mashatel/utils/custom_dialoug.dart';
import 'package:mashatel/features/customers/modles/about.dart';
import 'package:multi_image_picker_plus/multi_image_picker_plus.dart';

class MashatelClient {
  MashatelClient._();
  static final MashatelClient mashatelClient = MashatelClient._();
  final SignInGetx signInGetx = Get.put(SignInGetx());
  final AppGet appGet = Get.put(AppGet());
  final Logger logger = Logger();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseStorage firebaseStorage = FirebaseStorage.instance;
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final String collectionName = 'categories';
  final String subCollectionName = 'subCategories';
  final String productsCollectionName = 'products';
  final String miniAdsCollectionName = 'miniAdvertisment';
  final String bigAdsCollectionName = 'bigAdvertisment';

  //////////////////////////////////////////////////////////////////
  Future<String?> insertNewCategory(Category? category) async {
    try {
      final DocumentReference documentReference = await firestore
          .collection(collectionName)
          .add(category?.toJson() ?? {});
      signInGetx.pr.hide();
      return documentReference.id;
    } catch (e) {
      signInGetx.pr.hide();
      CustomDialougs.utils
          .showDialoug(messageKey: e.toString(), titleKey: 'alert');
      return null;
    }
  }

  //////////////////////////////////////////////////////////////////
  Future<void> deleteCategory(String id) async {
    try {
      signInGetx.pr.show();
      await firestore.collection(collectionName).doc(id).delete();
      signInGetx.pr.hide();
      CustomDialougs.utils.showDialoug(
          messageKey: 'delete_confirmation',
          titleKey: 'confirmation',
          function: () {
            Get.back();
            Get.back();
          });
      await appGet.getAllCategories();
    } catch (e) {
      signInGetx.pr.hide();
      CustomDialougs.utils
          .showDialoug(messageKey: e.toString(), titleKey: 'alert');
    }
  }

  //////////////////////////////////////////////////////////////////
  Future<void> updateCategory(Category? category) async {
    try {
      signInGetx.pr.show();
      await firestore
          .collection(collectionName)
          .doc(category?.catId)
          .update(category?.toJson() ?? {});
      signInGetx.pr.hide();
    } catch (e) {
      signInGetx.pr.hide();
      CustomDialougs.utils
          .showDialoug(messageKey: e.toString(), titleKey: 'alert');
    }
  }

  //////////////////////////////////////////////////////////////////
  Future<List<Category>?> getAllCategories() async {
    try {
      final QuerySnapshot querySnapshot =
          await firestore.collection(collectionName).get();
      final List<QueryDocumentSnapshot> queryDocumentSnapshot =
          querySnapshot.docs;
      final List<Category> categories = queryDocumentSnapshot.map((e) {
        Map<String, dynamic> data = e.data() as Map<String, dynamic>;
        data['id'] = e.id;
        return Category.fromMap(data);
      }).toList();
      signInGetx.pr.hide();
      return categories;
    } catch (e) {
      signInGetx.pr.hide();
      CustomDialougs.utils
          .showDialoug(messageKey: e.toString(), titleKey: 'alert');
      return null;
    }
  }

  //////////////////////////////////////////////////////////////////
  Future<List<AppUser>?> getAllMarkets() async {
    try {
      final QuerySnapshot querySnapshot = await firestore
          .collection('users')
          .where('isMarket', isEqualTo: true)
          .get();
      final List<QueryDocumentSnapshot> queryDocumentSnapshot =
          querySnapshot.docs;
      final List<AppUser> markets = queryDocumentSnapshot
          .map((e) => AppUser.fromMarketJson(e.data() as Map<String, dynamic>))
          .toList();
      signInGetx.pr.hide();
      return markets;
    } catch (e) {
      signInGetx.pr.hide();
      CustomDialougs.utils
          .showDialoug(messageKey: e.toString(), titleKey: 'alert');
      return null;
    }
  }

  ///////////////////////////////////////////////////////////////////
  Future<void> removeMarket(String marketId) async {
    await firestore.collection('users').doc(marketId).delete();
    await getAllMarkets();
    CustomDialougs.utils.showDialoug(
        messageKey: 'delete_confirmation',
        titleKey: 'confirmation',
        function: () {
          Get.back();
          Get.back();
        });
  }

  //////////////////////////////////////////////////////////////////
  Future<void> removeProduct(
      String productId, String marketId, AppUser appUser) async {
    try {
      logger.e(productId);
      signInGetx.pr.show();
      await firestore.collection('products').doc(productId).delete();
      await firestore.collection('repoerts').doc(productId).delete();
      await getAllProducts(marketId);
      await getReportedProducts();
      signInGetx.pr.hide();
      CustomDialougs.utils.showDialoug(
          messageKey: 'delete_confirmation',
          titleKey: 'confirmation',
          function: () {
            Get.back();
            Get.back();
          });
    } catch (e) {
      signInGetx.pr.hide();
      CustomDialougs.utils
          .showDialoug(messageKey: e.toString(), titleKey: 'alert');
    }
  }

  Future<void> deleteAdvertisment(String adId) async {
    await firestore.collection('advertisments').doc(adId).delete();
    await getAllAdvertisments();
    CustomDialougs.utils.showDialoug(
        messageKey: 'ad_delete_confirmation', titleKey: 'confirmation');
  }

  //////////////////////////////////////////////////////////////////
  Future<bool> addTermsAndConditions(TermsModel content) async {
    try {
      await firestore.collection('terms').doc('terms').set(content.toJson());
      signInGetx.pr.hide();
      return true;
    } catch (e) {
      signInGetx.pr.hide();
      CustomDialougs.utils
          .showDialoug(messageKey: e.toString(), titleKey: 'alert');
      return false;
    }
  }

  //////////////////////////////////////////////////////////////////
  Future<TermsModel?> getTermsAndConditions() async {
    try {
      final DocumentSnapshot documentReference =
          await firestore.collection('terms').doc('terms').get();
      if (documentReference.exists) {
        final TermsModel terms = TermsModel.fromMap(
            documentReference.data() as Map<String, dynamic>);
        signInGetx.pr.hide();
        return terms;
      } else {
        return null;
      }
    } catch (e) {
      signInGetx.pr.hide();
      CustomDialougs.utils
          .showDialoug(messageKey: e.toString(), titleKey: 'alert');
      return null;
    }
  }

  //////////////////////////////////////////////////////////////////
  Future<bool> addAboutApp(AboutAppModel content) async {
    try {
      await firestore
          .collection('aboutApp')
          .doc('aboutApp')
          .set(content.toJson());
      signInGetx.pr.hide();
      return true;
    } catch (e) {
      signInGetx.pr.hide();
      CustomDialougs.utils
          .showDialoug(messageKey: e.toString(), titleKey: 'alert');
      return false;
    }
  }

  //////////////////////////////////////////////////////////////////
  Future<AboutAppModel?> getAboutApp() async {
    try {
      final DocumentSnapshot documentReference =
          await firestore.collection('aboutApp').doc('aboutApp').get();
      if (documentReference.exists) {
        final AboutAppModel aboutApp = AboutAppModel.fromMap(
            documentReference.data() as Map<String, dynamic>);
        signInGetx.pr.hide();
        return aboutApp;
      } else {
        return null;
      }
    } catch (e) {
      signInGetx.pr.hide();
      CustomDialougs.utils
          .showDialoug(messageKey: e.toString(), titleKey: 'alert');
      return null;
    }
  }

  //////////////////////////////////////////////////////////////////
  Future<String?> addComplaint(ComplaintModel complaintModel) async {
    try {
      final DocumentReference documentReference =
          await firestore.collection('complaints').add(complaintModel.toJson());
      signInGetx.pr.hide();
      return documentReference.id;
    } catch (e) {
      signInGetx.pr.hide();
      CustomDialougs.utils
          .showDialoug(messageKey: e.toString(), titleKey: 'alert');
      return null;
    }
  }

  //////////////////////////////////////////////////////////////////
  Future<String?> saveAssetImage(Asset asset, String marketId) async {
    try {
      final DateTime dateTime = DateTime.now();
      final ByteData byteData = await asset.getByteData();
      final List<int> imageData = byteData.buffer.asUint8List();
      final UploadTask uploadTask = firebaseStorage
          .ref()
          .child('products/$marketId/$dateTime.png')
          .putData(Uint8List.fromList(imageData));
      final TaskSnapshot snapshot = await uploadTask;
      final String imageUrl = await snapshot.ref.getDownloadURL();
      return imageUrl;
    } catch (e) {
      CustomDialougs.utils
          .showDialoug(messageKey: e.toString(), titleKey: 'alert');
      return null;
    }
  }

  Future<List<String>> uploadAllImages(
      List<Asset> assets, String marketName) async {
    final List<String> urls = [];
    for (final Asset asset in assets) {
      final String? url = await saveAssetImage(asset, marketName);
      if (url != null) {
        urls.add(url);
      }
    }
    return urls;
  }

  //////////////////////////////////////////////////////////////////
  Future<String?> uploadImage(File file) async {
    try {
      final DateTime dateTime = DateTime.now();
      signInGetx.pr.show();
      final UploadTask uploadTask =
          firebaseStorage.ref().child('Images/$dateTime.png').putFile(file);
      final TaskSnapshot snapshot = await uploadTask;
      final String imageUrl = await snapshot.ref.getDownloadURL();
      signInGetx.pr.hide();
      return imageUrl;
    } catch (e) {
      signInGetx.pr.hide();
      CustomDialougs.utils
          .showDialoug(messageKey: e.toString(), titleKey: 'alert');
      return null;
    }
  }

  //////////////////////////////////////////////////////////////////
  Future<String?> addNewProductWithManyImages(
      ProductModel productModel, AppUser appUser) async {
    try {
      final List<Asset> assetImages = productModel.assetImages ?? [];
      final List<String> urls =
          await uploadAllImages(assetImages, appUser.userName ?? '');
      productModel.imagesUrls = urls;

      final DocumentReference documentReference =
          await firestore.collection('products').add(productModel.toJson());
      await appGet.getMarketProducts(appUser.userId);
      return documentReference
          .id; // Return actual ID instead of hardcoded string
    } catch (e) {
      CustomDialougs.utils
          .showDialoug(messageKey: e.toString(), titleKey: 'alert');
      return null;
    }
  }

  //////////////////////////////////////////////////////////////////
  Future<AppUser> getMarketFromFirebase(String marketId) async {
    final DocumentSnapshot documentSnapshot =
        await firestore.collection('users').doc(marketId).get();
    return AppUser.fromMarketJson(
        documentSnapshot.data() as Map<String, dynamic>);
  }

  //////////////////////////////////////////////////////////////////
  Future<ProductModel?> getProductById(String productId,
      [int? bannedUsers]) async {
    final DocumentSnapshot documentSnapshot =
        await firestore.collection('products').doc(productId).get();
    if (documentSnapshot.exists) {
      final Map<String, dynamic> map =
          documentSnapshot.data() as Map<String, dynamic>;
      map['productId'] = documentSnapshot.id;
      final ProductModel product = ProductModel.fromMap(map);
      product.bannedUsers = bannedUsers ?? 0;
      return product;
    } else {
      return null;
    }
  }

  //////////////////////////////////////////////////////////////////
  Future<String?> reportPorductByCustomer(
      String productId, String userId) async {
    try {
      await firestore.collection('repoerts').doc(productId).set({
        "users": FieldValue.arrayUnion([userId])
      }, SetOptions(merge: true));
      CustomDialougs.utils
          .showDialoug(titleKey: 'confirmation', messageKey: 'report_confirm');
      return productId; // Return meaningful value
    } catch (e) {
      CustomDialougs.utils
          .showDialoug(messageKey: e.toString(), titleKey: 'alert');
      return null;
    }
  }

  //////////////////////////////////////////////////////////////////
  Future<List<ProductModel>?> getReportedProducts() async {
    try {
      final QuerySnapshot querySnapshot =
          await firestore.collection('repoerts').get();
      final List<Map<String, dynamic>> maps = querySnapshot.docs.map((e) {
        final Map<String, dynamic> map = e.data() as Map<String, dynamic>;
        map['productId'] = e.id;
        return map;
      }).toList();
      final List<ProductModel> products = [];
      for (final Map<String, dynamic> map in maps) {
        final ProductModel? productModel =
            await getProductById(map['productId'], map['users'].length);
        if (productModel != null) {
          products.add(productModel);
        }
      }
      appGet.setBannedProducts(products);
      return products;
    } catch (e) {
      CustomDialougs.utils
          .showDialoug(messageKey: e.toString(), titleKey: 'alert');
      return null;
    }
  }

  //////////////////////////////////////////////////////////////////
  Future<List<ProductModel>?> getAllProducts(String? marketId) async {
    try {
      final QuerySnapshot querySnapshot = await firestore
          .collection(productsCollectionName)
          .where('marketId', isEqualTo: marketId)
          .get();
      final List<QueryDocumentSnapshot> queryDocumentSnapshot =
          querySnapshot.docs;
      final List<ProductModel> products = queryDocumentSnapshot.map((e) {
        final Map<String, dynamic> map = e.data() as Map<String, dynamic>;
        map['productId'] = e.id;
        return ProductModel.fromMap(map);
      }).toList();
      appGet.products.value = products;
      signInGetx.pr.hide();
      return products;
    } catch (e) {
      signInGetx.pr.hide();
      CustomDialougs.utils
          .showDialoug(messageKey: e.toString(), titleKey: 'alert');
      return null;
    }
  }

  //////////////////////////////////////////////////////////////////
  Future<String?> addNewAdv(Advertisment advertisment) async {
    try {
      final DocumentReference documentReference = await firestore
          .collection('advertisments')
          .add(advertisment.toJson());
      await getAllAdvertisments();
      signInGetx.pr.hide();
      return documentReference.id;
    } catch (e) {
      signInGetx.pr.hide();
      CustomDialougs.utils
          .showDialoug(messageKey: e.toString(), titleKey: 'alert');
      return null;
    }
  }

  //////////////////////////////////////////////////////////////////
  Future<List<Advertisment>?> getAllAdvertisments() async {
    try {
      final QuerySnapshot querySnapshot =
          await firestore.collection('advertisments').get();
      final List<QueryDocumentSnapshot> queryDocumentSnapshot =
          querySnapshot.docs;
      final List<Advertisment> advertisments = queryDocumentSnapshot.map((e) {
        final Map<String, dynamic> map = e.data() as Map<String, dynamic>;
        map['adId'] = e.id;
        return Advertisment.fromMap(map);
      }).toList();
      signInGetx.pr.hide();
      appGet.setAdvertisments(advertisments);
      return advertisments;
    } catch (e) {
      signInGetx.pr.hide();
      CustomDialougs.utils
          .showDialoug(messageKey: e.toString(), titleKey: 'alert');
      return null;
    }
  }

  //////////////////////////////////////////////////////////////////
  Future<List<Map<String, dynamic>>?> getAllUsers() async {
    try {
      final String myId = firebaseAuth.currentUser!.uid;
      final QuerySnapshot querySnapshot =
          await firestore.collection('Users').get();
      final List<Map<String, dynamic>> map = querySnapshot.docs
          .map((e) => e.data() as Map<String, dynamic>)
          .toList();
      final List<Map<String, dynamic>> map2 =
          map.where((element) => element['userId'] != myId).toList();
      return map2;
    } catch (e) {
      print(e);
      return null;
    }
  }

  //////////////////////////////////////////////////////////////////
  Future<String?> createChat(List<String> usersIds, String chatId) async {
    try {
      await firestore.collection('Chats').doc(chatId).set({'users': usersIds});
      return chatId;
    } catch (e) {
      return null;
    }
  }

  //////////////////////////////////////////////////////////////////
  Future<Map<String, dynamic>?> getUserFromFirebase(String userId) async {
    try {
      final DocumentSnapshot documentSnapshot =
          await firestore.collection('users').doc(userId).get();
      return documentSnapshot.data() as Map<String, dynamic>?;
    } catch (e) {
      print('error: $e');
      return null;
    }
  }

  //////////////////////////////////////////////////////////////////
  Future<List<Map<String, dynamic>>> forLoop(
      QuerySnapshot querySnapshot) async {
    final List<Map<String, dynamic>> mapList = [];
    for (final QueryDocumentSnapshot queryDocumentSnapshot
        in querySnapshot.docs) {
      final Map<String, dynamic> data =
          queryDocumentSnapshot.data() as Map<String, dynamic>;
      final List<dynamic> users = data['users'] as List<dynamic>;
      final List<dynamic> otherIds =
          users.where((element) => element != getUser()).toList();
      final String otherId =
          otherIds.isNotEmpty ? otherIds.first as String : getUser()!;
      final Map<String, dynamic>? map = await getUserFromFirebase(otherId);
      data['otherUserId'] = otherId;
      data['otherUserMap'] = map;
      data['chatId'] = queryDocumentSnapshot.id;
      mapList.add(data);
    }
    return mapList;
  }

  //////////////////////////////////////////////////////////////////
  Future<List<Map<String, dynamic>>?> getAllChats(String myId) async {
    try {
      final QuerySnapshot querySnapshot = await firestore
          .collection('Chats')
          .where('users', arrayContains: myId)
          .get();
      final List<Map<String, dynamic>> mapList = await forLoop(querySnapshot);
      return mapList;
    } catch (e) {
      print('error: $e');
      return null;
    }
  }

  //////////////////////////////////////////////////////////////////
  Future<QuerySnapshot> getChat(List<String> usersIds) async {
    return await firestore
        .collection('Chats')
        .where('users', arrayContains: usersIds)
        .get();
  }

  //////////////////////////////////////////////////////////////////
  Future<void> newMessage(
      {required Message message, required String chatId}) async {
    await firestore
        .collection('Chats')
        .doc(chatId)
        .collection('Messages')
        .add(message.toJson());
  }

  //////////////////////////////////////////////////////////////////
  String? getUser() {
    try {
      return firebaseAuth.currentUser?.uid;
    } catch (e) {
      return null;
    }
  }

  //////////////////////////////////////////////////////////////////
  Stream<QuerySnapshot> getAllChatMessages(String chatId) {
    return firestore
        .collection('Chats')
        .doc(chatId)
        .collection('Messages')
        .orderBy('timeStamp')
        .snapshots();
  }

  //////////////////////////////////////////////////////////////////
  Stream<QuerySnapshot> getAllMessages(
      {required String myId, required String otherId}) {
    return firestore
        .collection('Chats')
        .doc(myId)
        .collection('Conversations')
        .doc(otherId)
        .collection('Messages')
        .orderBy('temeStamp') // Typo fixed: 'timeStamp'
        .snapshots();
  }
}
