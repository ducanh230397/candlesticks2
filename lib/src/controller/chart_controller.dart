import 'package:flutter/cupertino.dart';

class TradingChartController extends ChangeNotifier{
  int index = 0;
  void setIndex(int value) {
    this.index = value;
    notifyListeners();
  }
}

