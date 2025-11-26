// lib/features/fridge/data/fridge_repository.dart
import 'package:flutter/foundation.dart';
import 'fridge_item.dart';

/// Simple in-memory repository for FridgeItem objects.
/// Uses a ValueNotifier so UI can listen without external state libraries.
class FridgeRepository {
  FridgeRepository._internal();

  static final FridgeRepository _instance = FridgeRepository._internal();
  factory FridgeRepository() => _instance;

  // The internal list (private).
  final ValueNotifier<List<FridgeItem>> _itemsNotifier = ValueNotifier<List<FridgeItem>>([]);

  /// Public read-only ValueListenable for UI to subscribe to.
  ValueListenable<List<FridgeItem>> get itemsListenable => _itemsNotifier;

  /// Current snapshot of items (convenience).
  List<FridgeItem> get items => List.unmodifiable(_itemsNotifier.value);

  /// Add an item and notify listeners.
  void addItem(FridgeItem item) {
    final current = List<FridgeItem>.from(_itemsNotifier.value);
    current.insert(0, item); // newest on top
    _itemsNotifier.value = current;
  }

  /// Update an existing item by id.
  void updateItem(FridgeItem item) {
    final current = List<FridgeItem>.from(_itemsNotifier.value);
    final idx = current.indexWhere((x) => x.id == item.id);
    if (idx >= 0) {
      current[idx] = item;
      _itemsNotifier.value = current;
    }
  }

  /// Remove item by id.
  void removeItemById(String id) {
    final current = List<FridgeItem>.from(_itemsNotifier.value);
    current.removeWhere((x) => x.id == id);
    _itemsNotifier.value = current;
  }

  /// Seed with sample items (optional for local testing).
  void seedSampleItems() {
    if (_itemsNotifier.value.isNotEmpty) return;
    final now = DateTime.now();
    addItem(FridgeItem(
      name: 'Fresh Milk',
      quantity: 2,
      expiryDate: now.add(const Duration(days: 3)),
      openingDate: now.subtract(const Duration(days: 1)),
      expiryAfterOpeningDays: 5,
      containerType: 'Carton',
      category: 'Drink',
    ));
    addItem(FridgeItem(
      name: 'Chicken Breast',
      quantity: 1,
      expiryDate: now.add(const Duration(days: 1)),
      openingDate: null,
      expiryAfterOpeningDays: null,
      containerType: 'Plastic Wrap',
      category: 'Meat',
    ));
  }
}
