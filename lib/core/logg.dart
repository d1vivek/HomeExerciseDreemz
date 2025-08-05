import 'package:flutter/foundation.dart';

class Logg {
  Logg._();

  static void printLog(String? message) {
    if(kDebugMode){
      print("MyLogger >> ${message ?? "Empty Log Message"}");
    }
  }
}
