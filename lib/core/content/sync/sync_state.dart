import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'connectivity_service.dart';


enum SyncStatus {
  offline,
  synced,
  updatesAvailable,
  syncing,
  error,
}

class SyncState {
  final SyncStatus status;
  final bool manualSyncTriggered;
  final DateTime? lastManualSyncAt;

  SyncState({
    required this.status,
    this.manualSyncTriggered = false,
    this.lastManualSyncAt,
  });

  SyncState copyWith({
    SyncStatus? status,
    bool? manualSyncTriggered,
    DateTime? lastManualSyncAt,
  }) {
    return SyncState(
      status: status ?? this.status,
      manualSyncTriggered: manualSyncTriggered ?? this.manualSyncTriggered,
      lastManualSyncAt: lastManualSyncAt ?? this.lastManualSyncAt,
    );
  }
}

class SyncNotifier extends Notifier<SyncState> {
  @override
  SyncState build() {
    final isConnected = ref.watch(connectivityProvider).valueOrNull ?? false;
    return SyncState(
      status: isConnected ? SyncStatus.synced : SyncStatus.offline,
    );
  }

  void triggerManualSync() {
    state = state.copyWith(
      manualSyncTriggered: true,
      lastManualSyncAt: DateTime.now(),
      status: SyncStatus.syncing,
    );
    
    // Reset syncing status after a short delay or when providers finish
    // For now, just set it to synced after a simulated delay or let the providers handle it.
    Future.delayed(const Duration(seconds: 2), () {
      if (state.status == SyncStatus.syncing) {
        state = state.copyWith(status: SyncStatus.synced);
      }
    });
  }

  void setStatus(SyncStatus status) {
    state = state.copyWith(status: status);
  }
}

final syncStateProvider = NotifierProvider<SyncNotifier, SyncState>(SyncNotifier.new);
