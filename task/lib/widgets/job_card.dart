import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/app_theme.dart';
import '../core/s.dart';
import '../models/job_master.dart';
import '../providers/apply_provider.dart';

class JobCard extends StatelessWidget {
  final JobModel job;
  final VoidCallback onTap;

  const JobCard({super.key, required this.job, required this.onTap});

  @override
  Widget build(BuildContext context) {

    final applied = context.select<ApplyProvider, bool>(
      (p) => p.isApplied(job.id),
    );

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          job.title,
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          job.employerDisplay,
                          style: TextStyle(color: Colors.grey.shade600),
                        ),
                      ],
                    ),
                  ),
                  _MatchBadge(score: job.matchScore, text: job.matchText),
                ],
              ),
              const SizedBox(height: 12),
              _InfoRow(
                icon: Icons.location_on_outlined,
                text: '${job.city}, ${job.country}',
              ),
              const SizedBox(height: 6),
              _InfoRow(
                icon: Icons.payments_outlined,
                text: '${job.salaryText} ${context.s.perMonth}',
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: job.skills
                    .take(3)
                    .map((s) => _Chip(label: s))
                    .toList(),
              ),
              if (applied) ...[
                const SizedBox(height: 12),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.check_circle,
                      size: 18,
                      color: Colors.green.shade700,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      context.s.applied,
                      style: TextStyle(
                        color: Colors.green.shade700,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _InfoRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Icon(icon, size: 18, color: Colors.grey.shade600),
      const SizedBox(width: 6),
      Expanded(child: Text(text)),
    ],
  );
}

class _Chip extends StatelessWidget {
  final String label;

  const _Chip({required this.label});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    decoration: BoxDecoration(
      color: AppTheme.chipBg,
      borderRadius: BorderRadius.circular(20),
    ),
    child: Text(
      label,
      style: const TextStyle(fontSize: 12, color: AppTheme.primary),
    ),
  );
}

class _MatchBadge extends StatelessWidget {
  final double score;
  final String text;

  const _MatchBadge({required this.score, required this.text});

  Color get _color {
    if (score >= 80) return Colors.green.shade700;
    if (score >= 60) return Colors.orange.shade800;
    return Colors.grey.shade700;
  }

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
    decoration: BoxDecoration(
      color: _color.withValues(alpha: 0.12),
      borderRadius: BorderRadius.circular(10),
    ),
    child: Text(
      text,
      style: TextStyle(
        color: _color,
        fontWeight: FontWeight.w800,
        fontSize: 15,
      ),
    ),
  );
}
