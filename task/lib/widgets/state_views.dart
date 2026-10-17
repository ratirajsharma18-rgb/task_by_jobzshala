import 'package:flutter/material.dart';

import '../core/s.dart';

/// Loading state: grey placeholder cards, never a blank screen.
class JobListSkeleton extends StatelessWidget {
  const JobListSkeleton({super.key});

  Widget _box(double w, double h) => Container(
        width: w,
        height: h,
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(6),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 5,
      itemBuilder: (_, __) => Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _box(180, 18),
              const SizedBox(height: 8),
              _box(120, 14),
              const SizedBox(height: 16),
              _box(150, 14),
              const SizedBox(height: 8),
              _box(200, 14),
              const SizedBox(height: 16),
              Row(children: [
                _box(70, 24),
                const SizedBox(width: 6),
                _box(70, 24),
              ]),
            ],
          ),
        ),
      ),
    );
  }
}

class EmptyView extends StatelessWidget {
  const EmptyView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.work_off_outlined, size: 72, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            Text(context.s.noMatches,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            Text(context.s.noMatchesSub,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey.shade600)),
          ],
        ),
      ),
    );
  }
}

class ErrorView extends StatelessWidget {
  final VoidCallback onRetry;
  const ErrorView({super.key, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.cloud_off_outlined, size: 72, color: Colors.red.shade300),
            const SizedBox(height: 16),
            Text(context.s.errorTitle,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            Text(context.s.errorSub,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey.shade600)),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: Text(context.s.retry),
            ),
          ],
        ),
      ),
    );
  }
}

/// Bottom of the list: spinner while loading the next page, or a retry button.
class ListFooter extends StatelessWidget {
  final bool failed;
  final VoidCallback onRetry;
  const ListFooter({super.key, required this.failed, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Center(
        child: failed
            ? TextButton(
                onPressed: onRetry, child: Text(context.s.loadMoreFailed))
            : const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(strokeWidth: 2.5),
              ),
      ),
    );
  }
}
