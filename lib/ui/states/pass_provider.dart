import 'package:flutter/material.dart';
import 'package:velo_toulouse/model/pass_type.dart';

class PassProvider extends ChangeNotifier {
  PassType _currentPass = PassType.none;
  DateTime? _activatedAt;

  PassType get currentPass => _currentPass;
  DateTime? get activatedAt => _activatedAt;
  DateTime? get expiresAt => _activatedAt != null ? _currentPass.expiresAt(_activatedAt!) : null;

  void switchPass(PassType newPass) {
    if (newPass == _currentPass) return;
    _currentPass = newPass;
    _activatedAt = newPass == PassType.none ? null : DateTime.now();
    notifyListeners();
  }
}