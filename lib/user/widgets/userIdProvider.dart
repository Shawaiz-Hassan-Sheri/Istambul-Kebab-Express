
import 'package:flutter/material.dart';

class UserIdProvider with ChangeNotifier {
  String _userId = '';

  String get userId => _userId;

  void setUserId(String id) {
    _userId = id;
    notifyListeners();
  }
}