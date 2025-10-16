import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

// This StreamProvider will emit `true` when connected to the Internet, `false` when offline.
final internetStatusProvider = StreamProvider<bool>((ref) {
  final checker = InternetConnection();
  return checker.onStatusChange.map(
    (status) => status == InternetStatus.connected,
  );
});

/// A simple Provider to quickly access the latest boolean value
final isConnectedProvider = Provider<bool>((ref) {
  final asyncStatus = ref.watch(internetStatusProvider);
  return asyncStatus.value ?? true; // Assume online by default
});
