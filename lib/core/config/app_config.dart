class AppConfigs {
  AppConfigs._();

  static const String fontFamily = 'OpenSans';
  static const String baseUrl = 'http://192.168.1.21:5297/api';
  static const int connectTimeout = 5000;
  static const int receiveTimeout = 5000;
  static const String dateDisplayFormat = 'dd/MM/yyyy';
  static const String dateTimeDisplayFormat = 'dd/MM/yyyy HH:mm';
  static const String dateTimeAPIFormat = 'YYYY-MM-DDThh:mm:ssTZD';
  static const int defaultPageSize = 20;
  static const int defaultPageIndex = 0;
  static const String tokenKey = 'token';
  static const double scrollThreshold = 0.7;
}
