import 'dart:convert';

import 'package:countries_phone_number/constants/app_color.dart';
import 'package:countries_phone_number/constants/app_style.dart';
import 'package:countries_phone_number/dialog/countries_dialog.dart';
import 'package:countries_phone_number/model/country_model.dart';
import 'package:countries_phone_number/widget/phone_number_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PhoneNumberScreen extends StatefulWidget {
  final String country;
  final String hint;

  const PhoneNumberScreen({
    super.key,
    this.country = "Country",
    this.hint = "Your phone number",
  });

  @override
  State<PhoneNumberScreen> createState() => _PhoneNumberScreenState();
}

class _PhoneNumberScreenState extends State<PhoneNumberScreen> {
  List<CountryModel> countries = [];
  CountryModel selectedCountry = CountryModel(
    name: "Uzbekistan",
    flag: "🇺🇿",
    phoneCode: "+998",
    phoneFormat: "## ### ## ##",
  );

  final TextEditingController phoneCodeController = TextEditingController(text: "+998");
  final TextEditingController phoneNumberController = TextEditingController();
  final FocusNode phoneCodeFocusNode = FocusNode();
  final FocusNode phoneNumberFocusNode = FocusNode();

  String phoneNumber = "";
  bool isValid = false;

  @override
  void initState() {
    loadCountries();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      body: Column(
        children: [
          Spacer(),
          Expanded(
            child: Center(
              child: ListView(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  PhoneNumberWidget(
                    selectedCountry: selectedCountry,
                    phoneCodeController: phoneCodeController,
                    phoneNumberController: phoneNumberController,
                    phoneCodeFocusNode: phoneCodeFocusNode,
                    phoneNumberFocusNode: phoneNumberFocusNode,
                    showCountries: _showCountries,
                    onPhoneCodeChanged: _onPhoneCodeChanged,
                    onPhoneNumberChanged: _onPhoneNumberChanged,
                  ),
                ],
              ),
            ),
          ),
          Spacer(),
          Text(
            phoneNumber,
            style: AppStyle.w500s16h22White.copyWith(
              color: AppColor.black,
            ),
          ),
          GestureDetector(
            onTap: _send,
            child: Container(
              height: 56.h,
              width: double.infinity,
              margin: EdgeInsets.symmetric(
                horizontal: 16.w,
                vertical: 24.h,
              ),
              decoration: BoxDecoration(
                color: isValid ? Colors.blue : Colors.grey.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Center(
                child: Text(
                  "Continue",
                  style: AppStyle.w500s16h22White.copyWith(
                    color: isValid ? AppColor.white : AppColor.grey,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> loadCountries() async {
    final String response = await rootBundle.loadString('assets/countries.json');
    final data = json.decode(response) as Map<String, dynamic>;
    final List<CountryModel> countriesData =
        (data['countries'] as List).map((item) => CountryModel.fromJson(item)).toList();
    countries = countriesData;
  }

  void _showCountries() {
    CountriesDialog.show(
      context,
      countries: countries,
      onChange: (country) {
        selectedCountry = country;
        phoneCodeController.clear();
        phoneNumberController.clear();
        phoneCodeController.text = selectedCountry.phoneCode;
        phoneNumberFocusNode.requestFocus();
        setState(() {});
      },
    );
  }

  void _onPhoneCodeChanged(String value) {
    try {
      if (value == "+1" || value == "+7") {
        selectedCountry = countries.where((country) => country.phoneCode == value).elementAt(1);
      } else {
        selectedCountry = countries.firstWhere((country) => country.phoneCode == value);
      }
      phoneNumberFocusNode.requestFocus();
    } catch (e) {
      selectedCountry = CountryModel(
        name: widget.country,
        flag: "",
        phoneCode: "",
        phoneFormat: widget.hint,
      );
    }
    setState(() {});
  }

  void _onPhoneNumberChanged(String value) {
    if (value.isNotEmpty) {
      isValid = true;
    } else {
      isValid = false;
      phoneNumber = "";
    }
    setState(() {});
  }

  void _send() {
    if (isValid) {
      phoneNumber = phoneCodeController.text + phoneNumberController.text.replaceAll(" ", "");
      setState(() {});
    }
  }
}
