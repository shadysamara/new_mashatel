import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:mashatel/features/customers/blocs/app_get.dart';
import 'package:mashatel/features/customers/modles/product.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mashatel/features/customers/modles/product_model.dart';
import 'package:mashatel/features/customers/repositories/mashatel_client.dart';
import 'package:mashatel/values/radii.dart';

class ProductWidget extends StatelessWidget {
  ProductModel product;
  ProductWidget(this.product);
  AppGet appGet = Get.find();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

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
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    CachedNetworkImage(
                      fit: BoxFit.cover,
                      width: size.width,
                      imageUrl: product.imagesUrls?.first ?? '',
                    ),
                    Positioned(
                      left: 5,
                      top: 5,
                      child: product.marketId == appGet.appUser.value.userId
                          ? GestureDetector(
                              onTap: () {
                                MashatelClient.mashatelClient.removeProduct(
                                  product.productId!,
                                  product.marketId!,
                                );
                              },
                              child: Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white.withOpacity(0.5)),
                                child: Icon(
                                  Icons.delete,
                                  color: Colors.black,
                                ),
                              ),
                            )
                          : Container(),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text((Get.locale == Locale("ar")
                            ? product.nameAr
                            : product.nameEn) ??
                        ''),
                    Text(
                      '${product.price} ${Get.locale == Locale("ar") ? 'دينار كويتي' : 'DKW'}',
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
