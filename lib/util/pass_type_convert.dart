import 'package:velo_toulouse/model/pass_type.dart';

class PassTypeConvert {
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