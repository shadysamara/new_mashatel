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
import 'package:multi_image_picker/multi_image_picker.dart';

class MashatelClient {
  MashatelClient._();
  static MashatelClient mashatelClient = MashatelClient._();
  SignInGetx signInGetx = Get.put(SignInGetx());
  AppGet appGet = Get.put(AppGet());
  var logger = Logger();
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseStorage firebaseStorage = FirebaseStorage.instance;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  String collectionName = 'categories';
  String subCollectionName = 'subCategories';
  String productsCollectionName = 'products';
  String miniAdsCollectionName = 'miniAdvertisment';
  String bigAdsCollectionName = 'bigAdvertisment';

////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
  Future<String> insertNewCategory(Category category) async {
    try {
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

////////////////////////////////////////////////////////////////
  Future<List<Category>> getAllCategories() async {
    try {
      QuerySnapshot querySnapshot =
          await firestore.collection(collectionName).get();
      List<QueryDocumentSnapshot> queryDocumentSnapshot = querySnapshot.docs;
      List<Category> categories =
          queryDocumentSnapshot.map((e) => Category.fromMap(e)).toList();
      signInGetx.pr.hide();
      return categories;
    } on Exception catch (e) {
      signInGetx.pr.hide();
      CustomDialougs.utils
          .showDialoug(messageKey: e.toString(), titleKey: 'alert');
      return null;
    }
  }

////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
  Future<List<AppUser>> getAllMarkets(String catId) async {
    try {
      QuerySnapshot querySnapshot = await firestore
          .collection('users')
          .where('isMarket', isEqualTo: true)
          .where('catId', isEqualTo: catId)
          .get();
      List<QueryDocumentSnapshot> queryDocumentSnapshot = querySnapshot.docs;
      List<AppUser> markets = queryDocumentSnapshot
          .map((e) => AppUser.fromMarketJson(e.data()))
          .toList();
      signInGetx.pr.hide();
      return markets;
    } on Exception catch (e) {
      signInGetx.pr.hide();
      CustomDialougs.utils
          .showDialoug(messageKey: e.toString(), titleKey: 'alert');
      return null;
    }
  }

//////////////////////////////////////////////////////////////////
  removeProduct(String productId, String marketId, AppUser appUser) async {
    await firestore.collection('products').doc(productId).delete();
    getAllProducts(marketId);

    CustomDialougs.utils.showDialoug(
        messageKey: 'delete_confirmation',
        titleKey: 'confirmation',
        function: () {
          Get.back();
          Get.back();
        });
  }

  deleteAdvertisment(String adId) async {
    await firestore.collection('advertisments').doc(adId).delete();
    getAllAdvertisments();
    CustomDialougs.utils.showDialoug(
        messageKey: 'ad_delete_confirmation', titleKey: 'confirmation');
  }

////////////////////////////////////////////////////////////////
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

////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////
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

  ////////////////////////////////////////////////////////////////
  ///////////////////////////////////////////////////////////////////
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

////////////////////////////////////////////////////////////////
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

  Future<List<String>> uploadAllImages(
      List<Asset> assets, String marketName) async {
    List<String> urls = [];
    for (int i = 0; i < assets.length; i++) {
      String url = await saveAssetImage(assets[i], marketName);
      urls.add(url);
    }
    return urls;
  }

////////////////////////////////////////////////////////////////
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

////////////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////////////
  ///
  Future<String> addNewProductWithManyImages(
      ProductModel productModel, AppUser appUser) async {
    try {
      List<Asset> assetImages = productModel.assetImages;
      List<String> urls = await uploadAllImages(assetImages, appUser.userName);

      productModel.imagesUrls = urls;

      print(productModel.toJson());
      DocumentReference documentReference =
          await firestore.collection('products').add(productModel.toJson());
      appGet.getMarketProducts(appUser.userId);
      return 'documentReference.id';
    } on Exception catch (e) {
      CustomDialougs.utils
          .showDialoug(messageKey: e.toString(), titleKey: 'alert');
      return null;
    }
  }

//////////////////////////////////////////////////////////////////////////////////////
  Future<ProductModel> getProductById(String productId, int bannedUsers) async {
    DocumentSnapshot documentSnapshot =
        await firestore.collection('products').doc(productId).get();
    Map map = documentSnapshot.data();
    map['productId'] = documentSnapshot.id;
    ProductModel product = ProductModel.fromMap(map);
    product.bannedUsers = bannedUsers;
    return product;
  }

  ///////////////////////////////////////////////////////////////////////////////////////////////
  Future<String> reportPorductByCustomer(
      String productId, String userId) async {
    try {
      await firestore.collection('repoerts').doc(productId).set({
        "users": FieldValue.arrayUnion([userId])
      }, SetOptions(merge: true));
      CustomDialougs.utils
          .showDialoug(titleKey: 'confirmation', messageKey: 'report_confirm');

      return 'documentReference.id';
    } on Exception catch (e) {
      CustomDialougs.utils
          .showDialoug(messageKey: e.toString(), titleKey: 'alert');
      return null;
    }
  }

/////////////////////////////////////////////////////////////////////////////////////
  Future<List<ProductModel>> getReportedProducts() async {
    try {
      QuerySnapshot querySnapshot =
          await firestore.collection('repoerts').get();
      List<Map<dynamic, dynamic>> maps = querySnapshot.docs.map((e) {
        Map map = e.data();
        map['productId'] = e.id;
        return map;
      }).toList();
      List<ProductModel> products = [];
      for (Map map in maps) {
        ProductModel productModel =
            await getProductById(map['productId'], map['users'].length);
        products.add(productModel);
      }

      appGet.setBannedProducts(products);
      return products;
    } on Exception catch (e) {
      CustomDialougs.utils
          .showDialoug(messageKey: e.toString(), titleKey: 'alert');
      return null;
    }
  }

  /////////////////////////////////////////////////////////////////////////////////////////////////////////////
  Future<List<ProductModel>> getAllProducts(String marketId) async {
    try {
      QuerySnapshot querySnapshot = await firestore
          .collection(productsCollectionName)
          .where('marketId', isEqualTo: marketId)
          .get();

      List<QueryDocumentSnapshot> queryDocumentSnapshot = querySnapshot.docs;
      List<ProductModel> products = queryDocumentSnapshot.map((e) {
        Map map = e.data();
        map['productId'] = e.id;

        return ProductModel.fromMap(map);
      }).toList();
      appGet.products.value = products;
      signInGetx.pr.hide();
      return products;
    } on Exception catch (e) {
      signInGetx.pr.hide();
      CustomDialougs.utils
          .showDialoug(messageKey: e.toString(), titleKey: 'alert');
      return null;
    }
  }

  ////////////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////////////
  Future<String> addNewAdv(Advertisment advertisment) async {
    try {
      DocumentReference documentReference = await firestore
          .collection('advertisments')
          .add(advertisment.toJson());

      signInGetx.pr.hide();
      return documentReference.id;
    } on Exception catch (e) {
      signInGetx.pr.hide();
      CustomDialougs.utils
          .showDialoug(messageKey: e.toString(), titleKey: 'alert');
      return null;
    }
  }

  ////////////////////////////////////////////////////////////////
  Future<List<Advertisment>> getAllAdvertisments() async {
    try {
      QuerySnapshot querySnapshot =
          await firestore.collection('advertisments').get();
      List<QueryDocumentSnapshot> queryDocumentSnapshot = querySnapshot.docs;
      List<Advertisment> advertisments = queryDocumentSnapshot.map((e) {
        Map map = e.data();
        map['adId'] = e.id;
        return Advertisment.fromMap(map);
      }).toList();
      signInGetx.pr.hide();
      appGet.setAdvertisments(advertisments);
      return advertisments;
    } on Exception catch (e) {
      signInGetx.pr.hide();
      CustomDialougs.utils
          .showDialoug(messageKey: e.toString(), titleKey: 'alert');
      return null;
    }
  }

  ////////////////////////////////////////////////////////////////
  ///////////////////////////////////////////////////////////////////

  ///////////////////////////////////////////////////////////////
  Future<List<Map>> getAllUsers() async {
    try {
      String myId = firebaseAuth.currentUser.uid;
      QuerySnapshot querySnapshot = await firestore.collection('Users').get();
      List<Map<String, dynamic>> map =
          querySnapshot.docs.map((e) => e.data()).toList();
      List<Map<String, dynamic>> map2 =
          map.where((element) => element['userId'] != myId).toList();
      return map2;
    } on Exception catch (e) {
      print(e);
    }
  }

////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////
  Future<String> createChat(List<String> usersIds, String chatId) async {
    try {
      firestore.collection('Chats').doc(chatId).set({'users': usersIds});
      return chatId;
    } catch (e) {
      return null;
    }
  }

/////////////////////////////////////////////////////////////////////////
  Future<Map> getUserFromFirebase(String userId) async {
    try {
      DocumentSnapshot documentSnapshot =
          await firestore.collection('users').doc(userId).get();
      Map<String, dynamic> data = documentSnapshot.data();
      return data;
    } catch (e) {
      print('error');
    }
  }

////////////////////////////////////////////////////
  Future<List<Map<String, dynamic>>> forLoop(
      QuerySnapshot querySnapshot) async {
    List<Map<String, dynamic>> mapList = [];
    for (QueryDocumentSnapshot queryDocumentSnapshot in querySnapshot.docs) {
      Map<String, dynamic> data = queryDocumentSnapshot.data();

      List users = data['users'];
      String otherId =
          users.where((element) => element != getUser()).toList().first;
      Map map = await getUserFromFirebase(otherId);
      data['otherUserId'] = otherId;
      data['otherUserMap'] = map;
      data['chatId'] = queryDocumentSnapshot.id;

      mapList.add(data);
    }

    return mapList;
  }

/////////////////////////////////////////////////////////////////////////
  Future<List<Map<String, dynamic>>> getAllChats(String myId) async {
    QuerySnapshot querySnapshot = await firestore
        .collection('Chats')
        .where('users', arrayContains: myId)
        .get();
    List<Map<String, dynamic>> mapList = await forLoop(querySnapshot);

    return mapList;
  }

////////////////////////////////////////////////////////////////////////
  Future<QuerySnapshot> getChat(List<String> usersIds) async {
    QuerySnapshot querySnapshot = await firestore
        .collection('Chats')
        .where('users', arrayContains: usersIds)
        .get();
    return querySnapshot;
  }

//////////////////////////////////////////////////////////////////////////
  newMessage({Message message, String chatId}) async {
    firestore
        .collection('Chats')
        .doc(chatId)
        .collection('Messages')
        .add(message.toJson());
  }

///////////////////////////////////////////////////////////////////
  String getUser() {
    try {
      if (firebaseAuth.currentUser != null) {
        String userId = firebaseAuth.currentUser.uid;
        return userId;
      } else {
        return null;
      }
    } on Exception catch (e) {
      return null;
    }
  }

//////////////////////////////////////////////////////////////////
  Stream<QuerySnapshot> getAllChatMessages(String chatId) {
    Stream<QuerySnapshot> stream = firestore
        .collection('Chats')
        .doc(chatId)
        .collection('Messages')
        .orderBy('timeStamp')
        .snapshots();
    return stream;
  }

///////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////
  Stream<QuerySnapshot> getAllMessages({String myId, String otherId}) {
    Stream<QuerySnapshot> queryStream = firestore
        .collection('Chats')
        .doc(myId)
        .collection('Conversations')
        .doc(otherId)
        .collection('Messages')
        .orderBy('temeStamp')
        .snapshots();
    return queryStream;
  }

  ///////////////////////////////////////////////////////////////////

}
