import 'dart:convert';

class Reminder {
  final String id;
  final String itemId;
  final DateTime notifyAt;
  final String label; // e.g. "1 day before", "Custom", etc.
  final String? note;

  Reminder({
    required this.id,
    required this.itemId,
    required this.notifyAt,
    required this.label,
    this.note,
  });

  // Simple unique id
  static String generateId() {
    final ts = DateTime.now().microsecondsSinceEpoch;
    return "rem_$ts";
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'itemId': itemId,
      'notifyAt': notifyAt.toIso8601String(),
      'label': label,
      'note': note,
    };
  }

  factory Reminder.fromMap(Map<String, dynamic> map) {
    return Reminder(
      id: map['id'],
      itemId: map['itemId'],
      notifyAt: DateTime.parse(map['notifyAt']),
      label: map['label'],
      note: map['note'],
    );
  }

  String toJson() => json.encode(toMap());
  factory Reminder.fromJson(String source) =>
      Reminder.fromMap(json.decode(source));
}
