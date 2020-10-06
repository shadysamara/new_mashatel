import 'package:cached_network_image/cached_network_image.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:mashatel/features/customers/modles/product.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mashatel/features/customers/modles/product_model.dart';
import 'package:mashatel/values/radii.dart';

class ProductWidget extends StatelessWidget {
  ProductModel product;
  ProductWidget(this.product);
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    // TODO: implement build
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5.w),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: Radii.widgetsRadius,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 0.5,
              blurRadius: 4,
              offset: Offset(0, 5), // changes position of shadow
            ),
          ]),
      child: ClipRRect(
        borderRadius: Radii.widgetsRadius,
        clipBehavior: Clip.antiAlias,
        child: Container(
          padding: EdgeInsets.only(bottom: 10.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: CachedNetworkImage(
                  fit: BoxFit.cover,
                  width: size.width,
                  imageUrl: product.imagesUrls.first,
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
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(translator.currentLanguage == 'ar'
                        ? product.nameAr
                        : product.nameEn),
                    Text(
                      '${product.price} ${translator.currentLanguage == 'ar' ? 'دينار كويتي' : 'DKW'}',
                      style: TextStyle(color: Colors.redAccent),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
