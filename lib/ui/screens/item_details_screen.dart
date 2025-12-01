import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/fridge/data/fridge_item.dart';
import '../../features/fridge/data/fridge_repository.dart';

class ItemDetailsScreen extends StatelessWidget {
  final String itemId;

  const ItemDetailsScreen({super.key, required this.itemId});

  @override
  Widget build(BuildContext context) {
    final repo = FridgeRepository();
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Item Details"),
        actions: [
          // EDIT BUTTON
          IconButton(
            icon: const Icon(Icons.edit),
            tooltip: "Edit Item",
            onPressed: () {
              context.go('/edit-item/$itemId');
            },
          ),

          // DELETE BUTTON
          IconButton(
            icon: const Icon(Icons.delete),
            tooltip: "Delete Item",
            onPressed: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text("Delete Item"),
                  content: const Text(
                    "Are you sure you want to delete this item?",
                  ),
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
                await repo.deleteItem(itemId);

                if (context.mounted) {
                  context.go('/fridge');
                }
              }
            },
          ),
        ],
      ),

      body: FutureBuilder<FridgeItem?>(
        future: repo.getItemById(itemId),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final item = snapshot.data;
          if (item == null) {
            return const Center(
              child: Text("Item not found or was deleted."),
            );
          }

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
                    ],
                  ),

                  const SizedBox(height: 24),

                  // DETAILS CARDS
                  _infoCard("Quantity", "${item.quantity}"),
                  _infoCard("Container", item.containerType),
                  _infoCard(
                    "Expiration Date",
                    "${item.expiryDate.year}-${item.expiryDate.month}-${item.expiryDate.day}",
                  ),

                  if (item.openingDate != null)
                    _infoCard(
                      "Opening Date",
                      "${item.openingDate!.year}-${item.openingDate!.month}-${item.openingDate!.day}",
                    ),

                  if (item.expiryAfterOpeningDays != null)
                    _infoCard(
                      "Expires After Opening",
                      "${item.expiryAfterOpeningDays} days",
                    ),

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

  // UI Helper
  Widget _infoCard(String label, String value) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.grey.shade200,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              )),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}
