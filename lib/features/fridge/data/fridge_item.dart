// lib/features/fridge/data/fridge_item.dart
// Clean FridgeItem model with reminderCount & daysLeft support.

import 'package:flutter/material.dart';
import 'dart:convert';

class FridgeItem {
  /// Unique id for routing / DB. Generated if not supplied.
  final String id;

  final String name;
  final int quantity;

  /// Absolute expiration date (the authoritative expiry date).
  final DateTime expiryDate;

  /// When the item was opened by the user (optional).
  final DateTime? openingDate;

  /// Number of days the item expires after opening (optional).
  final int? expiryAfterOpeningDays;

  /// Human readable container (e.g., "Jar", "Carton", "Tupperware")
  final String containerType;

  /// Category like "Drink", "Meat", "Condiment", etc.
  final String category;

  /// Optional free-form notes
  final String? notes;

  /// NEW — number of active reminders
  final int reminderCount;

  FridgeItem({
    String? id,
    required this.name,
    required this.quantity,
    required this.expiryDate,
    this.openingDate,
    this.expiryAfterOpeningDays,
    required this.containerType,
    required this.category,
    this.notes,
    this.reminderCount = 0, // default to 0
  }) : id = id ?? _generateId();

  // -------------------------
  // Helpers & business logic
  // -------------------------

  static String _generateId() {
    final now = DateTime.now().toUtc().microsecondsSinceEpoch;
    return 'fi_$now';
  }

  /// NEW — Days left until main expiration
  int get daysLeft {
    final now = DateTime.now();
    return expiryDate.difference(now).inDays;
  }

  int daysUntilExpiry({DateTime? from}) {
    final base = from ?? DateTime.now();
    return expiryDate.difference(base).inDays;
  }

  bool get isExpired => daysUntilExpiry() < 0;

  int? daysUntilOpenExpiry({DateTime? from}) {
    if (openingDate == null || expiryAfterOpeningDays == null) return null;

    final base = from ?? DateTime.now();
    final openExpiry =
    openingDate!.add(Duration(days: expiryAfterOpeningDays!));

    return openExpiry.difference(base).inDays;
  }

  bool get isOpenExpired {
    final d = daysUntilOpenExpiry();
    if (d == null) return false;
    return d < 0;
  }

  IconData get categoryIcon {
    switch (category.toLowerCase()) {
      case 'drink':
        return Icons.local_drink;
      case 'meat':
        return Icons.restaurant;
      case 'condiment':
        return Icons.soup_kitchen_outlined;
      case 'vegetable':
        return Icons.grass;
      case 'snack':
        return Icons.fastfood;
      default:
        return Icons.inventory_2_outlined;
    }
  }

  // -------------------------
  // Serialization
  // -------------------------

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'quantity': quantity,
      'expiryDate': expiryDate.toIso8601String(),
      'openingDate': openingDate?.toIso8601String(),
      'expiryAfterOpeningDays': expiryAfterOpeningDays,
      'containerType': containerType,
      'category': category,
      'notes': notes,
      'reminderCount': reminderCount, // NEW
    };
  }

  factory FridgeItem.fromMap(Map<String, dynamic> map) {
    DateTime? parseAny(dynamic v) {
      if (v == null) return null;
      if (v is DateTime) return v;
      if (v is String && v.isNotEmpty) return DateTime.parse(v);
      return null;
    }

    return FridgeItem(
      id: map['id'] as String?,
      name: map['name'] as String? ?? '',
      quantity: (map['quantity'] as num?)?.toInt() ?? 1,
      expiryDate: parseAny(map['expiryDate']) ?? DateTime.now(),
      openingDate: parseAny(map['openingDate']),
      expiryAfterOpeningDays:
      (map['expiryAfterOpeningDays'] as num?)?.toInt(),
      containerType: map['containerType'] as String? ?? '',
      category: map['category'] as String? ?? 'Others',
      notes: map['notes'] as String?,
      reminderCount: (map['reminderCount'] as num?)?.toInt() ?? 0, // NEW
    );
  }

  String toJson() => json.encode(toMap());

  factory FridgeItem.fromJson(String source) =>
      FridgeItem.fromMap(json.decode(source) as Map<String, dynamic>);

  // -------------------------
  // CopyWith
  // -------------------------
  FridgeItem copyWith({
    String? id,
    String? name,
    int? quantity,
    DateTime? expiryDate,
    DateTime? openingDate,
    int? expiryAfterOpeningDays,
    String? containerType,
    String? category,
    String? notes,
    int? reminderCount,
  }) {
    return FridgeItem(
      id: id ?? this.id,
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
      expiryDate: expiryDate ?? this.expiryDate,
      openingDate: openingDate ?? this.openingDate,
      expiryAfterOpeningDays:
      expiryAfterOpeningDays ?? this.expiryAfterOpeningDays,
      containerType: containerType ?? this.containerType,
      category: category ?? this.category,
      notes: notes ?? this.notes,
      reminderCount: reminderCount ?? this.reminderCount,
    );
  }

  @override
  String toString() {
    return 'FridgeItem(id: $id, name: $name, qty: $quantity, expiry: ${expiryDate.toIso8601String()}, reminders: $reminderCount)';
  }
}

// ---------------------------------------------------------------------------
// Category Icon Extension (UI Helper Only)
// ---------------------------------------------------------------------------

extension FridgeItemCategoryIcon on FridgeItem {
  IconData get categoryIcon {
    switch (category.toLowerCase()) {
      case 'drink':
        return Icons.local_drink;
      case 'meat':
        return Icons.restaurant;
      case 'condiment':
        return Icons.soup_kitchen_outlined;
      case 'vegetable':
        return Icons.grass;
      case 'snack':
        return Icons.fastfood;
      default:
        return Icons.inventory_2_outlined;
    }
  }
}
