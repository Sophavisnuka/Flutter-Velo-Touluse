import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:velo_toulouse/model/user.dart';
import 'package:velo_toulouse/util/pass_type_convert.dart';

class UserDto {
  static User fromFirestore(String id, Map<String, dynamic> json) {
    return User(
      userId: id,
      username: json['username'] ?? '',
      passType: PassTypeConvert.passTypeFromString(json['passType']),
      activatedAt: json['activatedAt'] != null ? (json['activatedAt'] as Timestamp).toDate() : null,
    );
  }

  static Map<String, dynamic> toFirestore(User user) {
    return {
      'username': user.username,
      'passType': PassTypeConvert.passTypeToString(user.passType),
      'activatedAt': user.activatedAt
    };
  }
}