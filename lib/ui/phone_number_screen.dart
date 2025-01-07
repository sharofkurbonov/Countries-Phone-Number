import 'dart:convert';

import 'package:countries_phone_number/dialog/countries_dialog.dart';
import 'package:countries_phone_number/model/country_model.dart';
import 'package:countries_phone_number/widget/phone_number_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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

  @override
  void initState() {
    loadCountries();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF18222D),
      body: Center(
        child: ListView(
          shrinkWrap: true,
          children: [
            PhoneNumberWidget(
              selectedCountry: selectedCountry,
              phoneCodeController: phoneCodeController,
              phoneNumberController: phoneNumberController,
              phoneCodeFocusNode: phoneCodeFocusNode,
              phoneNumberFocusNode: phoneNumberFocusNode,
              showCountries: _showCountries,
              onPhoneCodeChanged: _onPhoneCodeChanged,
            ),
          ],
        ),
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
      selectedCountry = countries.firstWhere((country) => country.phoneCode == value);
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
}
