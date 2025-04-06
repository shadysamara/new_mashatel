import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:mashatel/features/customers/blocs/app_get.dart';
import 'package:mashatel/features/customers/modles/category.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mashatel/features/sign_in/providers/signInGetx.dart';
import 'package:mashatel/values/colors.dart';
import 'package:provider/provider.dart';

class CategoriesDropDown extends StatefulWidget {
  Function? dropDownBtnFunction;

  CategoriesDropDown({this.dropDownBtnFunction});

  @override
  _CategoriesDropDownState createState() => _CategoriesDropDownState();
}

class _CategoriesDropDownState extends State<CategoriesDropDown> {
  AppGet appGet = Get.put(AppGet());

  SignInGetx signInGetx = Get.put(SignInGetx());

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      height: 62.h,
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
            side: BorderSide(color: AppColors.primaryColor, width: 2.0.w),
            borderRadius: BorderRadius.all(new Radius.circular(50.0.h))),
      ),
      child: DropdownButton<Category>(
        hint: Text("dropDownCategory".tr),
        isExpanded: true,
        icon: Icon(Icons.keyboard_arrow_down),
        underline: Container(),
        value: signInGetx.category,
        items: appGet.allCategories.map((e) {
          return DropdownMenuItem<Category>(
            child:
                Text((Get.locale == Locale("en") ? e.nameEn : e.nameAr) ?? ''),
            value: e,
          );
        }).toList(),
        onChanged: (value) {
          signInGetx.category = value;
          setState(() {});
        },
      ),
    );
  }
}
