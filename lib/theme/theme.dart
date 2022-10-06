import 'package:cortex_library_mobile_app/theme/palette.dart';
import 'package:cortex_library_mobile_app/theme/textTheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

ThemeData data = ThemeData(
  scaffoldBackgroundColor: backgroundColor,
  // Colors
  colorScheme: ThemeData.light().colorScheme.copyWith(
        primary: primaryColor,
        background: backgroundColor,
      ),

  // inputs
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: secondaryColor,
    focusedBorder: InputBorder.none,
    errorBorder: InputBorder.none,
    focusedErrorBorder: InputBorder.none,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(12.r),
      ),
    ),
    hintStyle: bodyTextStyle,
    prefixIconColor: neutralColor,
    contentPadding: EdgeInsets.all(18.h),
    errorStyle: errorLabelTextStyle,
    errorMaxLines: 3,
  ),

  // elevated btn
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: primaryColor,
      textStyle: buttonTextStyle.copyWith(color: lightColor),
      padding: EdgeInsets.all(20.h),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(12.r),
        ),
      ),
    ),
  ),
);
