import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  final Connectivity _connectivity = Connectivity();

  /// Check if device is currently online using DNS lookup
  /// This checks actual internet connectivity, not just network status
  Future<bool> hasInternet() async {
    try {
      // First check if network is available
      final results = await _connectivity.checkConnectivity();
      if (!results.any((r) => r != ConnectivityResult.none)) {
        return false;
      }
      
      // Then verify actual internet connectivity with DNS lookup
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  /// Check if device is currently online (legacy method)
  Future<bool> isOnline() async {
    return hasInternet();
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
