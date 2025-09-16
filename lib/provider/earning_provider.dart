import 'package:flutter/material.dart';

class EarningProvider with ChangeNotifier {
  bool _isDeductionActive = false;
  bool _isExpanded = false;

  bool get isDeductionActive => _isDeductionActive;
  bool get isExpanded => _isExpanded;

  void setDeductionActive(bool value) {
    _isDeductionActive = value;
    notifyListeners();
  }

  void setExpanded(bool value) {
    _isExpanded = value;
    notifyListeners();
  }

  int _selectedIndex = 0;

  int get selectedIndex => _selectedIndex;

  void setIndex(int index) {
    _selectedIndex = index;
    notifyListeners();
  }
}
