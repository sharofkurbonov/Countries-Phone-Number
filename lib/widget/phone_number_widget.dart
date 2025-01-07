import 'package:countries_phone_number/constants/app_color.dart';
import 'package:countries_phone_number/constants/app_style.dart';
import 'package:countries_phone_number/helpers/phone_input_formatter.dart';
import 'package:countries_phone_number/model/country_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PhoneNumberWidget extends StatelessWidget {
  final CountryModel selectedCountry;
  final TextEditingController phoneCodeController;
  final TextEditingController phoneNumberController;
  final FocusNode phoneCodeFocusNode;
  final FocusNode phoneNumberFocusNode;
  final Function() showCountries;
  final Function(String text) onPhoneCodeChanged;
  final Function(String text) onPhoneNumberChanged;

  const PhoneNumberWidget({
    super.key,
    required this.selectedCountry,
    required this.phoneCodeController,
    required this.phoneNumberController,
    required this.phoneCodeFocusNode,
    required this.phoneNumberFocusNode,
    required this.showCountries,
    required this.onPhoneCodeChanged,
    required this.onPhoneNumberChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: 16.w,
      ),
      child: Column(
        children: [
          GestureDetector(
            onTap: showCountries,
            child: Container(
              height: 54.h,
              padding: EdgeInsets.symmetric(
                horizontal: 24.w,
              ),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: AppColor.grey,
                    width: 0.5.w,
                  ),
                ),
              ),
              child: Row(
                children: [
                  Text(
                    selectedCountry.flag,
                    style: AppStyle.w500s16h19Black,
                  ),
                  SizedBox(
                    width: 6.w,
                  ),
                  Text(
                    selectedCountry.name,
                    style: AppStyle.w500s16h19Black.copyWith(
                      color: AppColor.blue,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            height: 54.h,
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: AppColor.grey,
                  width: 0.5.w,
                ),
                bottom: BorderSide(
                  color: AppColor.grey,
                  width: 0.5.w,
                ),
              ),
            ),
            child: Row(
              children: [
                SizedBox(
                  width: 64.w,
                  child: TextField(
                    focusNode: phoneCodeFocusNode,
                    keyboardType: TextInputType.number,
                    controller: phoneCodeController,
                    maxLines: 1,
                    onTapOutside: (event) => FocusScope.of(context).unfocus(),
                    onChanged: (value) {
                      if (!value.startsWith('+')) {
                        phoneCodeController.text = '+$value';
                        phoneCodeController.selection = TextSelection.collapsed(
                          offset: phoneCodeController.text.length,
                        );
                      }
                      onPhoneCodeChanged(phoneCodeController.text);
                    },
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      TextInputFormatter.withFunction((oldValue, newValue) {
                        if (newValue.text.startsWith('+') && newValue.selection.baseOffset == 1) {
                          return newValue.copyWith(
                            text: '+${newValue.text.substring(1)}',
                            selection: TextSelection.collapsed(offset: 1),
                          );
                        }
                        return newValue;
                      }),
                    ],
                    cursorColor: AppColor.blue,
                    style: AppStyle.w500s16h22White,
                    decoration: InputDecoration(
                      filled: true,
                      counterText: '',
                      contentPadding: EdgeInsets.symmetric(horizontal: 4.w),
                      fillColor: Colors.transparent,
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Container(
                  width: 0.5.w,
                  height: 44.h,
                  color: AppColor.grey,
                ),
                Expanded(
                  child: TextField(
                    focusNode: phoneNumberFocusNode,
                    keyboardType: TextInputType.number,
                    controller: phoneNumberController,
                    maxLines: 1,
                    onTapOutside: (event) => FocusScope.of(context).unfocus(),
                    onChanged: (value) {
                      if (value.isEmpty || phoneCodeController.text == "+") {
                        phoneNumberController.clear();
                        phoneCodeController.text += value;
                        phoneCodeFocusNode.requestFocus();
                      }
                      onPhoneNumberChanged(phoneNumberController.text);
                    },
                    inputFormatters: [
                      customPhoneFormatter(selectedCountry.phoneFormat),
                    ],
                    cursorColor: AppColor.blue,
                    style: AppStyle.w500s16h22White,
                    decoration: InputDecoration(
                      filled: true,
                      counterText: '',
                      contentPadding: EdgeInsets.symmetric(horizontal: 24.w),
                      hintText: selectedCountry.phoneFormat.replaceAll("#", "0"),
                      hintStyle: AppStyle.w500s16h22White.copyWith(
                        color: AppColor.grey,
                      ),
                      fillColor: Colors.transparent,
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
