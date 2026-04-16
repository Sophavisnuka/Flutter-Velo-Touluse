import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class LocalUserStorage {
  static const String _userIdKey = 'user_id';

  static Future<String> getOrCreateUserId() async {
    final prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString(_userIdKey);

    if (userId == null) {
      userId = const Uuid().v4();
      await prefs.setString(_userIdKey, userId);
    }

    return userId;
  }
}