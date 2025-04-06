import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:mashatel/features/customers/blocs/app_get.dart';
import 'package:mashatel/features/customers/modles/product.dart';
import 'package:mashatel/features/customers/modles/product_model.dart';
import 'package:mashatel/features/customers/repositories/mashatel_client.dart';
import 'package:mashatel/features/customers/ui/pages/main_page.dart';
import 'package:mashatel/features/messanger/ui/pages/massenger.dart';
import 'package:mashatel/features/sign_in/models/userApp.dart';
import 'package:mashatel/services/dynamic_links_service.dart';
import 'package:mashatel/utils/custom_dialoug.dart';
import 'package:mashatel/values/styles.dart';
import 'package:mashatel/widgets/custom_appbar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mashatel/widgets/custom_drawer.dart';
import 'package:mashatel/widgets/slider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;

class ProductDetails extends StatefulWidget {
  ProductModel product;
  AppUser appUser;
  bool isFromDynamic;
  ProductDetails(this.product, this.appUser, [this.isFromDynamic = false]);

  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  AppGet appGet = Get.put(AppGet());
  int cuttentIndex = 0;
  startChat() async {
    String? myId = MashatelClient.mashatelClient.getUser();
    if (myId != null) {
      String? chatId = await MashatelClient.mashatelClient.createChat(
          [myId, widget.appUser.userId ?? ''],
          myId + (widget.appUser.userId ?? ''));
      if (chatId != null)
        Get.to(MassengerPage(widget.appUser.userId, chatId: chatId));
    }
  }

  _makePhoneCall() async {
    String url = 'tel:${widget.appUser.phoneNumber}';

    await UrlLauncher.canLaunch(url)
        ? UrlLauncher.launch(url)
        : CustomDialougs.utils
            .showDialoug(messageKey: 'cant_make_call', titleKey: 'alert');
  }

  FirebaseAuth firebaseauth = FirebaseAuth.instance;
  final DynamicLinkService _dynamicLinkService = DynamicLinkService();
  shareFunctionInMain(String id) async {
    Uri uri = await _dynamicLinkService.createDynamicLink(url: id);
    Share.share(uri.toString());
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async {
        if (appGet.isFromDynamic) {
          Get.off(MainPage());
          appGet.isFromDynamic = false;
          return Future.value(false);
        } else {
          return Future.value(true);
        }
      },
      child: Scaffold(
        endDrawer: AppSettings(appGet.appUser.value),
        appBar: BaseAppbar(
          (Get.locale == Locale("ar")
                  ? widget.product.nameAr
                  : widget.product.nameEn) ??
              '',
        ),
        body: Container(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Container(
                //   height: (size.height / 4) + 40.h,
                //   width: double.infinity,
                //   child: CarouselWithIndicatorDemo(
                //       urls: widget.product.imagesUrls ?? []),
                // ),
                SizedBox(
                  height: 15.h,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            (Get.locale == Locale("ar")
                                    ? widget.product.nameAr
                                    : widget.product.nameEn) ??
                                '',
                            style: Styles.headerStyle,
                          ),
                          Text(
                            '${widget.product.price} ${Get.locale == Locale("ar") ? 'دينار كويتي' : 'DKW'}',
                            style: TextStyle(color: Colors.redAccent),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 15.h,
                      ),
                      Text((Get.locale == Locale("ar")
                              ? widget.product.descAr
                              : widget.product.descEn) ??
                          ''),
                      SizedBox(
                        height: 40.h,
                      ),
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 40.w,
                            backgroundImage: CachedNetworkImageProvider(
                                widget.appUser.imagePath ?? ''),
                          ),
                          SizedBox(
                            width: 10.w,
                          ),
                          Text(widget.appUser.userName ?? ''),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
            onTap: (value) {
              setState(() {
                this.cuttentIndex = value;
              });
              if (value == 0) {
                firebaseauth.currentUser == null
                    ? CustomDialougs.utils.showDialoug(
                        messageKey: 'not_login', titleKey: 'no_login')
                    : widget.product.isInnerMessages == true
                        ? startChat()
                        : CustomDialougs.utils.showDialoug(
                            messageKey: 'noMessage', titleKey: 'alert');
              } else if (value == 1) {
                firebaseauth.currentUser == null
                    ? CustomDialougs.utils.showDialoug(
                        messageKey: 'not_login', titleKey: 'no_login')
                    : widget.product.isWithoutPhoneNumber == true
                        ? _makePhoneCall()
                        : CustomDialougs.utils.showDialoug(
                            messageKey: 'noCall', titleKey: 'alert');
              } else if (value == 2) {
                firebaseauth.currentUser == null
                    ? CustomDialougs.utils.showDialoug(
                        messageKey: 'not_login', titleKey: 'no_login')
                    : appGet.appUser.value.isAdmin == true
                        ? MashatelClient.mashatelClient.removeProduct(
                            widget.product.productId ?? '',
                            widget.product.marketId ?? '',
                            widget.appUser)
                        : MashatelClient.mashatelClient.reportPorductByCustomer(
                            widget.product.productId ?? '',
                            widget.appUser.userId ?? '');
              } else if (value == 3) {
                shareFunctionInMain(widget.product.productId ?? '');
              }
            },
            currentIndex: this.cuttentIndex,
            items: [
              BottomNavigationBarItem(
                  label: '',
                  icon: Icon(
                    Icons.email,
                    color: Colors.orange[300],
                  )),
              BottomNavigationBarItem(
                  label: '',
                  icon: Icon(
                    Icons.call,
                    color: Colors.blue,
                  )),
              BottomNavigationBarItem(
                  label: '',
                  icon: Icon(
                    Icons.block,
                    color: Colors.red,
                  )),
              BottomNavigationBarItem(
                  label: '',
                  icon: Icon(
                    Icons.share,
                    color: Colors.redAccent,
                  ))
            ]),
      ),
    );
  }
}
