import 'package:meta/meta.dart';

class Modes {

  static Uri _uri;

  @visibleForTesting
  static set uri(Uri uri) => _uri = uri;

  /// If the url contains the quickroll query parameter
  static bool get quickroll => (_uri ?? Uri.base).queryParameters['quickroll'] != null;

  /// If the url contains the skiproster query parameter
  static bool get skiproster => (_uri ?? Uri.base).queryParameters['skiproster'] != null;

}