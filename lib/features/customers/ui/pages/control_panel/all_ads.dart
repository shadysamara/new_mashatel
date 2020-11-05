import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:mashatel/features/customers/blocs/app_get.dart';
import 'package:mashatel/features/customers/repositories/mashatel_client.dart';
import 'package:mashatel/features/customers/ui/pages/control_panel/add_advertisment.dart';
import 'package:mashatel/values/radii.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AllAds extends StatelessWidget {
  AppGet appGet = Get.find();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  Get.to(AddNewPage());
                })
          ],
          title: Text(translator.translate('all_ads')),
        ),
        body: Obx(() {
          return Container(
            child: ListView.builder(
              itemCount: appGet.advertisments.length,
              itemBuilder: (context, index) {
                return Dismissible(
                  key: UniqueKey(),
                  onDismissed: (direction) {
                    MashatelClient.mashatelClient
                        .deleteAdvertisment(appGet.advertisments[index].id);
                  },
                  child: Container(
                    margin:
                        EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.h),
                    padding:
                        EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.h),
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
                    child: Container(
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
                            imageUrl: appGet.advertisments[index].imageUrl,
                            fit: BoxFit.cover,
                          )),
                    ),
                  ),
                );
              },
            ),
          );
        }));
  }
}
