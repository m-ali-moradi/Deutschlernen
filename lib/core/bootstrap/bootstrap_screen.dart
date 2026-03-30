import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'bootstrap_service.dart';

/// A premium-themed splash screen displayed while the application is bootstrapping.
/// 
/// It leverages vibrant gradients and subtle animations to ensure the first
/// impression of the "DeutschMate" brand is sophisticated and reliable.
class BootstrapScreen extends ConsumerWidget {
  const BootstrapScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(bootstrapProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? [const Color(0xFF0F172A), const Color(0xFF1E293B)]
                : [const Color(0xFFF8FAFC), const Color(0xFFE2E8F0)],
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(flex: 2),
              // App Logo placeholder or Branding
              Column(
                children: [
                  Text(
                    'DeutschMate',
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -1.5,
                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Master German, Smarter.',
                    style: TextStyle(
                      fontSize: 16,
                      color: isDark ? Colors.white70 : Colors.black54,
                      letterSpacing: 1.2,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              _buildProgressIndicator(state, isDark),
              const SizedBox(height: 48),
              if (state.status == BootstrapStatus.error)
                _buildErrorState(state.errorMessage)
              else
                _buildLoadingFooter(state.status, isDark),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProgressIndicator(BootstrapState state, bool isDark) {
    return SizedBox(
      width: 200,
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: state.status == BootstrapStatus.ready ? 1.0 : null,
              backgroundColor: isDark ? Colors.white10 : Colors.black12,
              valueColor: AlwaysStoppedAnimation<Color>(
                isDark ? const Color(0xFFFBBF24) : const Color(0xFFD97706),
              ),
              minHeight: 4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingFooter(BootstrapStatus status, bool isDark) {
    String text = 'Initializing...';
    if (status == BootstrapStatus.loadingAssets) {
      text = 'Loading local curriculum...';
    }

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: Text(
        text,
        key: ValueKey(text),
        style: TextStyle(
          color: isDark ? Colors.white54 : Colors.black45,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildErrorState(String? message) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        children: [
          const Icon(Icons.error_outline, color: Colors.redAccent, size: 32),
          const SizedBox(height: 16),
          Text(
            'Initialization Failed',
            style: TextStyle(
              color: Colors.redAccent.withValues(alpha: 0.8),
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            message ?? 'An unknown error occurred.',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}

