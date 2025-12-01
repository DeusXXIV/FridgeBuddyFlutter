// lib/features/fridge/data/fridge_repository.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'fridge_item.dart';

/// Firestore-backed repository for fridge items.
class FridgeRepository {
  FridgeRepository._internal();
  static final FridgeRepository _instance = FridgeRepository._internal();
  factory FridgeRepository() => _instance;

  final CollectionReference<Map<String, dynamic>> _collection =
  FirebaseFirestore.instance.collection('fridgeItems');

  /// Stream all items, real-time.
  Stream<List<FridgeItem>> watchItems() {
    return _collection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = Map<String, dynamic>.from(doc.data());
        data['id'] = doc.id;
        return FridgeItem.fromMap(data);
      }).toList();
    });
  }

  /// Get all items once.
  Future<List<FridgeItem>> getItemsOnce() async {
    final snapshot = await _collection.get();
    return snapshot.docs.map((doc) {
      final data = Map<String, dynamic>.from(doc.data());
      data['id'] = doc.id;
      return FridgeItem.fromMap(data);
    }).toList();
  }

  /// Try to fetch an item by document id. Returns null if not found.
  Future<FridgeItem?> getItemById(String id) async {
    final doc = await _collection.doc(id).get();
    if (!doc.exists) return null;
    final data = Map<String, dynamic>.from(doc.data()!);
    data['id'] = doc.id;
    return FridgeItem.fromMap(data);
  }

  /// Try to locate an item by id first, if not found try matching on name or encoded name.
  /// This mirrors the old behavior where routes used either the document id or encoded name.
  Future<FridgeItem?> getItemByIdOrName(String idOrName) async {
    // 1) Try direct doc id
    final byId = await getItemById(idOrName);
    if (byId != null) return byId;

    // 2) Try query by name (exact)
    final q1 = await _collection.where('name', isEqualTo: idOrName).limit(1).get();
    if (q1.docs.isNotEmpty) {
      final data = Map<String, dynamic>.from(q1.docs.first.data());
      data['id'] = q1.docs.first.id;
      return FridgeItem.fromMap(data);
    }

    // 3) Try query by decoded (URL-encoded) name; many routes use Uri.encodeComponent(name).
    final decoded = Uri.decodeComponent(idOrName);
    final q2 = await _collection.where('name', isEqualTo: decoded).limit(1).get();
    if (q2.docs.isNotEmpty) {
      final data = Map<String, dynamic>.from(q2.docs.first.data());
      data['id'] = q2.docs.first.id;
      return FridgeItem.fromMap(data);
    }

    // not found
    return null;
  }

  /// Add new fridge item.
  Future<void> addItem(FridgeItem item) async {
    // Use the item.id as the document id so routes and local objects line up.
    await _collection.doc(item.id).set(item.toMap());
  }

  /// Update existing fridge item.
  Future<void> updateItem(FridgeItem item) async {
    await _collection.doc(item.id).update(item.toMap());
  }

  /// Delete an item.
  Future<void> removeItem(String id) async {
    await _collection.doc(id).delete();
  }
}
