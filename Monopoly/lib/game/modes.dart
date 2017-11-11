import 'package:meta/meta.dart';

class Modes {

  static Uri _uri;

  @visibleForTesting
  static set uri(Uri uri) => _uri = uri;

  static bool get quickroll => (_uri ?? Uri.base).queryParameters['quickroll'] != null;

  static bool get skiproster => (_uri ?? Uri.base).queryParameters['skiproster'] != null;

}