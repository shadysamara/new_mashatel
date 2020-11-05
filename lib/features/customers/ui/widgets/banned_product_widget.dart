import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:mashatel/features/customers/modles/product_model.dart';
import 'package:mashatel/features/sign_in/models/userApp.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mashatel/values/radii.dart';

class BannedProduct extends StatelessWidget {
  ProductModel productModel;
  BannedProduct({this.productModel});
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.h),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: Radii.widgetsRadius,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 5), // changes position of shadow
            ),
          ]),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: Radii.widgetsRadius,
            ),
            height: 110.h,
            width: 110.w,
            child: ClipRRect(
                borderRadius: Radii.widgetsRadius,
                clipBehavior: Clip.antiAlias,
                child: CachedNetworkImage(
                  imageUrl: productModel.imagesUrls.first,
                  fit: BoxFit.cover,
                )),
          ),
          SizedBox(
            width: 15.w,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                translator.currentLanguage == 'ar'
                    ? productModel.nameAr
                    : productModel.nameEn,
                textAlign: TextAlign.start,
              ),
              Text(
                translator.currentLanguage == 'ar'
                    ? productModel.descAr
                    : productModel.descEn,
              ),
              Text(translator.translate('reported_by') +
                  ' ${productModel.bannedUsers.toString()} ' +
                  translator.translate('users'))
            ],
          ),
          Spacer(),
          Icon(Icons.navigate_next)
        ],
      ),
    );
  }
}
