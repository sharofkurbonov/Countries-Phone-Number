import 'package:countries_phone_number/constants/app_color.dart';
import 'package:countries_phone_number/constants/app_style.dart';
import 'package:countries_phone_number/model/country_model.dart';
import 'package:countries_phone_number/widget/country_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CountriesDialog extends StatefulWidget {
  final List<CountryModel> countries;
  final Function(CountryModel country) onChange;

  const CountriesDialog._({
    required this.countries,
    required this.onChange,
  });

  static void show(
    BuildContext context, {
    required List<CountryModel> countries,
    required Function(CountryModel country) onChange,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return CountriesDialog._(
          countries: countries,
          onChange: onChange,
        );
      },
    );
  }

  @override
  State<CountriesDialog> createState() => _CountriesDialogState();
}

class _CountriesDialogState extends State<CountriesDialog> {
  final TextEditingController searchController = TextEditingController();
  FocusNode currentFocus = FocusNode();

  List<CountryModel> searchResult = [];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16.r),
          topRight: Radius.circular(16.r),
        ),
      ),
      child: Column(
        children: [
          Container(
            height: 4.h,
            width: 32.w,
            margin: EdgeInsets.only(
              top: 12.h,
            ),
            decoration: BoxDecoration(color: AppColor.grey, borderRadius: BorderRadius.circular(24.r)),
          ),
          Padding(
            padding: EdgeInsets.only(
              left: 24.w,
              right: 24.w,
              top: 24.h,
            ),
            child: TextField(
              focusNode: currentFocus,
              controller: searchController,
              style: AppStyle.w500s16h22White.copyWith(
                color: AppColor.black,
              ),
              decoration: InputDecoration(
                hintText: "Search",
                hintStyle: AppStyle.w500s16h22White.copyWith(
                  color: AppColor.grey,
                ),
                border: InputBorder.none,
                suffixIcon: SizedBox(
                  width: 20.h,
                  height: 20.h,
                  child: Icon(
                    Icons.search,
                    color: AppColor.grey,
                  ),
                ),
                suffixIconConstraints: BoxConstraints(
                  minWidth: 20.w,
                  minHeight: 20.w,
                ),
                enabledBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: AppColor.grey,
                  ),
                ),
                focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: AppColor.blue,
                  ),
                ),
              ),
              onChanged: onSearchTextChanged,
            ),
          ),
          SizedBox(
            height: 8.h,
          ),
          Expanded(
            child: searchResult.isNotEmpty || searchController.text.isNotEmpty
                ? ListView.builder(
                    padding: EdgeInsets.symmetric(
                      vertical: 16.h,
                    ),
                    itemCount: searchResult.length,
                    itemBuilder: (context, index) {
                      return CountryItemWidget(
                        country: searchResult[index],
                        onTap: () {
                          if (currentFocus.hasFocus) {
                            currentFocus.unfocus();
                          }
                          Navigator.pop(context);
                          widget.onChange(searchResult[index]);
                        },
                      );
                    },
                  )
                : ListView.builder(
                    padding: EdgeInsets.symmetric(
                      vertical: 16.h,
                    ),
                    itemCount: widget.countries.length,
                    itemBuilder: (context, index) {
                      return CountryItemWidget(
                        country: widget.countries[index],
                        onTap: () {
                          if (currentFocus.hasFocus) {
                            currentFocus.unfocus();
                          }
                          Navigator.pop(context);
                          widget.onChange(widget.countries[index]);
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  onSearchTextChanged(String text) async {
    searchResult.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }
    for (var countryDetail in widget.countries) {
      if (countryDetail.name.toUpperCase().contains(text.toUpperCase()) ||
          countryDetail.name.toUpperCase().contains(text.toUpperCase()) ||
          countryDetail.phoneCode.toUpperCase().contains(text.toUpperCase())) {
        searchResult.add(countryDetail);
      }
    }

    searchResult.sort((a, b) {
      bool aStartsWith = a.name.toUpperCase().startsWith(text.toUpperCase());
      bool bStartsWith = b.name.toUpperCase().startsWith(text.toUpperCase());

      if (aStartsWith && !bStartsWith) {
        return -1;
      } else if (!aStartsWith && bStartsWith) {
        return 1;
      } else {
        return a.name.compareTo(b.name);
      }
    });

    setState(() {});
  }
}
