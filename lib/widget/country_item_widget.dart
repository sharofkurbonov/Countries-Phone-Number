import 'package:countries_phone_number/constants/app_color.dart';
import 'package:countries_phone_number/constants/app_style.dart';
import 'package:countries_phone_number/model/country_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CountryItemWidget extends StatelessWidget {
  final CountryModel country;
  final Function() onTap;

  const CountryItemWidget({
    super.key,
    required this.country,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 16.w,
      ),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(
            vertical: 12.h,
            horizontal: 4.w,
          ),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: AppColor.grey,
                width: 0.5.w,
              ),
            ),
          ),
          child: Row(
            children: [
              Text(
                country.flag,
                style: AppStyle.w500s16h22White,
              ),
              SizedBox(
                width: 6.w,
              ),
              Text(
                country.name,
                style: AppStyle.w500s16h22White.copyWith(
                  color: AppColor.black,
                ),
              ),
              Spacer(),
              Text(
                country.phoneCode,
                style: AppStyle.w500s16h22White.copyWith(
                  color: AppColor.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
