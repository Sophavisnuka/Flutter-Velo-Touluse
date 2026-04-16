import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:velo_toulouse/data/dto/user_dto.dart';
import 'package:velo_toulouse/model/user.dart';

class UserRepository {

  final FirebaseFirestore firestore;

  const UserRepository({
    required this.firestore
  });

  Future<User?> getUser(String userId) async {
    final data = await firestore.collection('users').doc(userId).get();

    if(!data.exists) {
      return null;
    }

    return UserDto.fromFirestore(data.id, data.data()!);
  }

  Future<void> createUser(User users) async {
    await firestore
      .collection('users')
      .doc(users.userId)
      .set(UserDto.toFirestore(users));
  }

  Future<void> updatePass(User user) async {
    await firestore
      .collection('users')
      .doc(user.userId)
      .update({
        'passType': UserDto.passTypeToString(user.passType),
        'activatedAt': user.activatedAt,
      });
  }
}
