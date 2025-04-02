import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';
import 'package:mashatel/features/customers/blocs/app_get.dart';
import 'package:mashatel/features/customers/repositories/mashatel_client.dart';
import 'package:mashatel/features/sign_in/models/userApp.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mashatel/values/radii.dart';

class MarketWidget extends StatelessWidget {
  AppUser appUser;
  AppGet appGet = Get.find();
  MarketWidget({this.appUser});
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context,
        width: 392.72727272727275,
        height: 850.9090909090909,
        allowFontScaling: true);
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
                  imageUrl: appUser.imagePath,
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
                appUser.userName,
                textAlign: TextAlign.start,
              ),
              Text(appUser.companyName, textAlign: TextAlign.start)
            ],
          ),
          Spacer(),
          FirebaseAuth.instance.currentUser == null
              ? Container()
              : appGet.appUser.value.isAdmin
                  ? IconButton(
                      icon: Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                      onPressed: () {
                        MashatelClient.mashatelClient
                            .removeMarket(appUser.userId, appUser.catId);
                      })
                  : Icon(Icons.navigate_next)
        ],
      ),
    );
  }
}
