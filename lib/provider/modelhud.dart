import 'package:flutter/cupertino.dart';

class ModelHud extends ChangeNotifier {
  bool isLoading = false;
  changeisloading(bool value) {
    isLoading = value;
    notifyListeners();
  }
}
