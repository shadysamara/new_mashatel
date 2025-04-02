import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:mashatel/features/customers/blocs/app_get.dart';
import 'package:mashatel/features/customers/ui/pages/control_panel/new_category.dart';
import 'package:mashatel/features/customers/ui/pages/markets_page.dart';
import 'package:mashatel/features/customers/ui/widgets/main_category_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AdminCategoryPage extends StatelessWidget {
  AppGet appGet = Get.find();
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context,
        width: 392.72727272727275,
        height: 850.9090909090909,
        allowFontScaling: true);
    return Scaffold(
      appBar: AppBar(
        title: Text(translator.translate('category_control')),
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
                          child: Text(translator.translate('no_data')),
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
