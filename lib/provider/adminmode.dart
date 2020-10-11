import 'package:flutter/cupertino.dart';

class AdminMode extends ChangeNotifier{
  bool isAdmin = false;
  changeisadmin(bool value) {
    isAdmin=value;
    notifyListeners();
  }
}