import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/s.dart';
import '../providers/connectivity_provider.dart';
import '../providers/job_list_provider.dart';
import '../widgets/country_filter.dart';
import '../widgets/job_card.dart';
import '../widgets/language_button.dart';
import '../widgets/offline_banner.dart';
import '../widgets/state_views.dart';
import 'job_detail_screen.dart';

class JobListScreen extends StatefulWidget {
  const JobListScreen({super.key});

  @override
  State<JobListScreen> createState() => _JobListScreenState();
}

class _JobListScreenState extends State<JobListScreen> {
  final _controller = ScrollController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onScroll);
  }

  void _onScroll() {
    if (_controller.position.extentAfter < 400) {
      context.read<JobListProvider>().loadMore();
    }
  }

  Future<void> _refresh() async {
    final ok = await context.read<JobListProvider>().refresh();
    if (!ok && mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(context.s.refreshFailed)));
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<JobListProvider>();
    final offline = context.watch<ConnectivityProvider>().isOffline;

    return Scaffold(
      appBar: AppBar(
        title: Text(context.s.appTitle),
        actions: const [LanguageButton()],
      ),
      body: Column(
        children: [
          if (offline) const OfflineBanner(),
          const CountryFilter(),
          Expanded(child: _body(provider)),
        ],
      ),
    );
  }

  Widget _body(JobListProvider provider) {
    switch (provider.state) {
      case ViewState.loading:
        return const JobListSkeleton();

      case ViewState.error:
        return ErrorView(onRetry: () => context.read<JobListProvider>().load());

      case ViewState.empty:
        // a ListView so pull-to-refresh also works on the empty screen
        return RefreshIndicator(
          onRefresh: _refresh,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            children: const [SizedBox(height: 120), EmptyView()],
          ),
        );

      case ViewState.success:
        final jobs = provider.jobs;
        final showFooter = provider.hasMore || provider.loadMoreFailed;

        return RefreshIndicator(
          onRefresh: _refresh,
          child: ListView.builder(
            controller: _controller,
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: jobs.length + (showFooter ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == jobs.length) {
                return ListFooter(
                  failed: provider.loadMoreFailed,
                  onRetry: () => context.read<JobListProvider>().loadMore(),
                );
              }
              final job = jobs[index];
              return RepaintBoundary(
                child: JobCard(
                  key: ValueKey(job.id),
                  job: job,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => JobDetailScreen(job: job)),
                  ),
                ),
              );
            },
          ),
        );
    }
  }
}
