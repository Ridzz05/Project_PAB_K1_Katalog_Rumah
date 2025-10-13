import 'package:flutter/material.dart';
import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'constants/app_constants.dart';
import 'services/connectivity_service.dart';
import 'widgets/cloud_widget.dart';
import 'widgets/connection_toggle.dart';
import 'widgets/connection_status_text.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appName,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppConstants.primaryBlue),
      ),
      home: const InternetConnectionScreen(title: AppConstants.appTitle),
    );
  }
}

/// Screen utama untuk menampilkan status koneksi internet
class InternetConnectionScreen extends StatefulWidget {
  const InternetConnectionScreen({super.key, required this.title});
  final String title;

  @override
  State<InternetConnectionScreen> createState() => _InternetConnectionScreenState();
}

class _InternetConnectionScreenState extends State<InternetConnectionScreen> {
  bool _isConnected = true;
  bool _isCloudReady = false;
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;
  final ConnectivityService _connectivityService = ConnectivityService();

  /// Toggle koneksi secara manual (untuk testing)
  void _toggleConnection() {
    setState(() {
      _isConnected = !_isConnected;
    });
  }

  /// Memeriksa status koneksi saat ini
  void _checkConnectivity() async {
    final connectivityResults = await _connectivityService.checkConnectivity();
    _updateConnectionStatus(connectivityResults);
  }

  /// Update status koneksi berdasarkan hasil connectivity
  void _updateConnectionStatus(List<ConnectivityResult> connectivityResults) {
    final bool isConnected = ConnectivityService.isConnected(connectivityResults);

    if (mounted) {
      setState(() {
        _isConnected = isConnected;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _checkConnectivity();
    _connectivitySubscription = _connectivityService.connectivityStream.listen(
      _updateConnectionStatus,
    );
  }

  @override
  void dispose() {
    _connectivityService.stopListening();
    _connectivitySubscription.cancel();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (mounted) {
      setState(() {
        _isCloudReady = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: AppConstants.primaryBlue,
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                CloudWidget(
                  isReady: _isCloudReady,
                  assetPath: 'assets/cloud/cloud.svg',
                ),
                Positioned(
                  bottom: AppConstants.bottomOffset,
                  child: ConnectionToggle(
                    isConnected: _isConnected,
                    onTap: _toggleConnection,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppConstants.verticalSpacing),
            ConnectionStatusText(isConnected: _isConnected),
          ],
        ),
      ),
    );
  }
}
