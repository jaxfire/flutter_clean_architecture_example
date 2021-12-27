import 'package:internet_connection_checker/internet_connection_checker.dart';

abstract class NetworkInfo {
  Future<bool> isConnected();
}

class NetworkInfoImpl implements NetworkInfo {
  InternetConnectionChecker _internetConnectionChecker;

  NetworkInfoImpl(this._internetConnectionChecker);

  @override
  Future<bool> isConnected() => _internetConnectionChecker.hasConnection;
}
