// lib/ui/screens/item_details_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/fridge/data/fridge_item.dart';
import '../../features/fridge/data/fridge_repository.dart';

class ItemDetailsScreen extends StatelessWidget {
  final String itemId;

  const ItemDetailsScreen({super.key, required this.itemId});

  String _formatDate(DateTime d) {
    return "${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}";
  }

  Color _expiryColor(BuildContext context, {required int daysLeft}) {
    if (daysLeft <= 1) return Colors.red;
    if (daysLeft <= 3) return Colors.orange;
    return Theme.of(context).colorScheme.primary;
  }

  @override
  Widget build(BuildContext context) {
    final repo = FridgeRepository();
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Item Details"),
        actions: [
          // Edit button (same hierarchy as delete)
          IconButton(
            icon: const Icon(Icons.edit),
            tooltip: "Edit Item",
            onPressed: () {
              context.go('/edit-item/$itemId');
            },
          ),

          // Delete button (same hierarchy)
          IconButton(
            icon: const Icon(Icons.delete),
            tooltip: "Delete Item",
            onPressed: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text("Delete Item"),
                  content:
                  const Text("Are you sure you want to delete this item?"),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text("Cancel"),
                    ),
                    FilledButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text("Delete"),
                    ),
                  ],
                ),
              );

              if (confirm == true) {
                try {
                  await repo.deleteItem(itemId);

                  // go back to fridge tab
                  if (context.mounted) {
                    context.go('/fridge');
                  }
                } catch (e) {
                  // show error snackbar but don't crash app
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Delete failed: $e')),
                    );
                  }
                }
              }
            },
          ),
        ],
      ),
      body: FutureBuilder<FridgeItem?>(
        future: repo.getItemById(itemId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final item = snapshot.data;

          if (item == null) {
            return const Center(child: Text("Item not found or was deleted."));
          }

          final daysLeft = item.daysLeft;

          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // NAME
                  Text(
                    item.name,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // CATEGORY ROW
                  Row(
                    children: [
                      Icon(Icons.category_outlined,
                          color: theme.colorScheme.primary),
                      const SizedBox(width: 8),
                      Text(
                        item.category,
                        style: theme.textTheme.titleMedium,
                      ),
                      const SizedBox(width: 12),
                      Chip(
                        label: Text(
                          daysLeft < 0 ? 'Expired' : '$daysLeft days left',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        backgroundColor: _expiryColor(context, daysLeft: daysLeft),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // DATA FIELDS
                  _infoCard("Quantity", "${item.quantity}"),
                  _infoCard("Container", item.containerType),
                  _infoCard("Expiration Date", _formatDate(item.expiryDate)),

                  if (item.openingDate != null)
                    _infoCard("Opening Date", _formatDate(item.openingDate!)),

                  if (item.expiryAfterOpeningDays != null)
                    _infoCard(
                        "Expires After Opening", "${item.expiryAfterOpeningDays} days"),

                  if (item.notes != null && item.notes!.isNotEmpty)
                    _infoCard("Notes", item.notes!),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // Reusable info card
  Widget _infoCard(String label, String value) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.grey.shade100,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style:
              const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          const SizedBox(height: 6),
          Text(value, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}
