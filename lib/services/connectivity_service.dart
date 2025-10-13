import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';

/// Service untuk monitoring koneksi internet
class ConnectivityService {
  static final ConnectivityService _instance = ConnectivityService._internal();
  factory ConnectivityService() => _instance;
  ConnectivityService._internal();

  final Connectivity _connectivity = Connectivity();
  StreamSubscription<List<ConnectivityResult>>? _subscription;

  /// Stream untuk mendengarkan perubahan koneksi
  Stream<List<ConnectivityResult>> get connectivityStream => 
      _connectivity.onConnectivityChanged;

  /// Memeriksa status koneksi saat ini
  Future<List<ConnectivityResult>> checkConnectivity() async {
    return await _connectivity.checkConnectivity();
  }

  /// Memulai monitoring koneksi
  void startListening(Function(List<ConnectivityResult>) onConnectivityChanged) {
    _subscription?.cancel();
    _subscription = connectivityStream.listen(onConnectivityChanged);
  }

  /// Menghentikan monitoring koneksi
  void stopListening() {
    _subscription?.cancel();
    _subscription = null;
  }

  /// Memeriksa apakah ada koneksi aktif
  static bool isConnected(List<ConnectivityResult> results) {
    return results.any((result) => 
        result == ConnectivityResult.mobile ||
        result == ConnectivityResult.wifi ||
        result == ConnectivityResult.ethernet);
  }
}
