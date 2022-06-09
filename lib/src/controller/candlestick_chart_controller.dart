import 'package:flutter/cupertino.dart';

class CandlestickChartController extends ChangeNotifier{
  int index = 0;
  void setIndex(int value) {
    this.index = value;
    notifyListeners();
  }
}

