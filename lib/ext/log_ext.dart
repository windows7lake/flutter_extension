import 'dart:convert';
import 'dart:developer' as logger;
import 'dart:io';

import 'package:flutter/foundation.dart';

class LogExt {
  static void log(
    Object object, {
    String tag = "log100 ^_^ : ",
  }) {
    if (!kReleaseMode) {
      // debug
      if (Platform.isIOS) {
        logger.log("$tag $object");
      } else {
        debugPrint("$tag $object");
      }
    }
  }

  static JsonDecoder decoder = JsonDecoder();
  static JsonEncoder encoder = JsonEncoder.withIndent('  ');

  /// 打印Json格式化数据
  static void prettyPrintJson(String input) {
    try {
      var object = decoder.convert(input);
      var prettyString = encoder.convert(object);
      prettyString.split('\n').forEach((element) => log(element));
    } on FormatException catch (_) {
      log(input, tag: "");
    }
  }
}
