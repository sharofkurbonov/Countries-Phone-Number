import 'package:countries_phone_number/constants/app_color.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppStyle {
  /// fonts
  static const String fontFamily = 'SFProDisplay';

  static TextStyle w500s16h19Black = TextStyle(
    fontFamily: fontFamily,
    fontWeight: FontWeight.w500,
    fontSize: 16.sp,
    height: 19 / 16,
    color: AppColor.black,
  );

  static TextStyle w500s16h22White = TextStyle(
    fontFamily: fontFamily,
    fontWeight: FontWeight.w500,
    fontSize: 16.sp,
    height: 22 / 16,
    color: AppColor.white,
  );
}
