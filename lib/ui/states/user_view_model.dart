import 'package:flutter/material.dart';
import 'package:velo_toulouse/data/repositories/user_repository.dart';
import 'package:velo_toulouse/model/pass_type.dart';
import 'package:velo_toulouse/model/user.dart';

class UserViewModel extends ChangeNotifier {
  UserRepository repo;

  UserViewModel(this.repo);

  User? _user;
  bool _isLoading = false;

  User? get user => _user;
  bool get isLoading => _isLoading;
  PassType get currentPass => _user?.passType ?? PassType.none;  
  DateTime? get expiresAt => _user?.activatedAt != null
    ? currentPass.expiresAt(_user!.activatedAt!)
    : null;

  bool get isPassExpired {
    final exp = expiresAt;
    if (exp == null) return false;
    return DateTime.now().isAfter(exp);
  }

  Future<void> loadUser(String userId) async {
    _isLoading = true;
    notifyListeners();

    final existingUser = await repo.getUser(userId);

    if (existingUser != null) {
      _user = existingUser;
    } else {
      final newUser = User(
        userId: userId,
        username: 'Ronan the best',
        passType: PassType.none,
        activatedAt: null,
      );

      await repo.createUser(newUser);
      _user = newUser;
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> switchPlan(PassType newPass) async {
    if (_user == null) return;

    _isLoading = true;
    notifyListeners();

    final now = DateTime.now();

    _user = User(
      userId: _user!.userId,
      username: _user!.username,
      passType: newPass,
      activatedAt: now,
    );

    await repo.updatePass(_user!);

    _isLoading = false;
    notifyListeners();
  }
}
