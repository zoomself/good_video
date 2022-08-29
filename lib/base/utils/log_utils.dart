
import 'package:flutter/foundation.dart';

class LogUtils{
  static void log(String info){
    if (kDebugMode) {
      print(info);
    }
  }
}