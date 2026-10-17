class BenefitsModel {
  final bool accommodation;
  final bool food;
  final bool visa;

  const BenefitsModel({
    required this.accommodation,
    required this.food,
    required this.visa,
  });

  factory BenefitsModel.fromJson(Map<String, dynamic> json) => BenefitsModel(
        accommodation: json['accommodation'] as bool,
        food: json['food'] as bool,
        visa: json['visa'] as bool,
      );

  Map<String, dynamic> toJson() => {
        'accommodation': accommodation,
        'food': food,
        'visa': visa,
      };
}

class JobModel {
  final String id;
  final String title;
  final String employerDisplay;
  final String country;
  final String city;
  final int salaryMin;
  final int salaryMax;
  final double matchScore;
  final String matchReason;
  final List<String> skills;
  final BenefitsModel benefits;
  final String description;
  final List<String> requirements;
  final String postedAt;

  const JobModel({
    required this.id,
    required this.title,
    required this.employerDisplay,
    required this.country,
    required this.city,
    required this.salaryMin,
    required this.salaryMax,
    required this.matchScore,
    required this.matchReason,
    required this.skills,
    required this.benefits,
    required this.description,
    required this.requirements,
    required this.postedAt,
  });

  /// "2,800 – 3,500"
  String get salaryText => '${_format(salaryMin)} – ${_format(salaryMax)}';

  /// 87.5 -> "88%"
  String get matchText => '${matchScore.round()}%';

  static String _format(int n) => n
      .toString()
      .replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (m) => ',');

  factory JobModel.fromJson(Map<String, dynamic> json) => JobModel(
        id: json['id'] as String,
        title: json['title'] as String,
        employerDisplay: json['employer_display'] as String,
        country: json['country'] as String,
        city: json['city'] as String,
        salaryMin: json['salary_min_aed'] as int,
        salaryMax: json['salary_max_aed'] as int,
        matchScore: (json['match_score'] as num).toDouble(),
        matchReason: json['match_reason'] as String,
        skills: List<String>.from(json['skills'] as List),
        benefits: BenefitsModel.fromJson(json['benefits'] as Map<String, dynamic>),
        description: json['description'] as String,
        requirements: List<String>.from(json['requirements'] as List),
        postedAt: json['posted_at'] as String,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'employer_display': employerDisplay,
        'country': country,
        'city': city,
        'salary_min_aed': salaryMin,
        'salary_max_aed': salaryMax,
        'match_score': matchScore,
        'match_reason': matchReason,
        'skills': skills,
        'benefits': benefits.toJson(),
        'description': description,
        'requirements': requirements,
        'posted_at': postedAt,
      };
}
