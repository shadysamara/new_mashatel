import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:mashatel/features/customers/modles/category.dart';
import 'package:mashatel/features/customers/repositories/mashatel_client.dart';
import 'package:mashatel/features/customers/ui/pages/control_panel/admin_category_edit.dart';
import 'package:mashatel/values/radii.dart';

class CategoryWidget extends StatelessWidget {
  final Category? category;
  bool isAdmin;
  CategoryWidget({this.category, this.isAdmin = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(5.w, 10.h, 5.w, 10.h),
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
      child: ClipRRect(
        borderRadius: Radii.widgetsRadius,
        clipBehavior: Clip.antiAlias,
        child: Row(
          children: [
            Container(
              width: 120.w,
              height: 120.h,
              child: CachedNetworkImage(
                imageUrl: category?.imagePath ?? '',
                fit: BoxFit.fill,
              ),
            ),
            Expanded(
              child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.only(right: 10.w, top: 10.h, bottom: 10.h),
                child: Text(
                    '${Get.locale == Locale("ar") ? category?.nameAr : category?.nameEn}'),
              ),
            ),
            isAdmin
                ? Column(
                    children: [
                      IconButton(
                          icon: Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                          onPressed: () {
                            if (category?.catId == null) return;
                            MashatelClient.mashatelClient
                                .deleteCategory(category!.catId!);
                          }),
                      IconButton(
                          icon: Icon(
                            Icons.edit,
                            color: Colors.blueAccent,
                          ),
                          onPressed: () {
                            Get.to(EditCategory(
                              imageUrl: category?.imagePath,
                              nameAr: category?.nameAr,
                              nameEn: category?.nameEn,
                              catId: category?.catId,
                            ));
                          })
                    ],
                  )
                : Container()
          ],
        ),
      ),
    );
  }
}
