import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:velo_toulouse/model/pass_type.dart';
import 'package:velo_toulouse/model/user.dart';

class UserDto {
  static User fromFirestore(String id, Map<String, dynamic> json) {
    return User(
      userId: id,
      username: json['username'] ?? '',
      passType: passTypeFromString(json['passType']),
      activatedAt: json['activatedAt'] != null ? (json['activatedAt'] as Timestamp).toDate() : null,
    );
  }

  static Map<String, dynamic> toFirestore(User user) {
    return {
      'username': user.username,
      'passType': passTypeToString(user.passType),
      'activatedAt': user.activatedAt
    };
  }

  /// Convert String -> Enum
  static PassType passTypeFromString(String? value) {
    switch (value) {
      case 'day':
        return PassType.day;
      case 'monthly':
        return PassType.monthly;
      case 'yearly':
        return PassType.yearly;
      default:
        return PassType.none;
    }
  }

  /// Convert Enum -> String
  static String passTypeToString(PassType type) {
    switch (type) {
      case PassType.day:
        return 'day';
      case PassType.monthly:
        return 'monthly';
      case PassType.yearly:
        return 'yearly';
      case PassType.none:
        return 'none';
    }
  }
}