import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'fridge_item.dart';

/// Firestore-backed repository.
/// Keeps a local ValueNotifier in sync with Firestore in real time.
class FridgeRepository {
  FridgeRepository._internal() {
    _listenToFirestore();
  }

  static final FridgeRepository _instance = FridgeRepository._internal();
  factory FridgeRepository() => _instance;

  final _db = FirebaseFirestore.instance;

  /// Local notifier for UI updates
  final ValueNotifier<List<FridgeItem>> _itemsNotifier =
  ValueNotifier<List<FridgeItem>>([]);

  ValueListenable<List<FridgeItem>> get itemsListenable => _itemsNotifier;

  /// Convenience snapshot
  List<FridgeItem> get items => List.unmodifiable(_itemsNotifier.value);

  /// Firestore collection reference
  CollectionReference<Map<String, dynamic>> get col =>
      _db.collection('fridge_items');

  // --------------------------------------------------------
  // 🔥 REALTIME LISTENER (Firestore → app)
  // --------------------------------------------------------
  void _listenToFirestore() {
    col.orderBy('expiryDate').snapshots().listen((snap) {
      final list =
      snap.docs.map((doc) => FridgeItem.fromMap(doc.data())).toList();
      _itemsNotifier.value = list;
    });
  }

  // --------------------------------------------------------
  // 🔥 Add to Firestore
  // --------------------------------------------------------
  Future<void> addItem(FridgeItem item) async {
    await col.doc(item.id).set(item.toMap());
  }

  // --------------------------------------------------------
  // 🔥 Update Firestore item
  // --------------------------------------------------------
  Future<void> updateItem(FridgeItem item) async {
    await col.doc(item.id).set(item.toMap(), SetOptions(merge: true));
  }

  // --------------------------------------------------------
  // 🔥 Remove from Firestore
  // --------------------------------------------------------
  Future<void> removeItemById(String id) async {
    await col.doc(id).delete();
  }

  // --------------------------------------------------------
  // (Optional) Seed items — now writes to Firestore
  // --------------------------------------------------------
  Future<void> seedSampleItems() async {
    if (_itemsNotifier.value.isNotEmpty) return;
    final now = DateTime.now();

    await addItem(FridgeItem(
      name: 'Fresh Milk',
      quantity: 2,
      expiryDate: now.add(const Duration(days: 3)),
      openingDate: now.subtract(const Duration(days: 1)),
      expiryAfterOpeningDays: 5,
      containerType: 'Carton',
      category: 'Drink',
    ));

    await addItem(FridgeItem(
      name: 'Chicken Breast',
      quantity: 1,
      expiryDate: now.add(const Duration(days: 1)),
      containerType: 'Plastic Wrap',
      category: 'Meat',
    ));
  }
}
