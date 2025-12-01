import 'package:cloud_firestore/cloud_firestore.dart';
import 'fridge_item.dart';

class FridgeRepository {
  FridgeRepository._internal();
  static final FridgeRepository _instance = FridgeRepository._internal();
  factory FridgeRepository() => _instance;

  final CollectionReference<Map<String, dynamic>> _col =
  FirebaseFirestore.instance.collection('fridgeItems');

  /// 🔥 Stream ALL items (sorted by expiryDate)
  Stream<List<FridgeItem>> watchAllItems() {
    return _col
        .orderBy('expiryDate')
        .snapshots()
        .map((snap) => snap.docs
        .map((doc) => FridgeItem.fromMap(doc.data()))
        .toList());
  }

  /// 🔥 Get a single item by Firestore ID
  Future<FridgeItem?> getItemById(String id) async {
    final doc = await _col.doc(id).get();
    if (!doc.exists) return null;
    return FridgeItem.fromMap(doc.data()!);
  }

  /// 🔥 Add item
  Future<void> addItem(FridgeItem item) async {
    await _col.doc(item.id).set(item.toMap());
  }

  /// 🔥 Update item
  Future<void> updateItem(FridgeItem item) async {
    await _col.doc(item.id).update(item.toMap());
  }

  /// 🔥 Delete item
  Future<void> deleteItem(String id) async {
    await _col.doc(id).delete();
  }
}
