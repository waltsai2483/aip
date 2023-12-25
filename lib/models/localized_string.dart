import 'dart:ui';

import 'package:json_annotation/json_annotation.dart';

part 'localized_string.g.dart';

@JsonSerializable(explicitToJson: true)
class LocalizedString {
  @JsonKey(name: 'zh')
  String? chi;
  @JsonKey(name: 'en')
  String? eng;

  LocalizedString({this.chi, this.eng});

  Map<String, dynamic> toJson() => _$LocalizedStringToJson(this);

  String of(Locale locale) {
    if (locale.languageCode.contains('zh')) {
      return chi!;
    } else {
      return eng!;
    }
  }

  static String getChi(Map<String, dynamic>? map) => map?.keys.where((element) => element.toLowerCase().contains('zh')).map((e) => map[e]).firstOrNull ?? "";

  static String getEng(Map<String, dynamic>? map) => map?.keys.where((element) => element.toLowerCase().contains('en')).map((e) => map[e]).firstOrNull ?? "";

  factory LocalizedString.fromJson(Map<String, dynamic> json) => LocalizedString(chi: LocalizedString.getChi(json), eng: LocalizedString.getEng(json));
}
