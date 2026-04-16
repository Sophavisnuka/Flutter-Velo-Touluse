import 'package:velo_toulouse/model/pass_type.dart';

class User {
  final String userId;
  final String username;
  final PassType passType;
  final DateTime? activatedAt;

  const User({
    required this.userId,
    required this.username,
    required this.passType,
    this.activatedAt,
  });
}