class Modes {

  static bool get quickroll => Uri.base.queryParameters['quickroll'] != null;

  static bool get skiproster => Uri.base.queryParameters['skiproster'] != null;

}