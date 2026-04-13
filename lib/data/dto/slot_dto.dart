// slot_dto.dart
import 'package:velo_toulouse/model/slot.dart';

class SlotDto {
  static Slot fromFirestore(String id, Map<String, dynamic> json) {
    return Slot(
      slotId: id,
      slotNumber: json['slotNumber'],
      hasBike: json['hasBike'],
    );
  }

  static Map<String, dynamic> toFirestore(Slot slot) {
    return {
      'slotNumber': slot.slotNumber,
      'hasBike': slot.hasBike,
    };
  }
}