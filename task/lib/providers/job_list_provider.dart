import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/mock_api.dart';
import '../models/job_master.dart';
import 'connectivity_provider.dart';

enum ViewState { loading, success, empty, error }

class JobListProvider extends ChangeNotifier {
  static const _cacheKey = 'cached_jobs';

  final MockApi _api;
  final ConnectivityProvider _conn;

  JobListProvider(this._api, this._conn) {
    _wasOffline = _conn.isOffline;
    _conn.addListener(_onConnectivityChanged);
  }

  ViewState _state = ViewState.loading;
  String _country = 'All';
  List<JobModel> _jobs = [];
  int _page = 1;
  bool _hasMore = true;
  bool _loadingMore = false;
  bool _loadMoreFailed = false;
  bool _wasOffline = false;

  int _reqId = 0;

  final Map<String, JobModel> _cache = {};

  ViewState get state => _state;
  String get country => _country;
  List<JobModel> get jobs => _jobs;
  bool get hasMore => _hasMore;
  bool get loadingMore => _loadingMore;
  bool get loadMoreFailed => _loadMoreFailed;

  Future<void> start() async {
    await _loadCache();
    await load();
  }

  void _onConnectivityChanged() {
    if (_wasOffline && !_conn.isOffline) load(); // back online -> reload
    _wasOffline = _conn.isOffline;
  }

  Future<void> load() async {
    final id = ++_reqId;
    _state = ViewState.loading;
    _loadingMore = false;
    notifyListeners();

    if (_conn.isOffline) {
      _showCached();
      return;
    }

    try {
      final page = await _api.getMatches(country: _country, page: 1);
      if (id != _reqId) return;
      _setFirstPage(page);
    } on ApiException {
      if (id != _reqId) return;
      _state = ViewState.error;
      notifyListeners();
    }
  }

  Future<bool> refresh() async {
    if (_conn.isOffline) return true;
    final id = ++_reqId;
    try {
      final page = await _api.getMatches(country: _country, page: 1);
      if (id != _reqId) return true;
      _setFirstPage(page);
      return true;
    } on ApiException {
      return false;
    }
  }

  Future<void> loadMore() async {
    if (_loadingMore || !_hasMore || _state != ViewState.success) return;
    if (_conn.isOffline) return;

    final id = _reqId;
    _loadingMore = true;
    _loadMoreFailed = false;
    notifyListeners();

    try {
      final page = await _api.getMatches(country: _country, page: _page + 1);
      if (id != _reqId) return;
      _page++;
      _jobs = [..._jobs, ...page.jobs];
      _hasMore = page.hasMore;
      _addToCache(page.jobs);
    } on ApiException {
      if (id != _reqId) return;
      _loadMoreFailed = true;
    }
    _loadingMore = false;
    notifyListeners();
  }

  void setCountry(String country) {
    if (country == _country) return;
    _country = country;
    load();
  }

  void _setFirstPage(JobPage page) {
    _jobs = [...page.jobs];
    _page = 1;
    _hasMore = page.hasMore;
    _loadingMore = false;
    _loadMoreFailed = false;
    _addToCache(page.jobs);
    _state = _jobs.isEmpty ? ViewState.empty : ViewState.success;
    notifyListeners();
  }

  void _showCached() {
    _jobs = _cache.values
        .where((j) => _country == 'All' || j.country == _country)
        .toList()
      ..sort((a, b) => b.matchScore.compareTo(a.matchScore));
    _hasMore = false;
    if (_cache.isEmpty) {
      _state = ViewState.error; // nothing saved yet
    } else {
      _state = _jobs.isEmpty ? ViewState.empty : ViewState.success;
    }
    notifyListeners();
  }

  // ---- cache ----
  void _addToCache(List<JobModel> jobs) {
    for (final j in jobs) {
      _cache[j.id] = j;
    }
    _saveCache();
  }

  Future<void> _saveCache() async {
    final prefs = await SharedPreferences.getInstance();
    final data = _cache.values.map((j) => j.toJson()).toList();
    await prefs.setString(_cacheKey, jsonEncode(data));
  }

  Future<void> _loadCache() async {
    final prefs = await SharedPreferences.getInstance();
    final text = prefs.getString(_cacheKey);
    if (text == null) return;
    for (final item in jsonDecode(text) as List) {
      final job = JobModel.fromJson(item as Map<String, dynamic>);
      _cache[job.id] = job;
    }
  }

  @override
  void dispose() {
    _conn.removeListener(_onConnectivityChanged);
    super.dispose();
  }
}
