import 'package:flutter/material.dart';

class LoadingProvider with ChangeNotifier {
  LoadingProvider({isLoad = false});

  bool isLoad = false;

  void setIsLoad() {
    isLoad = !isLoad;
    notifyListeners();
  }
}
