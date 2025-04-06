import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import 'package:mashatel/features/customers/blocs/app_get.dart';
import 'package:mashatel/features/customers/ui/pages/control_panel/new_category.dart';
import 'package:mashatel/features/customers/ui/pages/markets_page.dart';
import 'package:mashatel/features/customers/ui/widgets/main_category_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AdminCategoryPage extends StatelessWidget {
  AppGet appGet = Get.find();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('category_control'.tr),
        actions: [
          IconButton(
              icon: Icon(Icons.add, color: Colors.white),
              onPressed: () {
                Get.to(NewCategory());
              })
        ],
      ),
      body: Container(
        child: Column(
          children: [
            Expanded(
              child: Container(
                child: Obx(() {
                  return appGet.allCategories.isNotEmpty
                      ? ListView.builder(
                          itemCount: appGet.allCategories.length,
                          itemBuilder: (context, index) {
                            return Container(
                              margin: EdgeInsets.symmetric(horizontal: 10.w),
                              child: Obx(() {
                                return CategoryWidget(
                                  category: appGet.allCategories[index],
                                  isAdmin: true,
                                );
                              }),
                            );
                          },
                        )
                      : Center(
                          child: Text('no_data'.tr),
                        );
                }),
              ),
            )
          ],
        ),
      ),
    );
  }
}
