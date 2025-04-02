import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mashatel/values/colors.dart';

class MyTextField extends StatelessWidget {
  final String hintTextKey;
  final isEdit;
  final initialValue;
  final Function saveFunction;
  final Function validateFunction;
  final int nofLines;
  final TextInputType textInputType;
  MyTextField(
      {this.hintTextKey,
      this.saveFunction,
      this.validateFunction,
      this.nofLines = 1,
      this.isEdit = false,
      this.initialValue,
      this.textInputType = TextInputType.text});

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context,
        width: 392.72727272727275,
        height: 850.9090909090909,
        allowFontScaling: true);
    return Container(
      child: TextFormField(
        initialValue: isEdit ? initialValue : '',
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
          return validateFunction(value.trim());
        },
        onSaved: (newValue) => saveFunction(newValue.trim()),
        onChanged: (value) => validateFunction(value.trim()),
        style: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: ScreenUtil().setSp(18, allowFontScalingSelf: true),
        ),
      ),
    );
  }
}
