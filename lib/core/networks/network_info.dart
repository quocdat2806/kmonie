import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';

abstract class NetworkInfo {
  Future<bool> get isConnected;
}

class NetworkInfoImpl implements NetworkInfo {
  final Connectivity connectivity;

  NetworkInfoImpl(this.connectivity);

  @override
  Future<bool> get isConnected async {
    final List<ConnectivityResult> connectivityResult = await connectivity.checkConnectivity();

    if (connectivityResult.contains(ConnectivityResult.none)) return false;
    try {
      final lookup = await InternetAddress.lookup('https://www.google.com/');
      return lookup.isNotEmpty && lookup.first.rawAddress.isNotEmpty;
    } catch (_) {
      return false;
    }
  }
}
