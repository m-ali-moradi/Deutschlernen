import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provides a stream of the current connectivity status.
/// Yields `true` if connected to a mobile or wifi network, `false` otherwise.
final connectivityProvider = StreamProvider<bool>((ref) async* {
  final connectivity = Connectivity();

  // Yield the initial state
  final initialResult = await connectivity.checkConnectivity();
  yield _isConnected(initialResult);

  // Yield subsequent changes
  await for (final result in connectivity.onConnectivityChanged) {
    yield _isConnected(result);
  }
});

bool _isConnected(List<ConnectivityResult> results) {
  if (results.isEmpty) return false;
  
  return results.any((result) =>
      result == ConnectivityResult.mobile ||
      result == ConnectivityResult.wifi ||
      result == ConnectivityResult.ethernet ||
      result == ConnectivityResult.vpn);
}
