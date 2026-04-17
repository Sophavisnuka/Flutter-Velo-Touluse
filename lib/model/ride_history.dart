class RideHistory {
  final String id;
  final String userId;
  final String startStationName;
  final String? endStationName;
  final DateTime startedAt;
  final DateTime? endedAt;
  final int? durationMinutes;

  const RideHistory({
    required this.id,
    required this.userId,
    required this.startStationName,
    this.endStationName,
    required this.startedAt,
    this.endedAt,
    this.durationMinutes,
  });

  bool get isActive => endedAt == null;

  int get currentDuration => durationMinutes ?? DateTime.now().difference(startedAt).inMinutes;
}