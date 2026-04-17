class RideHistory {
  final String id;
  final String userId;
  final String startStationName;
  final String? endStationName;
  final DateTime startedAt;
  final DateTime? endedAt;
  final int? durationSeconds;

  const RideHistory({
    required this.id,
    required this.userId,
    required this.startStationName,
    this.endStationName,
    required this.startedAt,
    this.endedAt,
    this.durationSeconds,
  });

  bool get isActive => endedAt == null;

  Duration get duration {
    if (durationSeconds != null) return Duration(seconds: durationSeconds!);
    if (endedAt != null) return endedAt!.difference(startedAt);
    return DateTime.now().difference(startedAt);
  }
}
