// lib/ui/screens/item_details_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/fridge/data/fridge_item.dart';
import '../../features/fridge/data/fridge_repository.dart';

class ItemDetailsScreen extends StatelessWidget {
  final String itemId;

  Widget _sectionHeader(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        text.toUpperCase(),
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.1,
          color: Colors.grey,
        ),
      ),
    );
  }

  Widget _settingsTile(
      BuildContext context, {
        required String title,
        required String value,
        Color? valueColor,
        Widget? trailing,
      }) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Row(
        children: [
          Text(title, style: theme.textTheme.bodyLarge),
          const Spacer(),
          Text(
            value,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: valueColor ?? theme.colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
          if (trailing != null) ...[
            const SizedBox(width: 10),
            trailing,
          ],
        ],
      ),
    );
  }

  Map<String, dynamic> _mockItemMap() {
    return {
      "name": "Chicken Breast",
      "category": "Meat",
      "container": "Plastic Wrap",
      "quantity": 1,
      "expiry": "Jan 22, 2025",
      "daysLeft": 1,
      "opened": false,
      "openingDate": null,
      "openDays": null,
      "reminders": 2,
      "notes": "Use for lunch meal prep.",
    };
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final repo = FridgeRepository();

    return FutureBuilder<FridgeItem?>(
      future: repo.getItemById(itemId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(title: const Text('Item')),
            body: Center(child: Text('Error: ${snapshot.error}')),
          );
        }

        final item = snapshot.data;
        if (item == null) {
          // not found
          return Scaffold(
            appBar: AppBar(title: const Text('Item')),
            body: Center(child: Text('Item not found', style: theme.textTheme.bodyLarge)),
          );
        }

        // Build UI with `item`
        return Scaffold(
          appBar: AppBar(
            title: Text(item.name),
            actions: [
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {
                  // TODO: Open edit item screen
                },
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline),
                onPressed: () {
                  // TODO: delete item dialog
                },
              ),
            ],
          ),
          body: SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 600),
                child: ListView(
                  padding: const EdgeInsets.all(24),
                  children: [
                    // SECTION: BASIC INFO
                    _sectionHeader("Basic Information"),
                    _settingsTile(
                      context,
                      title: "Item Name",
                      value: item.name,
                    ),
                    _settingsTile(
                      context,
                      title: "Category",
                      value: item.category,
                    ),
                    _settingsTile(
                      context,
                      title: "Container Type",
                      value: item.containerType,
                    ),
                    const SizedBox(height: 28),

                    // SECTION: QUANTITY
                    _sectionHeader("Quantity"),
                    _settingsTile(
                      context,
                      title: "Quantity",
                      value: item.quantity.toString(),
                      trailing: const Icon(Icons.add_circle_outline),
                    ),
                    const SizedBox(height: 28),

                    // SECTION: DATE INFO
                    _sectionHeader("Dates"),
                    _settingsTile(
                      context,
                      title: "Expiration Date",
                      value: _formatDate(item.expiryDate),
                      valueColor: _expiryColor(context, daysLeft: item.daysLeft),
                    ),
                    if (item.openingDate != null)
                      _settingsTile(
                        context,
                        title: "Opening Date",
                        value: _formatDate(item.openingDate!),
                      ),
                    if (item.expiryAfterOpeningDays != null)
                      _settingsTile(
                        context,
                        title: "Expires After Opening",
                        value: "${item.expiryAfterOpeningDays} days",
                      ),
                    const SizedBox(height: 28),

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
