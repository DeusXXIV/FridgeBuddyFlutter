import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/fridge/data/fridge_item.dart';
import '../../features/fridge/data/fridge_repository.dart';

class AddItemScreen extends StatefulWidget {
  const AddItemScreen({super.key});

  @override
  State<AddItemScreen> createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> {
  final _nameCtrl = TextEditingController();
  final _qtyCtrl = TextEditingController(text: "1");
  final _containerCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();

  final FridgeRepository _repo = FridgeRepository();

  DateTime? manufacturingDate;
  DateTime? openingDate;
  DateTime? expiryDate;
  int? expiryAfterOpeningDays;

  final List<String> categories = [
    "Drink",
    "Meat",
    "Vegetable",
    "Condiment",
    "Sauce",
    "Powder",
    "Snack",
    "Others",
  ];

  String? selectedCategory;

  final List<String> containers = [
    "Bottle",
    "Carton",
    "Jar",
    "Plastic Wrap",
    "Can",
    "Sachet",
    "Tupperware",
    "Others",
  ];

  Future<void> pickDate(BuildContext context, Function(DateTime) onSelected) async {
    final now = DateTime.now();
    final result = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (result != null) {
      onSelected(result);
      setState(() {});
    }
  }

  bool get isValid {
    return _nameCtrl.text.trim().isNotEmpty &&
        expiryDate != null &&
        selectedCategory != null;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Item"),
        actions: [
          IconButton(
            icon: const Icon(Icons.qr_code_scanner),
            tooltip: "Scan Barcode",
            onPressed: () {
              // TODO: Implement scanner route
            },
          )
        ],
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 650),
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                // ITEM NAME
                TextField(
                  controller: _nameCtrl,
                  decoration: const InputDecoration(
                    labelText: "Item Name *",
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (_) => setState(() {}),
                ),
                const SizedBox(height: 20),

                // QUANTITY
                TextField(
                  controller: _qtyCtrl,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: "Quantity",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),

                // CATEGORY
                DropdownButtonFormField<String>(
                  value: selectedCategory,
                  decoration: const InputDecoration(
                    labelText: "Category *",
                    border: OutlineInputBorder(),
                  ),
                  items: categories
                      .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                      .toList(),
                  onChanged: (value) {
                    selectedCategory = value;
                    setState(() {});
                  },
                ),
                const SizedBox(height: 20),

                // CONTAINER
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: "Container Type",
                    border: OutlineInputBorder(),
                  ),
                  items: containers
                      .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                      .toList(),
                  onChanged: (v) => setState(() => _containerCtrl.text = v ?? ""),
                ),
                const SizedBox(height: 20),

                // MANUFACTURING DATE
                _dateTile(
                  context,
                  label: "Manufacturing Date",
                  value: manufacturingDate,
                  onPick: () => pickDate(context, (d) => manufacturingDate = d),
                ),
                const SizedBox(height: 10),

                // OPENING DATE
                _dateTile(
                  context,
                  label: "Opening Date",
                  value: openingDate,
                  onPick: () => pickDate(context, (d) => openingDate = d),
                ),
                const SizedBox(height: 10),

                // EXPIRY AFTER OPENING
                TextField(
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: "Expiry After Opening (days)",
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (v) {
                    expiryAfterOpeningDays = int.tryParse(v);
                  },
                ),
                const SizedBox(height: 20),

                // EXPIRATION DATE
                _dateTile(
                  context,
                  label: "Expiration Date *",
                  value: expiryDate,
                  onPick: () => pickDate(context, (d) {
                    expiryDate = d;
                    setState(() {});
                  }),
                ),
                const SizedBox(height: 20),

                // NOTES — keep THIS version only
                TextField(
                  maxLines: 3,
                  controller: _notesCtrl,
                  decoration: const InputDecoration(
                    labelText: "Notes",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 40),

                // SUBMIT BUTTON
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: isValid
                        ? () {
                      final item = FridgeItem(
                        name: _nameCtrl.text.trim(),
                        quantity: int.tryParse(_qtyCtrl.text.trim()) ?? 1,
                        expiryDate: expiryDate!,
                        openingDate: openingDate,
                        expiryAfterOpeningDays: expiryAfterOpeningDays,
                        containerType: _containerCtrl.text.trim().isEmpty
                            ? 'Others'
                            : _containerCtrl.text.trim(),
                        category: selectedCategory ?? 'Others',
                        notes: _notesCtrl.text.trim().isEmpty
                            ? null
                            : _notesCtrl.text.trim(),
                      );

                      _repo.addItem(item);

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Item added')),
                      );

                      context.go('/fridge');
                    }
                        : null,
                    child: const Padding(
                      padding: EdgeInsets.all(14.0),
                      child: Text("Save Item"),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _dateTile(
      BuildContext context, {
        required String label,
        required DateTime? value,
        required VoidCallback onPick,
      }) {
    return InkWell(
      onTap: onPick,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade400),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Text(label),
            const Spacer(),
            Text(
              value == null ? "Select" : "${value.year}-${value.month}-${value.day}",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 10),
            const Icon(Icons.calendar_month),
          ],
        ),
      ),
    );
  }
}
