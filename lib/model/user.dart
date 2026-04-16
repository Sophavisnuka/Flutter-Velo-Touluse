import 'package:velo_toulouse/model/slot.dart';

class User {
  final String userId;
  final String userName;
  final String password;
  final Slot slotId;

  const User({
    required this.userId,
    required this.userName,
    required this.password,
    required this.slotId
  });
}