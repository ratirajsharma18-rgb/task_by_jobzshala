import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/s.dart';
import '../providers/job_list_provider.dart';

class CountryFilter extends StatelessWidget {
  const CountryFilter({super.key});

  static const _options = ['All', 'UAE', 'Saudi Arabia', 'Qatar'];

  String _label(BuildContext context, String value) {
    final t = context.s;
    switch (value) {
      case 'UAE':
        return t.uae;
      case 'Saudi Arabia':
        return t.saudi;
      case 'Qatar':
        return t.qatar;
      default:
        return t.all;
    }
  }

  @override
  Widget build(BuildContext context) {
    final selected = context.select<JobListProvider, String>((p) => p.country);

    return SizedBox(
      height: 56,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        children: _options
            .map((o) => Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                  child: ChoiceChip(
                    label: Text(_label(context, o)),
                    selected: selected == o,
                    onSelected: (_) =>
                        context.read<JobListProvider>().setCountry(o),
                  ),
                ))
            .toList(),
      ),
    );
  }
}
