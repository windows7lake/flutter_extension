import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_extension/cache/sp/sp_manager.dart';
import 'package:flutter_extension/cache/sp/sp_params.dart';

import 'api.dart';

class HeaderInterceptor extends InterceptorsWrapper {
  /// 获取网络请求URL <br/>
  static Future<String> getBaseUrl() async {
    String url = Api.RELEASE;
    int env = SpManager.getInt(
      SpParams.ENV.toString(),
      defaultValue: kReleaseMode ? 1 : 2,
    );
    switch (env) {
      case 1:
        url = Api.RELEASE;
        break;
      case 2:
        url = Api.DEBUG;
        break;
      case 3:
        url = Api.DEV;
        break;
    }
    return url;
  }

  /// 添加Header拦截器 <br/>
  addHeaderInterceptors(RequestOptions options) async {
    // 兼容v2 和 image/webp 的参数
    var accept = options.headers["accept"];
    options.headers.remove("accept");
    options.headers["accept"] = "$accept; image/webp";

    options.headers["Authorization"] = "Bearer " + "12312312313213213213321";
  }

  @override
  Future onRequest(RequestOptions options) async {
    String url = await getBaseUrl();
    options.baseUrl = url;
    options.headers["User-Agent"] = "User-Agent";
    addHeaderInterceptors(options);
    return options;
  }
}
