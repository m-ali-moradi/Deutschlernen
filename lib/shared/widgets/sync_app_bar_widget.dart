import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/content/sync/sync_state.dart';
import '../../core/database/database_providers.dart';

/// A shared widget to display sync status in AppBars.
class SyncAppBarWidget extends ConsumerWidget {
  const SyncAppBarWidget({
    super.key,
    required this.state,
    this.onSyncPressed,
  });

  /// The current state of synchronization.
  final SyncState state;

  /// Callback when the sync button is pressed.
  final VoidCallback? onSyncPressed;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prefs = ref.watch(userPreferencesStreamProvider).valueOrNull;
    final autoSync = prefs?.autoSync ?? false;

    // If auto-sync is off and we are "synced", show a "Sync" action instead of just a badge
    if (!autoSync && state.status == SyncStatus.synced) {
      return InkWell(
        onTap: onSyncPressed,
        borderRadius: BorderRadius.circular(12),
        child: _buildBadge(
          icon: Icons.sync_rounded,
          color: Theme.of(context).primaryColor,
          label: 'Sync',
        ),
      );
    }

    switch (state.status) {
      case SyncStatus.offline:
        return _buildBadge(
          icon: Icons.cloud_off_rounded,
          color: Colors.grey,
          label: 'Offline',
        );
      case SyncStatus.synced:
        return _buildBadge(
          icon: Icons.cloud_done_rounded,
          color: Colors.green,
          label: 'Synced',
        );
      case SyncStatus.updatesAvailable:
        return InkWell(
          onTap: onSyncPressed,
          borderRadius: BorderRadius.circular(12),
          child: _buildBadge(
            icon: Icons.sync_rounded,
            color: Theme.of(context).primaryColor,
            label: 'Update',
            showDot: true,
          ),
        );
      case SyncStatus.syncing:
        return _buildBadge(
          icon: Icons.sync_rounded,
          color: Theme.of(context).primaryColor,
          label: 'Syncing...',
          isSpinning: true,
        );
      case SyncStatus.error:
        return InkWell(
          onTap: onSyncPressed,
          borderRadius: BorderRadius.circular(12),
          child: _buildBadge(
            icon: Icons.error_outline_rounded,
            color: Colors.red,
            label: 'Error',
          ),
        );
    }
  }

  Widget _buildBadge({
    required IconData icon,
    required Color color,
    required String label,
    bool showDot = false,
    bool isSpinning = false,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            children: [
              if (isSpinning)
                SizedBox(
                  width: 14,
                  height: 14,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(color),
                  ),
                )
              else
                Icon(icon, size: 14, color: color),
              if (showDot)
                Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
