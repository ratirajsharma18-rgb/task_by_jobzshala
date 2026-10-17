import 'dart:math';
import '../models/job_master.dart';

class ApiException implements Exception {
  final int statusCode;
  final String message;
  ApiException(this.statusCode, this.message);

  @override
  String toString() => 'ApiException($statusCode): $message';
}

class JobPage {
  final List<JobModel> jobs;
  final bool hasMore;
  JobPage(this.jobs, this.hasMore);
}

class MockApi {
  static const pageSize = 20;

  final _random = Random();
  late final List<JobModel> _jobs = _makeJobs();

  Future<void> _fakeNetwork() async {
    await Future.delayed(Duration(milliseconds: 800 + _random.nextInt(701)));
    if (_random.nextInt(5) == 0) {
      throw ApiException(500, 'Server error');
    }
  }

  Future<JobPage> getMatches({String country = 'All', int page = 1}) async {
    await _fakeNetwork();

    final list = _jobs
        .where((j) => country == 'All' || j.country == country)
        .toList()
      ..sort((a, b) => b.matchScore.compareTo(a.matchScore));

    final start = (page - 1) * pageSize;
    if (start >= list.length) return JobPage([], false);
    final end = min(start + pageSize, list.length);

    return JobPage(list.sublist(start, end), end < list.length);
  }

  Future<JobModel> getJob(String id) async {
    await _fakeNetwork();
    return _jobs.firstWhere(
      (j) => j.id == id,
      orElse: () => throw ApiException(404, 'Job not found'),
    );
  }

  Future<Map<String, dynamic>> applyToJob(String id) async {
    await _fakeNetwork();
    return {'status': 'APPLIED'};
  }

  List<JobModel> _makeJobs() {
    final rnd = Random(42);

    final types = [
      ('Heavy Truck Driver', 'Logistics company',
          ['Heavy vehicle', 'GCC licence', 'Route planning']),
      ('Site Electrician', 'Construction company',
          ['Wiring', 'Panel work', 'Safety']),
      ('Hotel Housekeeper', 'Hospitality group',
          ['Cleaning', 'Teamwork', 'Time management']),
      ('Welder', 'Fabrication company',
          ['Arc welding', 'MIG welding', 'Blueprint reading']),
      ('Security Guard', 'Security company',
          ['Patrolling', 'CCTV', 'Communication']),
      ('Plumber', 'Facility company',
          ['Pipe fitting', 'Leak repair', 'Sanitary work']),
    ];

    final places = {
      'UAE': ['Dubai', 'Abu Dhabi', 'Sharjah'],
      'Saudi Arabia': ['Riyadh', 'Jeddah', 'Dammam'],
      'Qatar': ['Doha', 'Al Wakrah'],
    };
    final countryNames = places.keys.toList();

    return List.generate(220, (i) {
      final type = types[rnd.nextInt(types.length)];
      final country = countryNames[rnd.nextInt(countryNames.length)];
      final cities = places[country]!;
      final years = 2 + rnd.nextInt(8);
      final salaryMin = 1200 + rnd.nextInt(30) * 100;

      return JobModel(
        id: 'job_${1000 + i}',
        title: type.$1,
        employerDisplay: '${type.$2}, $country',
        country: country,
        city: cities[rnd.nextInt(cities.length)],
        salaryMin: salaryMin,
        salaryMax: salaryMin + 500,
        matchScore:
            double.parse((40 + rnd.nextDouble() * 58).toStringAsFixed(1)),
        matchReason: '$years years of experience as ${type.$1.toLowerCase()}',
        skills: type.$3,
        benefits: BenefitsModel(
          accommodation: rnd.nextBool(),
          food: rnd.nextBool(),
          visa: rnd.nextInt(10) > 1,
        ),
        description: 'We are hiring a ${type.$1.toLowerCase()}. '
            'Work with a good team and get a stable monthly salary.',
        requirements: ['$years+ years experience', 'Valid certificate or licence'],
        postedAt: DateTime.now()
            .subtract(Duration(days: rnd.nextInt(30)))
            .toUtc()
            .toIso8601String(),
      );
    });
  }
}
