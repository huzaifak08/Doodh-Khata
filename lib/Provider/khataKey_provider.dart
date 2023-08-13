import 'package:flutter/material.dart';

class KhatakeyProvider extends ChangeNotifier {
  String _khatakey = '';

  String get khataKey => _khatakey;

  void setKhataKey(String key) {
    _khatakey = key;
    notifyListeners();
  }
}
