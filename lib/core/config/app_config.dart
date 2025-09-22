class AppConfigs {
  AppConfigs._();

  static const String appName = 'Kmonie';

  static const String fontFamily = 'OpenSans';
  static const String defaultLanguage = 'vi';
  static const String baseUrl = 'http://192.168.100.8:3000/api/v1';
  static const int connectTimeout = 5000;
  static const int receiveTimeout = 5000;
  static const int pageSize = 40;
  static const int pageSizeMax = 1000;

  static const String dateDisplayFormat = 'dd/MM/yyyy';
  static const String dateTimeDisplayFormat = 'dd/MM/yyyy HH:mm';

  static const String dateTimeAPIFormat = 'YYYY-MM-DDThh:mm:ssTZD';
  static const String dateAPIFormat = 'dd/MM/yyyy';

  static final DateTime identityMinDate = DateTime(1900);
  static final DateTime identityMaxDate = DateTime.now();
  static final DateTime birthMinDate = DateTime(1900);
  static final DateTime birthMaxDate = DateTime.now();

  static const int maxAttachFile = 5;

  static const double scrollThreshold = 500.0;
}

class FirebaseConfig {}

class DatabaseConfig {
  static const int version = 1;
}
