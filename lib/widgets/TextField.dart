import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mashatel/values/colors.dart';

class MyTextField extends StatelessWidget {
  String hintTextKey;

  Function saveFunction;
  Function validateFunction;
  int nofLines;
  TextInputType textInputType;
  MyTextField(
      {this.hintTextKey,
      this.saveFunction,
      this.validateFunction,
      this.nofLines = 1,
      this.textInputType = TextInputType.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextFormField(
        maxLines: nofLines,
        onFieldSubmitted: (value) {
          FocusScope.of(context).nextFocus();
        },
        textInputAction: TextInputAction.next,
        keyboardType: textInputType,
        decoration: InputDecoration(
          helperText: ' ',
          alignLabelWithHint: true,
          labelText: translator.translate(hintTextKey),
          labelStyle: TextStyle(
            fontSize: ScreenUtil().setSp(15, allowFontScalingSelf: true),
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.primaryColor, width: 2.0.w),
            borderRadius: BorderRadius.all(new Radius.circular(50.0.h)),
          ),
        ),
        validator: (value) {
          return validateFunction(value);
        },
        onSaved: (newValue) => saveFunction(newValue),
        onChanged: (value) => validateFunction(value),
        style: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: ScreenUtil().setSp(18, allowFontScalingSelf: true),
        ),
      ),
    );
  }
}
