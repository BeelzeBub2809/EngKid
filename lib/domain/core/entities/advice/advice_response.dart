import 'package:json_annotation/json_annotation.dart';

part 'advice_response.g.dart';

@JsonSerializable()
class AdviceResponse {
  final bool success;
  final String message;
  final int status;
  final dynamic errors;
  final AdviceData data;

  const AdviceResponse({
    required this.success,
    required this.message,
    required this.status,
    this.errors,
    required this.data,
  });

  factory AdviceResponse.fromJson(Map<String, dynamic> json) =>
      _$AdviceResponseFromJson(json);

  Map<String, dynamic> toJson() => _$AdviceResponseToJson(this);
}

@JsonSerializable()
class AdviceData {
  @JsonKey(name: 'kid_student_id')
  final int kidStudentId;
  @JsonKey(name: 'student_name')
  final String studentName;
  @JsonKey(name: 'grade_id')
  final int gradeId;
  final String period;
  @JsonKey(name: 'start_date')
  final String startDate;
  @JsonKey(name: 'end_date')
  final String endDate;
  final String advice;
  @JsonKey(name: 'learning_summary')
  final LearningSummary learningSummary;
  @JsonKey(name: 'class_comparison')
  final ClassComparison classComparison;
  @JsonKey(name: 'generated_at')
  final String generatedAt;

  const AdviceData({
    required this.kidStudentId,
    required this.studentName,
    required this.gradeId,
    required this.period,
    required this.startDate,
    required this.endDate,
    required this.advice,
    required this.learningSummary,
    required this.classComparison,
    required this.generatedAt,
  });

  factory AdviceData.fromJson(Map<String, dynamic> json) =>
      _$AdviceDataFromJson(json);

  Map<String, dynamic> toJson() => _$AdviceDataToJson(this);
}

@JsonSerializable()
class LearningSummary {
  @JsonKey(name: 'total_readings')
  final int totalReadings;
  @JsonKey(name: 'completed_readings')
  final int completedReadings;
  @JsonKey(name: 'passed_readings')
  final int passedReadings;
  @JsonKey(name: 'average_score')
  final int averageScore;
  @JsonKey(name: 'average_stars')
  final int averageStars;
  @JsonKey(name: 'completion_rate')
  final int completionRate;
  @JsonKey(name: 'pass_rate')
  final int passRate;
  @JsonKey(name: 'total_study_time')
  final int totalStudyTime;
  @JsonKey(name: 'improvement_trend')
  final int improvementTrend;
  @JsonKey(name: 'best_day')
  final String? bestDay;
  @JsonKey(name: 'best_time_slot')
  final String? bestTimeSlot;

  const LearningSummary({
    required this.totalReadings,
    required this.completedReadings,
    required this.passedReadings,
    required this.averageScore,
    required this.averageStars,
    required this.completionRate,
    required this.passRate,
    required this.totalStudyTime,
    required this.improvementTrend,
    this.bestDay,
    this.bestTimeSlot,
  });

  factory LearningSummary.fromJson(Map<String, dynamic> json) =>
      _$LearningSummaryFromJson(json);

  Map<String, dynamic> toJson() => _$LearningSummaryToJson(this);
}

@JsonSerializable()
class ClassComparison {
  final int classAverage;
  final int classRank;
  final int totalClassmates;
  final int percentile;
  final int studentAvgScore;

  const ClassComparison({
    required this.classAverage,
    required this.classRank,
    required this.totalClassmates,
    required this.percentile,
    required this.studentAvgScore,
  });

  factory ClassComparison.fromJson(Map<String, dynamic> json) =>
      _$ClassComparisonFromJson(json);

  Map<String, dynamic> toJson() => _$ClassComparisonToJson(this);
}
