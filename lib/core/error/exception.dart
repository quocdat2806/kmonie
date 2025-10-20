class CacheException implements Exception {
  CacheException({this.message = 'Cache error occurred'});
  final String message;
}
