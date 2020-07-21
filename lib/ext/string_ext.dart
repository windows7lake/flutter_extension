class StringExt {
  /// 判断是否为null或者空字符串
  static bool isNullOrEmpty(String value) {
    if (value == null) return true;
    if (value.length <= 0) return true;
    return false;
  }
}
