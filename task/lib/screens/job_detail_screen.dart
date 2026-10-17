import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/app_theme.dart';
import '../core/s.dart';
import '../models/job_master.dart';
import '../providers/apply_provider.dart';
import '../providers/connectivity_provider.dart';
import '../widgets/apply_success_dialog.dart';
import '../widgets/language_button.dart';

class JobDetailScreen extends StatelessWidget {
  final JobModel job;
  const JobDetailScreen({super.key, required this.job});

  Future<void> _apply(BuildContext context) async {
    final s = context.s;
    final messenger = ScaffoldMessenger.of(context);
    final ok = await context.read<ApplyProvider>().apply(job.id);

    if (!context.mounted) return;
    if (ok) {
      showApplySuccessDialog(context);
    } else {
      messenger.showSnackBar(SnackBar(
        content: Text(s.applyFailed),
        backgroundColor: Colors.red.shade700,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = context.s;
    final applied = context.watch<ApplyProvider>().isApplied(job.id);
    final offline = context.watch<ConnectivityProvider>().isOffline;

    return Scaffold(
      appBar: AppBar(
        title: Text(s.jobDetails),
        actions: const [LanguageButton()],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(job.title,
                style:
                    const TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
            const SizedBox(height: 4),
            Text(job.employerDisplay,
                style: TextStyle(color: Colors.grey.shade600, fontSize: 15)),
            const SizedBox(height: 12),
            Text('${job.city}, ${job.country}'),
            const SizedBox(height: 4),
            Text('${job.salaryText} ${s.perMonth}',
                style: const TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 16),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppTheme.chipBg,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    const Icon(Icons.auto_awesome,
                        size: 18, color: AppTheme.primary),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text('${s.whyMatch} · ${job.matchText}',
                          style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              color: AppTheme.primary)),
                    ),
                  ]),
                  const SizedBox(height: 6),
                  Text(job.matchReason),
                ],
              ),
            ),
            const SizedBox(height: 20),

            _Title(s.description),
            Text(job.description, style: const TextStyle(height: 1.5)),
            const SizedBox(height: 20),

            _Title(s.requirements),
            ...job.requirements.map((r) => Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [const Text('•  '), Expanded(child: Text(r))],
                  ),
                )),
            const SizedBox(height: 20),

            _Title(s.benefits),
            _Benefit(label: s.accommodation, value: job.benefits.accommodation),
            _Benefit(label: s.food, value: job.benefits.food),
            _Benefit(label: s.visa, value: job.benefits.visa),
            const SizedBox(height: 16),
          ],
        ),
      ),

      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // tell the user why Apply is disabled
              if (offline && !applied)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      Icon(Icons.wifi_off,
                          size: 16, color: Colors.orange.shade800),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(s.offlineApply,
                            style: TextStyle(
                                color: Colors.orange.shade800, fontSize: 13)),
                      ),
                    ],
                  ),
                ),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primary,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor:
                        applied ? Colors.green.shade600 : Colors.grey.shade300,
                    disabledForegroundColor:
                        applied ? Colors.white : Colors.grey.shade600,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: (applied || offline) ? null : () => _apply(context),
                  icon: applied
                      ? const Icon(Icons.check_circle)
                      : const SizedBox.shrink(),
                  label: Text(applied ? s.applied : s.apply,
                      style: const TextStyle(
                          fontSize: 17, fontWeight: FontWeight.w700)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Title extends StatelessWidget {
  final String text;
  const _Title(this.text);

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Text(text,
            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700)),
      );
}

class _Benefit extends StatelessWidget {
  final String label;
  final bool value;
  const _Benefit({required this.label, required this.value});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: Row(children: [
          Icon(value ? Icons.check_circle : Icons.cancel,
              size: 20,
              color: value ? Colors.green.shade600 : Colors.grey.shade400),
          const SizedBox(width: 8),
          Text(label),
        ]),
      );
}
