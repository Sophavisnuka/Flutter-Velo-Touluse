import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:velo_toulouse/data/dto/user_dto.dart';
import 'package:velo_toulouse/data/repositories/users/abstract_user_repo.dart';
import 'package:velo_toulouse/model/user.dart';
import 'package:velo_toulouse/util/pass_type_convert.dart';

class UserRepository implements AbstractUserRepository {

  final FirebaseFirestore firestore;

  const UserRepository({
    required this.firestore
  });
  
  @override
  Future<User?> getUser(String userId) async {
    final data = await firestore.collection('users').doc(userId).get();

    if(!data.exists) {
      return null;
    }

    return UserDto.fromFirestore(data.id, data.data()!);
  }

  @override
  Future<void> createUser(User users) async {
    await firestore
      .collection('users')
      .doc(users.userId)
      .set(UserDto.toFirestore(users));
  }

  @override
  Future<void> updatePass(User user) async {
    await firestore
      .collection('users')
      .doc(user.userId)
      .update({
        'passType': PassTypeConvert.passTypeToString(user.passType),
        'activatedAt': user.activatedAt,
      });
  }
}
