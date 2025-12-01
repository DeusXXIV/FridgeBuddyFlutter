// lib/features/fridge/data/fridge_repository.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'fridge_item.dart';

/// Firestore-backed repository for fridge items.
class FridgeRepository {
  FridgeRepository._internal();
  static final FridgeRepository _instance = FridgeRepository._internal();
  factory FridgeRepository() => _instance;

  final _db = FirebaseFirestore.instance;
  static const String collectionName = "fridgeItems";

  /// Stream of all fridge items (real-time updates)
  Stream<List<FridgeItem>> watchAllItems() {
    return _db
        .collection(collectionName)
        .orderBy("expiryDate")
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return FridgeItem.fromMap(data);
      }).toList();
    });
  }

  /// One-time fetch (if needed)
  Future<List<FridgeItem>> getAllItemsOnce() async {
    final snapshot =
    await _db.collection(collectionName).orderBy("expiryDate").get();

    return snapshot.docs
        .map((doc) => FridgeItem.fromMap(doc.data()))
        .toList();
  }
  /// Stream that emits the current list and subsequent changes.
  /// Used by UI StreamBuilder to watch live changes.
  Stream<List<FridgeItem>> watchAllItems() {
    return Stream<List<FridgeItem>>.multi((controller) {
      // push initial value
      controller.add(_itemsNotifier.value);

      // listener to push updates
      void listener() => controller.add(_itemsNotifier.value);

      _itemsNotifier.addListener(listener);

      // cleanup when no longer needed
      controller.onCancel = () {
        _itemsNotifier.removeListener(listener);
      };
    });
  }

  /// Return a single item by id (or null if not found).
  /// Keeps method async so callers can await database fetches later.
  Future<FridgeItem?> getItemById(String id) async {
    try {
      return _itemsNotifier.value.firstWhere((x) => x.id == id);
    } catch (_) {
      return null;
    }
  }

  /// Convenience: find by id OR encoded name (for older routes that might pass name).
  Future<FridgeItem?> getItemByIdOrName(String idOrName) async {
    // try exact id first
    final list = _itemsNotifier.value;
    try {
      return list.firstWhere((x) => x.id == idOrName);
    } catch (_) {}

    // try encoded name or plain name
    try {
      return list.firstWhere(
            (x) => Uri.encodeComponent(x.name) == idOrName || x.name == idOrName,
      );
    } catch (_) {
      return null;
    }
  }

  /// Add new item
  Future<void> addItem(FridgeItem item) async {
    await _db.collection(collectionName).doc(item.id).set(item.toMap());
  }

  /// Update
  Future<void> updateItem(FridgeItem item) async {
    await _db.collection(collectionName).doc(item.id).update(item.toMap());
  }

  /// Delete
  Future<void> removeItem(String id) async {
    await _db.collection(collectionName).doc(id).delete();
  }

  /// Get single item by ID (real-time)
  Stream<FridgeItem?> watchItem(String id) {
    return _db.collection(collectionName).doc(id).snapshots().map((doc) {
      if (!doc.exists) return null;
      return FridgeItem.fromMap(doc.data()!);
    });
  }
}
