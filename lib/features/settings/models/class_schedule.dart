class CollegeSchedule {
  final int numberOfClasses;
  final int durationMinutes;
  final List<SessionModel> schedules;

  const CollegeSchedule({
    required this.numberOfClasses,
    required this.durationMinutes,
    required this.schedules,
  });

  factory CollegeSchedule.fromMap(Map<String, dynamic> map) {
    return CollegeSchedule(
      numberOfClasses: map['numberOfClasses'] ?? 0,
      durationMinutes: map['durationMinutes'] ?? 0,
      schedules: (map['schedules'] as List<dynamic>? ?? [])
          .map((e) => SessionModel.fromMap(e))
          .toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'numberOfClasses': numberOfClasses,
      'durationMinutes': durationMinutes,
      'schedules': schedules.map((e) => e.toMap()).toList(),
    };
  }
}
class SessionModel {
  final int index;
  final int startMinute;
  final int endMinute;

  const SessionModel({
    required this.index,
    required this.startMinute,
    required this.endMinute,
  });

  factory SessionModel.fromMap(Map<String, dynamic> map) {
    return SessionModel(
      index: map['index'] ?? 0,
      startMinute: map['startMinute'] ?? 0,
      endMinute: map['endMinute'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'index': index,
      'startMinute': startMinute,
      'endMinute': endMinute,
    };
  }
}
