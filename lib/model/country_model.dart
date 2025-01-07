class CountryModel {
  final String name;
  final String flag;
  final String phoneCode;
  final String phoneFormat;

  CountryModel({
    required this.name,
    required this.flag,
    required this.phoneCode,
    required this.phoneFormat,
  });

  CountryModel copyWith({
    String? name,
    String? flag,
    String? phoneCode,
    String? phoneFormat,
  }) =>
      CountryModel(
        name: name ?? this.name,
        flag: flag ?? this.flag,
        phoneCode: phoneCode ?? this.phoneCode,
        phoneFormat: phoneFormat ?? this.phoneFormat,
      );

  factory CountryModel.fromJson(Map<String, dynamic> json) => CountryModel(
        name: json["name"] ?? 0,
        flag: json["flag"] ?? "",
        phoneCode: json["phone_code"] ?? "",
        phoneFormat: json["phone_format"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "flag": flag,
        "phone_code": phoneCode,
        "phone_format": phoneFormat,
      };
}
