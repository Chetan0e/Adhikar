import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  final Connectivity _connectivity = Connectivity();

  /// Check if device is currently online
  Future<bool> isOnline() async {
    final results = await _connectivity.checkConnectivity();
    return results.any((r) => r != ConnectivityResult.none);
  }

  /// Stream connectivity changes — emits true when online, false when offline
  Stream<bool> get onConnectivityChanged =>
      _connectivity.onConnectivityChanged.map(
        (results) => results.any((r) => r != ConnectivityResult.none),
      );

  /// Get current primary connectivity result
  Future<ConnectivityResult> get connectivityResult async {
    final results = await _connectivity.checkConnectivity();
    return results.firstOrNull ?? ConnectivityResult.none;
  }
}
