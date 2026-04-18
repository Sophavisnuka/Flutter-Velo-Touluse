import 'package:velo_toulouse/model/user.dart';

abstract class AbstractUserRepository {
  Future<User?> getUser(String userId);
  Future<void> createUser(User user);
  Future<void> updatePass(User user);
}