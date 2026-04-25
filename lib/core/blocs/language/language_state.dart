import 'package:flutter/material.dart';

class LanguageState {
  final Locale locale;
  final String languageCode;

  const LanguageState({
    required this.locale,
    required this.languageCode,
  });

  factory LanguageState.initial() {
    return const LanguageState(
      locale: Locale('en'),
      languageCode: 'en',
    );
  }

  LanguageState copyWith({Locale? locale, String? languageCode}) {
    return LanguageState(
      locale: locale ?? this.locale,
      languageCode: languageCode ?? this.languageCode,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is LanguageState &&
        other.locale == locale &&
        other.languageCode == languageCode;
  }

  @override
  int get hashCode => locale.hashCode ^ languageCode.hashCode;
}
