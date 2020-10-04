import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:mashatel/features/customers/blocs/app_get.dart';
import 'package:mashatel/features/customers/modles/product.dart';
import 'package:mashatel/features/sign_in/models/userApp.dart';
import 'package:mashatel/utils/custom_dialoug.dart';
import 'package:mashatel/values/styles.dart';
import 'package:mashatel/widgets/custom_appbar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mashatel/widgets/custom_drawer.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;

class ProductDetails extends StatefulWidget {
  Product product;
  AppUser appUser;
  ProductDetails(this.product, this.appUser);

  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  AppGet appGet = Get.put(AppGet());
  int cuttentIndex = 0;
  whatsAppMessnger() async {
    var phone = widget.appUser.phoneNumber;
    var whatsappUrl = "";
    if (Platform.isIOS) {
      whatsappUrl = "whatsapp://wa.me/$phone}";
    } else {
      whatsappUrl = "whatsapp://send?phone=$phone}";
    }
    await UrlLauncher.canLaunch(whatsappUrl)
        ? UrlLauncher.launch(whatsappUrl)
        : CustomDialougs.utils.showDialoug(
            messageKey: 'whats_app_not_installed', titleKey: 'alert');
  }

  _makePhoneCall() async {
    String url = 'tel:${widget.appUser.phoneNumber}';

    await UrlLauncher.canLaunch(url)
        ? UrlLauncher.launch(url)
        : CustomDialougs.utils
            .showDialoug(messageKey: 'cant_make_call', titleKey: 'alert');
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      drawer: AppSettings(appGet.appUser.value),
      appBar: BaseAppbar(
        translator.currentLanguage == "ar"
            ? widget.product.nameAr
            : widget.product.nameEn,
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 225.h,
                width: double.infinity,
                child: CachedNetworkImage(
                  fit: BoxFit.cover,
                  imageUrl: widget.product.imageUrl,
                  placeholder: (context, url) {
                    return FlareActor(
                      "assets/animations/loading.flr",
                      sizeFromArtboard: true,
                      alignment: Alignment.center,
                      animation: "loading",
                    );
                  },
                ),
              ),
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
                          translator.currentLanguage == "ar"
                              ? widget.product.nameAr
                              : widget.product.nameEn,
                          style: Styles.headerStyle,
                        ),
                        Text(
                          '${widget.product.price} ${translator.currentLanguage == 'ar' ? 'دينار كويتي' : 'DKW'}',
                          style: TextStyle(color: Colors.redAccent),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 15.h,
                    ),
                    Text(translator.currentLanguage == "ar"
                        ? widget.product.descAr
                        : widget.product.descEn),
                    SizedBox(
                      height: 40.h,
                    ),
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 40.w,
                          backgroundImage: CachedNetworkImageProvider(
                              widget.appUser.imagePath),
                        ),
                        SizedBox(
                          width: 10.w,
                        ),
                        Text(widget.appUser.userName),
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
              whatsAppMessnger();
            } else if (value == 1) {
              _makePhoneCall();
            }
          },
          currentIndex: this.cuttentIndex,
          items: [
            BottomNavigationBarItem(
                title: Container(),
                icon: Icon(
                  Icons.email,
                  color: Colors.orange[300],
                )),
            BottomNavigationBarItem(
                title: Container(),
                icon: Icon(
                  Icons.call,
                  color: Colors.blue,
                )),
            BottomNavigationBarItem(
                title: Container(),
                icon: Icon(
                  Icons.info_outline,
                  color: Colors.red,
                )),
            BottomNavigationBarItem(
                title: Container(),
                icon: Icon(
                  Icons.share,
                  color: Colors.redAccent,
                ))
          ]),
    );
  }
}
