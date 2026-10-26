import 'package:flutter/material.dart';

/// Runtime Bilingual Locale Controller (English <-> Hindi)
class LocaleController extends ChangeNotifier {
  Locale _locale = const Locale('en');

  Locale get locale => _locale;
  bool get isHindi => _locale.languageCode == 'hi';

  void setLocale(Locale newLocale) {
    if (_locale == newLocale) return;
    _locale = newLocale;
    notifyListeners();
  }

  void toggleLocale() {
    _locale = _locale.languageCode == 'en' ? const Locale('hi') : const Locale('en');
    notifyListeners();
  }
}

/// Global singleton or inherited accessor
final localeController = LocaleController();
